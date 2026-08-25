#!/usr/bin/env bash
set -euo pipefail
IN="${1:-${PWD##*/}_genes_supertranscript.fasta}"
OUT="${2:-transdecoder_dir}"
mkdir -p "$OUT"
TransDecoder.LongOrfs -t "$IN" --output_dir "$OUT"
TransDecoder.Predict -t "$IN" --output_dir "$OUT" --single_best_only
