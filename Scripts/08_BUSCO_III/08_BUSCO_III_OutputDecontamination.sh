#!/bin/bash

# ============================================================
# BUSCO III - after decontamination
# Input: Folder Positive Set
# ============================================================

BUSCO_ENV=busco
BUSCO_LINEAGE=viridiplantae_odb12 #Or change if you have a better fitting database
BUSCO_CPUS=32

DECONTAMINATION_FOLDER=##    # Folder containing decontaminated protein files
BUSCO_OUTPUT=##              # BUSCO output folder

DECONTAMINATION_SUFFIX=".fa"

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${BUSCO_ENV}"

mkdir -p "${BUSCO_OUTPUT}"

shopt -s nullglob

for INPUT_FILE in "${DECONTAMINATION_FOLDER}"/*"${DECONTAMINATION_SUFFIX}"
do
    FILE_NAME=$(basename "${INPUT_FILE}")
    STRAIN="${FILE_NAME%${DECONTAMINATION_SUFFIX}}"

    echo "========================================"
    echo "Running BUSCO III: ${STRAIN}"
    echo "========================================"

    busco \
        -i "${INPUT_FILE}" \
        -l "${BUSCO_LINEAGE}" \
        -m proteins \
        -o "${STRAIN}_BUSCO_III" \
        --out_path "${BUSCO_OUTPUT}" \
        --cpu "${BUSCO_CPUS}"

done
