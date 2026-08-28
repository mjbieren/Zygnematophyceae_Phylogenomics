#!/bin/bash

# ============================================================
# Concatenate loci using PhyX (pxcat)
#
# This script concatenates all individual locus alignments
# into a single supermatrix and generates a partition file.
# ============================================================


# ------------------------------------------------------------
# CONDA ENVIRONMENT
# ------------------------------------------------------------

# To create the required PhyX Conda environment:
#
# conda create -n phyx -c conda-forge -c bioconda phyx
#
# This only needs to be done once.

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate phyx


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Folder containing the individual locus files
INPUT_FOLDER=##                 # Change this

# Output path + base name WITHOUT file extension
#
# Example:
# OUTPUT_FILE="/path/to/output/Zygnema_Loci6894_Concat"
OUTPUT_FILE=##                  # Change this

# Input file extension
FILE_EXTENSION="fa"

# Output concatenated alignment extension
FILE_EXTENSION_OUTPUT="fas"


# ------------------------------------------------------------
# CHECK INPUT DIRECTORY
# ------------------------------------------------------------

if [ ! -d "${INPUT_FOLDER}" ]; then
    echo "ERROR: Input folder not found:"
    echo "${INPUT_FOLDER}"
    conda deactivate
    exit 1
fi

cd "${INPUT_FOLDER}" || exit 1

shopt -s nullglob

FILES=(*."${FILE_EXTENSION}")

if [ ${#FILES[@]} -eq 0 ]; then
    echo "ERROR: No .${FILE_EXTENSION} files found in:"
    echo "${INPUT_FOLDER}"
    conda deactivate
    exit 1
fi


# ============================================================
# CONCATENATE LOCI
# ============================================================

echo
echo "============================================================"
echo "Concatenating loci with PhyX pxcat"
echo "Number of loci: ${#FILES[@]}"
echo "============================================================"
echo

pxcat \
    -s "${FILES[@]}" \
    -p "${OUTPUT_FILE}.output_partition_file" \
    -o "${OUTPUT_FILE}.${FILE_EXTENSION_OUTPUT}" \
    || {
        echo "ERROR: pxcat failed."
        conda deactivate
        exit 1
    }


echo
echo "============================================================"
echo "Concatenation completed successfully"
echo
echo "Concatenated alignment:"
echo "${OUTPUT_FILE}.${FILE_EXTENSION_OUTPUT}"
echo
echo "Partition file:"
echo "${OUTPUT_FILE}.output_partition_file"
echo "============================================================"


conda deactivate
