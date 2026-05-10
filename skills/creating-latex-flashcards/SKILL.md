---
name: creating-latex-flashcards
description: Use when the user wants to create printable LaTeX flashcards (Avery 5388 index-card format) from a PDF for studying or learning, given a PDF file and a start/end page range.
---

# Creating LaTeX Flashcards

## Overview

Generates printable flashcards from a section of a PDF using the `flashcards` LaTeX class (Avery 5388 layout, with grid + frame). The preamble and card styles are fixed by `template.tex`; only the cards themselves are derived from the source text. To keep the main agent's context clean on long sources, extracted text is split into batches of at most 100 lines and each batch is drafted by its own subagent. The main agent only orchestrates: extraction, asking the user once for focus, dispatching batch subagents back-to-back, dispatching the compile subagent, and presenting a final summary.

This skill is an applied instance of the `subagent-driven-development` skill — read that skill if you need background on how to dispatch fresh subagents with curated context. The non-negotiable rule here: **the main agent MUST NOT draft any flashcards itself**. If you are about to write a `\begin{flashcard}` block in the main context, stop and dispatch a subagent instead.

## Required Inputs

Before doing anything else, make sure you have:

- Path to the PDF file
- Start page (1-based integer)
- End page (integer, greater than or equal to start)

If any are missing, ask the user once, then proceed.

## Workflow

Copy this checklist into your reply and tick items as you progress:

- [ ] Step 1: Extract text from the PDF page range
- [ ] Step 2: Summarise text and ask user for focus (only user interaction before dispatch)
- [ ] Step 3: Split extracted text into ≤100-line batches
- [ ] Step 4: (Subagents) Dispatch one drafting subagent per batch, back-to-back, no interruption
- [ ] Step 5: Merge batch outputs into a single `flashcards.tex`
- [ ] Step 6: (Subagent) Compile `.tex` and fix syntax errors
- [ ] Step 7: Present the PDF and a summary of created flashcards

### Step 1 — Extract text (main agent)

Run the extractor that ships with this skill:

    bash <skill-dir>/extract-pages-text.sh <pdf> <start> <end>

It writes `<pdf-basename>_pages<start>-<end>.txt` in the current working directory. Capture that exact filename — you will read it next.

### Step 2 — Summarise and gather user focus (main agent, ONLY user interaction before dispatch)

1. Read the extracted `.txt` only enough to summarise it; do not load the full content into the main context if it is large — a head/tail or section-header skim is enough.
2. Summarise the covered topics in 1–3 sentences for the user.
3. Ask the user exactly once: "Should the flashcards focus on specific topics / terms (please list them), or should all subagents create flashcards in a general manner covering everything?"
4. Wait for the user's answer. This is the LAST user interaction until Step 7 — after this point, batch subagents and the compile subagent must be dispatched back-to-back with NO further questions to the user.

### Step 3 — Split into batches (main agent)

1. Count the lines of `<pdf-basename>_pages<start>-<end>.txt`.
2. Split it into sequential batch files of at most 100 lines each, preserving line order. Try to break at blank lines or section boundaries when possible without exceeding 100 lines per batch.
3. Write batches as `<pdf-basename>_pages<start>-<end>_batch<NN>.txt` (zero-padded, starting at `01`) in the current directory. Record the total batch count `N`.
4. Do NOT read batch contents into the main context — only filenames and line counts.

### Step 4 — Dispatch drafting subagents (one per batch, back-to-back, NO interruption)

**Enforcement (read first):**

- This step is governed by the `subagent-driven-development` skill. Each batch is an independent task → one fresh subagent per batch, dispatched via the agent-dispatch tool available in this session (e.g. the `Task`/subagent tool). Inline drafting in the main agent is forbidden, even for a single batch or a "small" batch.
- Before doing anything else in Step 4, output to yourself the line: `Dispatching N drafting subagents for batches 1..N`. If you cannot dispatch subagents in this environment, STOP and report that to the user instead of silently drafting cards yourself — that is the failure mode this skill exists to prevent.
- Do not read the batch file contents in the main agent. The main agent only knows the batch filename, line count, and batch index. The subagent reads the raw text.
- Dispatch subagents sequentially (`i = 1, 2, …, N`), one after another, with NO user interaction, NO intermediate summarisation to the user, and NO main-agent drafting between them. Only the compact return value of each subagent enters the main context.
- If a subagent returns `BLOCKED` / `NEEDS_CONTEXT` (see `subagent-driven-development`), re-dispatch it with the missing context — do NOT take over its task in the main agent.

