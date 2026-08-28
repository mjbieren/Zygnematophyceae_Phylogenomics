#!/bin/bash

# =========================
# Settings
# =========================

TRINITY_INPUT_FOLDER=##        # Folder containing *.Trinity.fasta
SUPERTRANSCRIPT_OUTPUT=##      # Main output folder

# Path to Trinity installation
TRINITY_HOME=##                # e.g. /path/to/trinityrnaseq

mkdir -p "${SUPERTRANSCRIPT_OUTPUT}"

cd "${TRINITY_INPUT_FOLDER}" || exit 1


# =========================
# Run SuperTranscripts
# =========================

for TRINITY_FILE in *.Trinity.fasta
do
    # Remove .Trinity.fasta to obtain strain name
    STRAIN="${TRINITY_FILE%.Trinity.fasta}"

    echo "========================================"
    echo "Processing: ${STRAIN}"
    echo "Input:      ${TRINITY_FILE}"
    echo "========================================"

    STRAIN_OUTPUT="${SUPERTRANSCRIPT_OUTPUT}/${STRAIN}"

    mkdir -p "${STRAIN_OUTPUT}"

    "${TRINITY_HOME}/Analysis/SuperTranscripts/Trinity_gene_splice_modeler.py" \
        --trinity_fasta "${TRINITY_INPUT_FOLDER}/${TRINITY_FILE}" \
        --out_prefix "${STRAIN_OUTPUT}/${STRAIN}"

    if [ $? -eq 0 ]; then
        echo "${STRAIN}: SuperTranscript completed successfully."
    else
        echo "ERROR: SuperTranscript failed for ${STRAIN}."
    fi

done

echo "========================================"
echo "All Trinity files processed."
echo "========================================"
