#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <pdf-file> <start-page> <end-page>"
  exit 2
fi

pdf="$1"
start="$2"
end="$3"

# Validate input file
if [ ! -f "$pdf" ]; then
  echo "Error: file not found: $pdf" >&2
  exit 3
fi

# Validate numeric pages
if ! [[ "$start" =~ ^[0-9]+$ ]] || ! [[ "$end" =~ ^[0-9]+$ ]]; then
  echo "Error: start and end must be positive integers" >&2
  exit 4
fi

if [ "$start" -lt 1 ] || [ "$end" -lt "$start" ]; then
  echo "Error: invalid page range" >&2
  exit 5
fi

# Output filename: <inputname>_pages<start>-<end>.txt
base="$(basename "$pdf")"
name="${base%.*}"
out="${name}_pages${start}-${end}.txt"

# Run pdftotext with -f (first) and -l (last)
pdftotext -f "$start" -l "$end" "$pdf" "$out"

echo "Extracted pages $start-$end to: $out"

