#!/bin/bash

# ============================================================
# IQ-TREE 3 - TOPOLOGY / AU TEST
#
# This script compares a set of candidate tree topologies
# against an amino-acid alignment using IQ-TREE.
#
# Tests include the AU test and other topology tests produced
# by IQ-TREE using RELL resampling.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to IQ-TREE 3 executable
IQTREE_PATH=##                  # Change this

# Input concatenated amino-acid alignment
INFILE=##                       # Change this

# File containing the alternative tree topologies to test
TESTTREES=##                    # Change this

# Number of CPU threads
THREADS=80                      # Reduce if fewer CPUs are available

# Maximum memory available to IQ-TREE
MAXRAM="500G"                   # Reduce if less RAM is available

# Model used for the topology test
MODEL="LG+C60+G"

# Number of RELL bootstrap replicates
BOOTSTRAP_REPLICATES=10000

# Output prefix
OUTPUT_PREFIX=##                # Change this


# ------------------------------------------------------------
# TOPOLOGY TEST SETTINGS
# ------------------------------------------------------------

# -s
#   Input sequence alignment.
#
# -z
#   File containing the candidate tree topologies.
#
# -n 0
#   Do not perform a standard tree search.
#
# -m LG+C60+G
#   Substitution model used to evaluate the candidate trees.
#
# -zb 10000
#   Perform 10,000 RELL bootstrap replicates.
#
# -zw
#   Perform weighted topology tests.
#
# -au
#   Perform the Approximately Unbiased (AU) test.
#
# --redo-tree
#   Recompute tree likelihoods rather than reusing previously
#   calculated tree results.
#
# -pre
#   Prefix for IQ-TREE output files.
#
# -mem
#   Maximum amount of memory IQ-TREE may use.


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -x "${IQTREE_PATH}" ]; then
    echo "ERROR: IQ-TREE executable not found or not executable:"
    echo "${IQTREE_PATH}"
    exit 1
fi

if [ ! -f "${INFILE}" ]; then
    echo "ERROR: Input alignment not found:"
    echo "${INFILE}"
    exit 1
fi

if [ ! -f "${TESTTREES}" ]; then
    echo "ERROR: Candidate tree file not found:"
    echo "${TESTTREES}"
    exit 1
fi


# ============================================================
# RUN IQ-TREE TOPOLOGY / AU TEST
# ============================================================

echo
echo "============================================================"
echo "Running IQ-TREE 3 - Topology / AU Test"
echo "============================================================"
echo
echo "Input alignment:       ${INFILE}"
echo "Candidate trees:       ${TESTTREES}"
echo "Model:                 ${MODEL}"
echo "RELL replicates:       ${BOOTSTRAP_REPLICATES}"
echo "Threads:               ${THREADS}"
echo "Memory limit:          ${MAXRAM}"
echo "Output prefix:         ${OUTPUT_PREFIX}"
echo


"${IQTREE_PATH}" \
    -nt "${THREADS}" \
    -s "${INFILE}" \
    -z "${TESTTREES}" \
    -n 0 \
    -m "${MODEL}" \
    -zb "${BOOTSTRAP_REPLICATES}" \
    -zw \
    -au \
    -pre "${OUTPUT_PREFIX}" \
    -mem "${MAXRAM}" \
    --redo-tree \
    || {
        echo "ERROR: IQ-TREE topology test failed."
        exit 1
    }


echo
echo "============================================================"
echo "IQ-TREE topology / AU test completed successfully"
echo "============================================================"