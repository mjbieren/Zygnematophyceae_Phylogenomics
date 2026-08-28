#!/bin/bash

# ============================================================
# BUSCO I - after SuperTranscripts
# Input: *_genes_supertranscript.fasta
# ============================================================

BUSCO_ENV=busco
BUSCO_LINEAGE=viridiplantae_odb12
BUSCO_CPUS=32

SUPERTRANSCRIPT_FOLDER=##    # Folder containing *_genes_supertranscript.fasta
BUSCO_OUTPUT=##              # BUSCO output folder

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${BUSCO_ENV}"

mkdir -p "${BUSCO_OUTPUT}"

shopt -s nullglob

for INPUT_FILE in "${SUPERTRANSCRIPT_FOLDER}"/*_genes_supertranscript.fasta
do
    FILE_NAME=$(basename "${INPUT_FILE}")
    STRAIN="${FILE_NAME%_genes_supertranscript.fasta}"

    echo "========================================"
    echo "Running BUSCO I: ${STRAIN}"
    echo "========================================"

    busco \
        -i "${INPUT_FILE}" \
        -l "${BUSCO_LINEAGE}" \
        -m transcriptome \
        -o "${STRAIN}_BUSCO_I" \
        --out_path "${BUSCO_OUTPUT}" \
        --cpu "${BUSCO_CPUS}"

done
