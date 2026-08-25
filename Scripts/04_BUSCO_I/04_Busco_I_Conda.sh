#!/usr/bin/env bash
set -euo pipefail
INPUT="${1:-/path/to/supertranscripts}"
OUTPUT="${2:-busco_I_transcriptomes}"
LINEAGE="${BUSCO_LINEAGE:-eukaryota_odb10}"
THREADS="${BUSCO_THREADS:-32}"
busco -i "$INPUT" -o "$OUTPUT" -m transcriptome -l "$LINEAGE" -c "$THREADS" -f
