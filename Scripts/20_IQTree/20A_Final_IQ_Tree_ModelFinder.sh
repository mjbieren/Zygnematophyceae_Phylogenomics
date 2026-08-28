#!/bin/bash

# ============================================================
# IQ-TREE 3 - MODELFINDER ONLY
#
# Step 20A
#
# This script performs model selection only using IQ-TREE
# ModelFinder on the concatenated amino-acid alignment.
#
# No phylogenetic tree search is performed in this step.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to IQ-TREE 3 executable
IQ_TREE_PATH=##                 # Change this

# Input amino-acid alignment
# Output from the previous alignment/concatenation step
FILE_INPUT=##                   # Change this

# Number of CPU threads
THREADS=75

# Type of amino-acid model set
#
# Possible values include:
#   nuclear
#   mitochondrial
#   chloroplast
#   viral
MSUB="nuclear"

# Output prefix
OUTPUT_PREFIX=##                # Change this

# Maximum memory available to IQ-TREE
MEMORY="1000G"


# ------------------------------------------------------------
# MODEL SELECTION SETTINGS
# ------------------------------------------------------------

# -m MF
#   Run ModelFinder model selection.
#
# -madd LG+C60
#   Additionally test the LG+C60 mixture model.
#
# -st AA
#   Input sequences are amino acids.
#
# -msub nuclear
#   Restrict/test models appropriate for nuclear proteins.
#
# -s
#   Input alignment.
#
# -pre
#   Prefix used for all IQ-TREE output files.
#
# -mem
#   Maximum memory IQ-TREE may use.


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -x "${IQ_TREE_PATH}" ]; then
    echo "ERROR: IQ-TREE executable not found or not executable:"
    echo "${IQ_TREE_PATH}"
    exit 1
fi

if [ ! -f "${FILE_INPUT}" ]; then
    echo "ERROR: Input alignment not found:"
    echo "${FILE_INPUT}"
    exit 1
fi


# ============================================================
# RUN IQ-TREE MODELFINDER
# ============================================================

echo
echo "============================================================"
echo "IQ-TREE 3 - ModelFinder only"
echo "============================================================"
echo
echo "Input alignment: ${FILE_INPUT}"
echo "Output prefix:   ${OUTPUT_PREFIX}"
echo "Threads:         ${THREADS}"
echo "Model subset:    ${MSUB}"
echo "Extra model:     LG+C60"
echo "Memory limit:    ${MEMORY}"
echo


"${IQ_TREE_PATH}" \
    -nt "${THREADS}" \
    -m MF \
    -madd LG+C60 \
    -st AA \
    -msub "${MSUB}" \
    -s "${FILE_INPUT}" \
    -pre "${OUTPUT_PREFIX}" \
    -mem "${MEMORY}" \
    || {
        echo "ERROR: IQ-TREE ModelFinder failed."
        exit 1
    }


echo
echo "============================================================"
echo "IQ-TREE ModelFinder completed successfully"
echo "============================================================"
