#!/bin/bash

# ============================================================
# MIAF - OUTGROUP
#
# MIAF:
# https://github.com/mjbieren/MIAF
#
# This script runs MIAF on the OUTGROUP orthogroups.
#
# Method used here:
#   MAFFT + IQ-TREE
#
# No Conda environment is required.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to MIAF executable
MIAF_PATH=##                    # Change this

# OSG OUTGROUP output folder containing the FASTA files
INPUT=##                        # Change this

# MIAF OUTGROUP output folder
OUTPUT=##                       # Change this

# IQ-TREE executable
#
# If IQ-TREE is available in PATH:
IQTREE="iqtree2"

# Otherwise use the full path, for example:
# IQTREE="/path/to/iqtree2"


# MAFFT executable
#
# If MAFFT is available in PATH:
MAFFT="mafft"

# Otherwise use the full path, for example:
# MAFFT="/path/to/mafft"


# ------------------------------------------------------------
# SYSTEM TYPE
# ------------------------------------------------------------

# n = normal/local system
# s = SLURM
SYSTEMTYPE="n"


# ------------------------------------------------------------
# CPU SETTINGS
# ------------------------------------------------------------

# Maximum number of MIAF jobs that can run simultaneously
JOB_LIMIT=40

# Number of threads used per MAFFT/IQ-TREE job
THREAD_PER_JOB=2


# ------------------------------------------------------------
# IMPORTANT CPU WARNING
# ------------------------------------------------------------

# WARNING:
#
# The approximate maximum CPU usage is:
#
#   JOB_LIMIT x THREAD_PER_JOB
#
# With:
#
#   JOB_LIMIT=40
#   THREAD_PER_JOB=2
#
# MIAF can therefore use approximately 80 threads at once.
#
# Adjust these values to the number of CPU threads available
# on the machine.


# ------------------------------------------------------------
# MIAF OPTIONS
# ------------------------------------------------------------

# -i  Input directory containing FASTA files
#
# -r  Output directory
#
# -m  Path/name of MAFFT
#
# -q  Path/name of IQ-TREE
#
# -c  Maximum number of simultaneous jobs
#
# -x  Number of threads per job
#
# -s  System type:
#       n = normal/local
#       s = SLURM
#
#
# NOTE:
#
# The -p option is deliberately NOT used here.
#
# Without -p, this workflow uses:
#
#   MAFFT
#   +
#   IQ-TREE
#
# Adding -p changes the workflow to include the
# Prequal/Q-INS-i/ClipKIT processing implemented by MIAF.


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -f "${MIAF_PATH}" ]; then
    echo "ERROR: MIAF executable not found:"
    echo "${MIAF_PATH}"
    exit 1
fi

if [ ! -d "${INPUT}" ]; then
    echo "ERROR: OUTGROUP input folder not found:"
    echo "${INPUT}"
    exit 1
fi


# ------------------------------------------------------------
# CREATE OUTPUT DIRECTORY
# ------------------------------------------------------------

mkdir -p "${OUTPUT}" || {
    echo "ERROR: Could not create output folder:"
    echo "${OUTPUT}"
    exit 1
}


# ============================================================
# RUN MIAF
# ============================================================

echo
echo "============================================================"
echo "Running MIAF - OUTGROUP"
echo "============================================================"
echo
echo "Input:           ${INPUT}"
echo "Output:          ${OUTPUT}"
echo "MAFFT:           ${MAFFT}"
echo "IQ-TREE:         ${IQTREE}"
echo "Concurrent jobs: ${JOB_LIMIT}"
echo "Threads/job:     ${THREAD_PER_JOB}"
echo


"${MIAF_PATH}" \
    -i "${INPUT}" \
    -r "${OUTPUT}" \
    -m "${MAFFT}" \
    -q "${IQTREE}" \
    -c "${JOB_LIMIT}" \
    -x "${THREAD_PER_JOB}" \
    -s "${SYSTEMTYPE}" \
    || {
        echo
        echo "ERROR: MIAF OUTGROUP failed."
        exit 1
    }


echo
echo "============================================================"
echo "MIAF OUTGROUP completed successfully"
echo "============================================================"
