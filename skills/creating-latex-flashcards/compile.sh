#!/usr/bin/env bash
# Compile a flashcards .tex file with pdflatex 3 times
# (resolves cross-references, page counters, etc.).
#
# Usage: compile.sh <tex-file>
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <tex-file>" >&2
  exit 2
fi

tex="$1"

if [ ! -f "$tex" ]; then
  echo "Error: file not found: $tex" >&2
  exit 3
fi

if ! command -v pdflatex >/dev/null 2>&1; then
  echo "Error: pdflatex not installed (need a TeX distribution, e.g. texlive)" >&2
  exit 4
fi

dir="$(dirname "$tex")"
file="$(basename "$tex")"
base="${file%.tex}"

cd "$dir"

for pass in 1 2 3; do
  echo "=== pdflatex pass ${pass}/3 ==="
  # -halt-on-error: fail fast on syntax errors so the caller can fix and retry.
  # -interaction=nonstopmode: never prompt for input.
  pdflatex -interaction=nonstopmode -halt-on-error "$file"
done

echo "Done. Output: ${dir}/${base}.pdf"
