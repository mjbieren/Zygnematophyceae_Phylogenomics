#!/bin/bash

# ============================================================
# MIAF - PREQUAL / Q-INS-i / CLIPKIT
#
# Combined COGS dataset
#
# MIAF:
# https://github.com/mjbieren/MIAF
#
# Using the -p option runs:
#
#   Prequal
#      ↓
#   MAFFT Q-INS-i
#      ↓
#   ClipKIT
#
# instead of the standard MAFFT + IQ-TREE workflow.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to MIAF executable
MIAF_PATH=##                    # Change this

# Input folder containing the filtered COGS FASTA files
#
# This is the output from the FilterPPPResult COGS step.
INPUT=##                        # Change this

# Output folder for the Prequal/Q-INS-i/ClipKIT results
OUTPUT=##                       # Change this

# Path to MAFFT
#
# If MAFFT is available through PATH, simply use:
#
#   MAFFT="mafft"
#
MAFFT=##                        # Change this

# System type
#
# n = normal/local execution
# s = SLURM
#
# For normal execution:
SYSTEMTYPE="n"

# Maximum number of jobs that MIAF may run simultaneously
JOB_LIMIT=80

# Number of threads used per individual job
THREAD_PER_JOB=2


# ------------------------------------------------------------
# IMPORTANT: CPU USAGE
# ------------------------------------------------------------

# MIAF can run multiple jobs simultaneously.
#
# Approximate maximum CPU usage is:
#
#   JOB_LIMIT × THREAD_PER_JOB
#
# Here:
#
#   80 × 2 = 160 threads
#
# Reduce JOB_LIMIT and/or THREAD_PER_JOB if the machine has
# fewer available CPU threads.


# ------------------------------------------------------------
# PREQUAL MODE
# ------------------------------------------------------------

# The -p option activates the Prequal workflow.
#
# Prequal and ClipKIT must therefore be installed and
# accessible on the system.
#
# MIAF will perform:
#
#   Prequal
#   Q-INS-i alignment using MAFFT
#   ClipKIT trimming
#
# No IQ-TREE path is required for this workflow.


# ------------------------------------------------------------
# MIAF OPTIONS
# ------------------------------------------------------------

# -i  Input FASTA folder
#
# -r  Output folder
#
# -m  MAFFT executable/path
#
# -c  Maximum number of simultaneous jobs
#
# -x  Number of threads per job
#
# -s  System type
#       n = normal/local
#       s = SLURM
#
# -p  Run Prequal + Q-INS-i + ClipKIT workflow


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -x "${MIAF_PATH}" ]; then
    echo "ERROR: MIAF executable not found or not executable:"
    echo "${MIAF_PATH}"
    exit 1
fi

if [ ! -d "${INPUT}" ]; then
    echo "ERROR: COGS input folder not found:"
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
# RUN MIAF - PREQUAL WORKFLOW
# ============================================================

echo
echo "============================================================"
echo "Running MIAF - Prequal / Q-INS-i / ClipKIT"
echo "============================================================"
echo
echo "Input:           ${INPUT}"
echo "Output:          ${OUTPUT}"
echo "MAFFT:           ${MAFFT}"
echo "System type:     ${SYSTEMTYPE}"
echo "Concurrent jobs: ${JOB_LIMIT}"
echo "Threads/job:     ${THREAD_PER_JOB}"
echo


"${MIAF_PATH}" \
    -i "${INPUT}" \
    -r "${OUTPUT}" \
    -m "${MAFFT}" \
    -c "${JOB_LIMIT}" \
    -x "${THREAD_PER_JOB}" \
    -s "${SYSTEMTYPE}" \
    -p \
    || {
        echo "ERROR: MIAF Prequal workflow failed."
        exit 1
    }


echo
echo "============================================================"
echo "MIAF Prequal / Q-INS-i / ClipKIT completed successfully"
echo "============================================================"
