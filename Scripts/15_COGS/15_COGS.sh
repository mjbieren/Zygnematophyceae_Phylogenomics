#!/bin/bash

# ============================================================
# COGS - COMBINE INGROUP AND OUTGROUP ORTHOGROUP SETS
#
# COGS:
# https://github.com/mjbieren/COGS
#
# This script uses COGS Method 2 to combine the filtered
# Ingroup and Outgroup orthogroup sets.
#
# Method 2 uses:
#
#   1. FilterPPPResult output from the Ingroup
#   2. Original PhyloPyPruner input from the Ingroup
#   3. FilterPPPResult output from the Outgroup
#   4. Original PhyloPyPruner input from the Outgroup
#
# COGS identifies the retained orthogroups and retrieves the
# corresponding tree and alignment files from the original
# PhyloPyPruner input directories.
#
# This avoids having to rerun MIAF for the combined dataset.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to COGS executable
PROGRAMPATH=##                  # Change this


# ------------------------------------------------------------
# INGROUP
# ------------------------------------------------------------

# FilterPPPResult INGROUP output
FPPP_INGROUP_OUTPUT=##          # Change this

# Original PhyloPyPruner INGROUP input
#
# This is the APPPFormat output that was used as input for
# the Ingroup PhyloPyPruner analysis.
PPP_INGROUP_INPUT=##            # Change this


# ------------------------------------------------------------
# OUTGROUP
# ------------------------------------------------------------

# FilterPPPResult OUTGROUP output
FPPP_OUTGROUP_OUTPUT=##         # Change this

# Original PhyloPyPruner OUTGROUP input
#
# This is the APPPFormat output that was used as input for
# the Outgroup PhyloPyPruner analysis.
PPP_OUTGROUP_INPUT=##           # Change this


# ------------------------------------------------------------
# OUTPUT
# ------------------------------------------------------------

# Output folder for the combined COGS dataset
OUTPUT_FOLDER=##                # Change this


# ------------------------------------------------------------
# COGS METHOD 2
# ------------------------------------------------------------

# -s
#   First orthogroup set.
#
#   Here:
#   FilterPPPResult INGROUP output.
#
# -x
#   Original PhyloPyPruner input directory corresponding
#   to the first set.
#
#   Here:
#   PhyloPyPruner INGROUP input.
#
# -t
#   Second orthogroup set.
#
#   Here:
#   FilterPPPResult OUTGROUP output.
#
# -y
#   Original PhyloPyPruner input directory corresponding
#   to the second set.
#
#   Here:
#   PhyloPyPruner OUTGROUP input.
#
# -r
#   Output directory for the combined COGS dataset.
#
#
# IMPORTANT:
#
# Do NOT use -p here.
#
# The files from PPP_INGROUP_INPUT and PPP_OUTGROUP_INPUT
# have already passed through APPPFormat and therefore
# already contain the PhyloPyPruner-compatible headers.


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -x "${PROGRAMPATH}" ]; then
    echo "ERROR: COGS executable not found or not executable:"
    echo "${PROGRAMPATH}"
    exit 1
fi

if [ ! -d "${FPPP_INGROUP_OUTPUT}" ]; then
    echo "ERROR: FilterPPPResult INGROUP folder not found:"
    echo "${FPPP_INGROUP_OUTPUT}"
    exit 1
fi

if [ ! -d "${PPP_INGROUP_INPUT}" ]; then
    echo "ERROR: PhyloPyPruner INGROUP input folder not found:"
    echo "${PPP_INGROUP_INPUT}"
    exit 1
fi

if [ ! -d "${FPPP_OUTGROUP_OUTPUT}" ]; then
    echo "ERROR: FilterPPPResult OUTGROUP folder not found:"
    echo "${FPPP_OUTGROUP_OUTPUT}"
    exit 1
fi

if [ ! -d "${PPP_OUTGROUP_INPUT}" ]; then
    echo "ERROR: PhyloPyPruner OUTGROUP input folder not found:"
    echo "${PPP_OUTGROUP_INPUT}"
    exit 1
fi


# ------------------------------------------------------------
# CREATE OUTPUT DIRECTORY
# ------------------------------------------------------------

mkdir -p "${OUTPUT_FOLDER}" || {
    echo "ERROR: Could not create COGS output folder:"
    echo "${OUTPUT_FOLDER}"
    exit 1
}


# ============================================================
# RUN COGS - METHOD 2
# ============================================================

echo
echo "============================================================"
echo "Running COGS - Method 2"
echo "============================================================"
echo
echo "Ingroup filtered set:  ${FPPP_INGROUP_OUTPUT}"
echo "Ingroup PPP input:     ${PPP_INGROUP_INPUT}"
echo
echo "Outgroup filtered set: ${FPPP_OUTGROUP_OUTPUT}"
echo "Outgroup PPP input:    ${PPP_OUTGROUP_INPUT}"
echo
echo "COGS output:           ${OUTPUT_FOLDER}"
echo


"${PROGRAMPATH}" \
    -s "${FPPP_INGROUP_OUTPUT}" \
    -x "${PPP_INGROUP_INPUT}" \
    -t "${FPPP_OUTGROUP_OUTPUT}" \
    -y "${PPP_OUTGROUP_INPUT}" \
    -r "${OUTPUT_FOLDER}" \
    || {
        echo "ERROR: COGS failed."
        exit 1
    }


echo
echo "============================================================"
echo "COGS completed successfully"
echo "============================================================"