For each batch `i` from `1` to `N`, dispatch a fresh, independent subagent. Do not wait for user input between subagents and do not summarise intermediate results to the user; collect only the structured return value from each subagent into a private list.

Each subagent receives (curated context only — do not pass the main session history):

- Path to its batch file `<pdf-basename>_pages<start>-<end>_batch<NN>.txt`
- Batch index `i` and total `N`
- The user's focus answer from Step 2 (verbatim, including "general" if that was chosen)
- Path to `template.tex` in this skill folder
- Required output filename: `flashcards_<pdf-basename>_pages<start>-<end>_batch<NN>.tex.part`
- Deck title (shared across all batches), derived from PDF / page range / topic

Subagent task (drafting):

1. Read the assigned batch file in full.
2. Apply the user's focus: if specific topics were given, only emit cards relevant to those topics found in this batch (it is acceptable to return zero cards if nothing relevant appears); otherwise cover the batch generally.
3. Emit only `\begin{flashcard}[<category>]{<term>} ... \end{flashcard}` blocks — NO preamble, NO `\documentclass`, NO `\begin{document}`, NO `\cardfrontfoot`. The main agent assembles those once in Step 5.
   - Category examples: `[Definition]`, `[Concept]`, `[Formula]`, `[Process]`, `[Example]`.
   - Pick one of the three template card styles (A list, B centered prose with `\vspace{\fill}`, C short statement plus bullets) per card based on content shape; see `template.tex`.
   - One concept per card. Keep each card readable on a single Avery 5388 card; split overflow into multiple cards.
4. Escape LaTeX special characters from source text: `& % $ # _ { } ~ ^ \`. Use `amsmath` for math. Match the language of the source text.
5. Write the cards to `flashcards_<pdf-basename>_pages<start>-<end>_batch<NN>.tex.part`.
6. Return ONLY a compact structured result to the main agent:
   - batch index `i`
   - output `.tex.part` filename
   - integer count of cards produced
   - 1-line topical summary of what this batch covered (or "no relevant cards" if focus filtered everything out)

Rationale: per-batch subagents keep the main agent's context free of raw source text and per-card drafting churn; the main agent only sees compact return values.

**Dispatch prompt template** (use verbatim, fill the `<...>` slots, send as the subagent's full instructions — do not rely on inherited context):

    You are a drafting subagent for the `creating-latex-flashcards` skill.
    Batch <i> of <N>.
    Batch file: <pdf-basename>_pages<start>-<end>_batch<NN>.txt
    Template (read for card styles only, do NOT copy preamble): <skill-dir>/template.tex
    Output file (write only this): flashcards_<pdf-basename>_pages<start>-<end>_batch<NN>.tex.part
    Deck title: <DECK TITLE>
    User focus: <verbatim user answer from Step 2, or "general">

    Task: Read the batch file. Emit ONLY `\begin{flashcard}[<category>]{<term>} ... \end{flashcard}` blocks to the output file. No preamble, no `\documentclass`, no `\begin{document}`, no `\cardfrontfoot`. Escape LaTeX special characters (`& % $ # _ { } ~ ^ \`). One concept per card. Match the source language.

    Return ONLY: { batch: <i>, file: "<output filename>", cards: <int>, summary: "<one line>" }

Dispatch the next batch's subagent as soon as the previous one returns. Do not pause to explain progress to the user.

### Step 5 — Merge batch outputs (main agent)

