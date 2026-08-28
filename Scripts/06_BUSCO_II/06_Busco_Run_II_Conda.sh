#!/bin/bash

# ============================================================
# BUSCO II - after TransDecoder
# Input: *_genes_supertranscript.fasta.transdecoder.pep
# ============================================================

BUSCO_ENV=busco
BUSCO_LINEAGE=viridiplantae_odb12
BUSCO_CPUS=32

TRANSDECODER_FOLDER=##       # Folder containing *.transdecoder.pep
BUSCO_OUTPUT=##              # BUSCO output folder

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${BUSCO_ENV}"

mkdir -p "${BUSCO_OUTPUT}"

shopt -s nullglob

for INPUT_FILE in "${TRANSDECODER_FOLDER}"/*.transdecoder.pep
do
    FILE_NAME=$(basename "${INPUT_FILE}")

    STRAIN="${FILE_NAME%.transdecoder.pep}"
    STRAIN="${STRAIN%_genes_supertranscript.fasta}"

    echo "========================================"
    echo "Running BUSCO II: ${STRAIN}"
    echo "========================================"

    busco \
        -i "${INPUT_FILE}" \
        -l "${BUSCO_LINEAGE}" \
        -m proteins \
        -o "${STRAIN}_BUSCO_II" \
        --out_path "${BUSCO_OUTPUT}" \
        --cpu "${BUSCO_CPUS}"

done
