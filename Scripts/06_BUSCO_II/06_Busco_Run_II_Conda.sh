#!/usr/bin/env bash
set -euo pipefail
INPUT="${1:-/path/to/transdecoder_proteins}"
OUTPUT="${2:-busco_II_proteins}"
LINEAGE="${BUSCO_LINEAGE:-eukaryota_odb10}"
THREADS="${BUSCO_THREADS:-32}"
busco -i "$INPUT" -o "$OUTPUT" -m proteins -l "$LINEAGE" -c "$THREADS" -f