1. Copy the preamble from `template.tex` verbatim (`\documentclass`, packages, `\cardfrontstyle`, `\cardbackstyle`).
2. Replace `\cardfrontfoot{<DECK TITLE>}` with the shared deck title.
3. Concatenate all `flashcards_<pdf-basename>_pages<start>-<end>_batch<NN>.tex.part` files in ascending batch order between `\begin{document}` and `\end{document}`.
4. Remove any leftover template style-marker comments or `<PLACEHOLDER>` tokens.
5. Write the merged file as `flashcards_<pdf-basename>_pages<start>-<end>.tex`. Do NOT read the per-batch content into the main context beyond what's needed to concatenate.

### Step 6 — Compile and fix (Subagent, MUST be a separate subagent)

Dispatch a fresh subagent with:

- path to `flashcards_<pdf-basename>_pages<start>-<end>.tex`
- path to `compile.sh` in this skill folder

Subagent task:

1. Run `bash <skill-dir>/compile.sh flashcards_<pdf-basename>_pages<start>-<end>.tex`.
2. If it exits non-zero, read `flashcards.log`, locate the offending lines, fix the `.tex` (typical issues: unescaped `_ & % #`, unmatched braces, content overflowing the card, mismatched `\begin`/`\end`), and re-run.
3. Repeat until a clean `flashcards.pdf` is produced. Cap at 5 fix attempts; if still failing, return the error context to the main agent.
4. Return: PDF filename, total card count, any unresolved warnings.

Rationale: the subagent absorbs the verbose `pdflatex` log churn and only reports back a clean result.

### Step 7 — Present summary and request review (main agent)

This is the first time the user is addressed since Step 2. Output:

- The PDF filename only (e.g. `flashcards_<pdf-basename>_pages<start>-<end>.pdf`) — do not embed binary or attempt to render.
- A summary of created flashcards built from the batch return values:
  - source PDF + page range
  - number of batches `N` and total cards
  - per-batch line: `batch <NN>: <card count> — <1-line topical summary>`
  - focus areas applied (verbatim from the user's Step 2 answer, or "general")
- Ask: "Please review and let me know what to adjust."

## Resources

- `extract-pages-text.sh` — wraps `pdftotext -f <start> -l <end>` and writes `<pdf-basename>_pages<start>-<end>.txt` into the current directory.
- `template.tex` — fixed preamble plus three placeholder card-style stubs (A list, B centered prose, C statement + bullets). Always copy the preamble verbatim; replace every `<PLACEHOLDER>`.
- `compile.sh` — runs `pdflatex -interaction=nonstopmode -halt-on-error` three times in the `.tex` file's directory.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Drafting cards in the main agent | Each batch MUST be drafted by its own subagent — see `subagent-driven-development` |
| Skipping subagent dispatch entirely (writing `\begin{flashcard}` in the main context) | STOP. Dispatch a fresh subagent per batch using the Step 4 template. If dispatch is unavailable, report that to the user rather than drafting inline |
| Reusing one subagent for all batches | One fresh subagent per batch (no shared context across batches) |
| Passing main-session history to the subagent | Send only the curated Step 4 dispatch prompt; subagents must not inherit prior context |
| Loading the full extracted text into the main context | Main agent only handles filenames/line counts; subagents read raw text |
| Batches larger than 100 lines | Hard cap: max 100 lines per batch |
| Asking the user anything between Step 2 and Step 7 | NO interruption from the first batch subagent through the compile subagent |
| Skipping the focus question (specific topics vs. general) | Ask exactly once in Step 2 before dispatching |
| Compiling in the main agent | Step 6 is ALWAYS a separate subagent (isolates pdflatex log noise) |
| Forgetting to escape `_ % & #` from extracted text | Subagents must escape before writing `.tex.part` |
| One huge card with all content | One concept per card; split overflow |
| Batch subagent emitting its own preamble / `\documentclass` | Subagents emit ONLY `\begin{flashcard}…\end{flashcard}` blocks; Step 5 assembles preamble once |
| Running `pdflatex` once | Always use `compile.sh` (3 passes) |
| Changing the preamble or `\documentclass` options | Preamble is fixed — only the card list changes |
| Leaving `<PLACEHOLDER>` tokens in the output | Replace all placeholders before writing `flashcards.tex` |
| Skipping the final summary of created flashcards | Step 7 must list per-batch card counts and topical summaries |
