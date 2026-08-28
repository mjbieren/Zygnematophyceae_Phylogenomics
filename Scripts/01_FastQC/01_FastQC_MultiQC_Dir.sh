#!/bin/bash

# ============================================================
# FASTQC + MULTIQC - RAW READ QUALITY CONTROL
#
# This script performs quality control on the raw sequencing
# reads using FastQC and summarizes all FastQC reports using
# MultiQC.
#
# Run this BEFORE Trinity assembly.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Folder containing the raw read files
FASTQC_INPUT_FOLDER=##          # Change this

# Folder for individual FastQC results
FASTQC_OUTPUT_FOLDER=##         # Change this

# Folder for the combined MultiQC report
MULTIQC_OUTPUT=##               # Change this

# Raw read file extension
#
# Examples:
#   fastq.gz
#   fq.gz
FASTQC_FILE_FORMAT="fastq.gz"

# Number of files/threads FastQC processes simultaneously
NUMBER_OF_SIMULTANEOUS_FILES=15


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -d "${FASTQC_INPUT_FOLDER}" ]; then
    echo "ERROR: Raw-read input folder not found:"
    echo "${FASTQC_INPUT_FOLDER}"
    exit 1
fi


# ------------------------------------------------------------
# CREATE OUTPUT DIRECTORIES
# ------------------------------------------------------------

mkdir -p "${FASTQC_OUTPUT_FOLDER}" || {
    echo "ERROR: Could not create FastQC output folder:"
    echo "${FASTQC_OUTPUT_FOLDER}"
    exit 1
}

mkdir -p "${MULTIQC_OUTPUT}" || {
    echo "ERROR: Could not create MultiQC output folder:"
    echo "${MULTIQC_OUTPUT}"
    exit 1
}


# ------------------------------------------------------------
# ACTIVATE CONDA ENVIRONMENT
# ------------------------------------------------------------

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate multiqc || exit 1


# ------------------------------------------------------------
# FIND RAW READ FILES
# ------------------------------------------------------------

cd "${FASTQC_INPUT_FOLDER}" || exit 1

shopt -s nullglob

FASTQ_FILES=(*."${FASTQC_FILE_FORMAT}")

if [ ${#FASTQ_FILES[@]} -eq 0 ]; then
    echo "ERROR: No *.${FASTQC_FILE_FORMAT} files found in:"
    echo "${FASTQC_INPUT_FOLDER}"
    conda deactivate
    exit 1
fi


# ============================================================
# RUN FASTQC
# ============================================================

echo
echo "============================================================"
echo "Running FastQC"
echo "============================================================"
echo
echo "Input folder:  ${FASTQC_INPUT_FOLDER}"
echo "Files found:   ${#FASTQ_FILES[@]}"
echo "Output folder: ${FASTQC_OUTPUT_FOLDER}"
echo "Threads:       ${NUMBER_OF_SIMULTANEOUS_FILES}"
echo


fastqc "${FASTQ_FILES[@]}" \
    -q \
    -t "${NUMBER_OF_SIMULTANEOUS_FILES}" \
    -o "${FASTQC_OUTPUT_FOLDER}" \
    || {
        echo "ERROR: FastQC failed."
        conda deactivate
        exit 1
    }


# ============================================================
# RUN MULTIQC
# ============================================================

echo
echo "============================================================"
echo "Running MultiQC"
echo "============================================================"
echo


multiqc "${FASTQC_OUTPUT_FOLDER}" \
    -o "${MULTIQC_OUTPUT}" \
    || {
        echo "ERROR: MultiQC failed."
        conda deactivate
        exit 1
    }


# ------------------------------------------------------------
# FINISH
# ------------------------------------------------------------

conda deactivate

echo
echo "============================================================"
echo "FastQC + MultiQC completed successfully"
echo "============================================================"
