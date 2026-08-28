#!/bin/bash

# ============================================================
# PhyloPyPruner - COMBINED COGS
#
# This script performs paralog pruning and filtering on the
# APPPFormat output for the combined COGS dataset.
#
# Unlike the standard Ingroup/Outgroup runs, this analysis
# does NOT generate a supermatrix.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# APPPFormat COGS output folder
IN=##                           # Change this

# PhyloPyPruner COGS output folder
OUTPUT=##                       # Change this

# Number of threads
THREADS=50


# ------------------------------------------------------------
# PHYLOPYPRUNER SETTINGS
# ------------------------------------------------------------

# --mask pdist
#   Mask redundant sequences using pairwise distance.
#
# --prune MI
#   Use the Maximum Inclusion (MI) method for paralog pruning.
#
# --min-taxa 3
#   Require at least 3 taxa.
#
# --trim-lb 5
#   Trim long branches using a threshold of 5.
#
# --min-support 0.75
#   Minimum branch support of 0.75.
#
# --trim-divergent 1.25
#   Remove divergent sequences using a threshold of 1.25.
#
# --jackknife
#   Perform jackknife analysis.
#
# --no-plot
#   Do not generate plots.
#
# --overwrite
#   Allow an existing output directory to be overwritten.
#
# --no-supermatrix
#   Do not generate a concatenated supermatrix.
#
#   This is intentionally enabled for the combined COGS run.


# ------------------------------------------------------------
# ACTIVATE PHYLOPYPRUNER
# ------------------------------------------------------------

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate phylopypruner || exit 1


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -d "${IN}" ]; then
    echo "ERROR: APPPFormat COGS folder not found:"
    echo "${IN}"
    conda deactivate
    exit 1
fi


# ------------------------------------------------------------
# CREATE OUTPUT DIRECTORY
# ------------------------------------------------------------

mkdir -p "${OUTPUT}" || {
    echo "ERROR: Could not create output folder:"
    echo "${OUTPUT}"
    conda deactivate
    exit 1
}


# ============================================================
# RUN PHYLOPYPRUNER - COMBINED COGS
# ============================================================

echo
echo "============================================================"
echo "Running PhyloPyPruner - COMBINED COGS"
echo "============================================================"
echo
echo "Input:          ${IN}"
echo "Output:         ${OUTPUT}"
echo "Threads:        ${THREADS}"
echo "Create matrix:  NO"
echo


phylopypruner \
    --dir "${IN}" \
    --output "${OUTPUT}" \
    --mask pdist \
    --prune MI \
    --min-taxa 3 \
    --trim-lb 5 \
    --min-support 0.75 \
    --threads "${THREADS}" \
    --trim-divergent 1.25 \
    --jackknife \
    --no-plot \
    --overwrite \
    --no-supermatrix \
    || {
        echo "ERROR: PhyloPyPruner failed."
        conda deactivate
        exit 1
    }


# ------------------------------------------------------------
# FINISH
# ------------------------------------------------------------

conda deactivate

echo
echo "============================================================"
echo "PhyloPyPruner COMBINED COGS completed successfully"
echo "============================================================"
