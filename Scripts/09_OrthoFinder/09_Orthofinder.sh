#!/usr/bin/env bash
set -euo pipefail
SPECIES_DIR="${SPECIES_DIR:-/path/to/126_orthofinder_inputs}"
TREE_FILE="${TREE_FILE:-/path/to/original_zygnematophyceae_guide_tree.nwk}"
OUTPUT_SUFFIX="${OUTPUT_SUFFIX:-ort_zygn}"
ORTHOFINDER="${ORTHOFINDER:-orthofinder}"
THREADS="${THREADS:-32}"

if [[ ! -f "$TREE_FILE" ]]; then
  echo "Guide tree not found: $TREE_FILE" >&2
  echo "See GUIDE_TREE_REQUIRED.md" >&2
  exit 2
fi

# Adjust options to the OrthoFinder version used on your system. The project consumes root HOGs (N0.tsv) downstream.
"$ORTHOFINDER" -f "$SPECIES_DIR" -t "$THREADS" -s "$TREE_FILE" -n "$OUTPUT_SUFFIX"
