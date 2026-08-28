#!/bin/bash

# ============================================================
# IQ-TREE 3 - FINAL TREE INFERENCE
#
# This script runs the final phylogenetic tree inference
# using the model selected in Step 20A (ModelFinder).
#
# Expected model for this dataset:
#
#   LG+C60
#
# Change AUTOMATIC_MODEL_SELECTION if Step 20A selects a
# different model.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to IQ-TREE 3 executable
IQ_TREE_PATH=##                 # Change this

# Input concatenated amino-acid alignment
FILE_INPUT=##                   # Change this

# Number of CPU threads
THREADS=100                     # Reduce if fewer CPUs are available

# Maximum memory available to IQ-TREE
MEMORY="800G"                   # Reduce if less RAM is available

# Type of amino-acid substitution models
#
# Possible values include:
#   nuclear
#   mitochondrial
#   chloroplast
#   viral
MSUB="nuclear"

# Number of replicates for:
#
#   - ultrafast bootstrap (-bb)
#   - SH-aLRT branch test (-alrt)
BRANCH_TEST_REPLICATES=1000

# Model selected by ModelFinder in Step 20A
#
# Change this if ModelFinder selected another model.
AUTOMATIC_MODEL_SELECTION="LG+C60"

# Output prefix for all IQ-TREE result files
OUTPUT_PREFIX=##                # Change this


# ------------------------------------------------------------
# IQ-TREE SETTINGS
# ------------------------------------------------------------

# -nt
#   Number of CPU threads.
#
# -m
#   Substitution model selected in Step 20A.
#
# -msub
#   Amino-acid model subset.
#
# -s
#   Input alignment.
#
# -bb
#   Number of ultrafast bootstrap replicates.
#
# -alrt
#   Number of SH-aLRT replicates.
#
# -pre
#   Prefix for all IQ-TREE output files.
#
# -mem
#   Maximum amount of memory IQ-TREE may use.


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
# RUN IQ-TREE
# ============================================================

echo
echo "============================================================"
echo "Running IQ-TREE 3 - Final Tree Inference"
echo "============================================================"
echo
echo "Input alignment:      ${FILE_INPUT}"
echo "Output prefix:        ${OUTPUT_PREFIX}"
echo "Model:                ${AUTOMATIC_MODEL_SELECTION}"
echo "Model subset:         ${MSUB}"
echo "Threads:              ${THREADS}"
echo "Bootstrap replicates: ${BRANCH_TEST_REPLICATES}"
echo "SH-aLRT replicates:   ${BRANCH_TEST_REPLICATES}"
echo "Memory limit:         ${MEMORY}"
echo


"${IQ_TREE_PATH}" \
    -nt "${THREADS}" \
    -m "${AUTOMATIC_MODEL_SELECTION}" \
    -msub "${MSUB}" \
    -s "${FILE_INPUT}" \
    -bb "${BRANCH_TEST_REPLICATES}" \
    -alrt "${BRANCH_TEST_REPLICATES}" \
    -pre "${OUTPUT_PREFIX}" \
    -mem "${MEMORY}" \
    || {
        echo "ERROR: IQ-TREE failed."
        exit 1
    }


echo
echo "============================================================"
echo "IQ-TREE final tree inference completed successfully"
echo "============================================================"
