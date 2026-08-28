#!/bin/bash

# ============================================================
# Apply PhyloPyPruner Format (APPPFormat) - INGROUP
#
# APPPFormat:
# https://github.com/mjbieren/ApplyPPPFormat
#
# This script prepares the INGROUP gene trees and alignments
# for use with PhyloPyPruner.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to APPPFormat executable
APPPF_PATH=##                   # Change this

# Folder containing the INGROUP MIAF output
# (*.treefile and corresponding alignment files)
TREE_FILES=##                   # Change this

# Tree file extension WITHOUT the dot
TREEFORMAT="treefile"

# Output folder for the INGROUP PhyloPyPruner-ready files
APPPF_OUTPUT=##                 # Change this

# Taxonomic group file
#
# APPPFormat uses this file to identify the taxon names and
# determine the correct position of the @ separator.
#
# It does NOT matter which Zygnematophyceae taxonomic-group
# file is used, as long as all taxa present in this dataset
# are represented in the selected file.
TAXONOMIC_GROUP_FILE=##         # Change this


# ------------------------------------------------------------
# APPPFORMAT OPTIONS
# ------------------------------------------------------------

# -i  Folder containing the Newick tree files
#
# -t  Tree file extension without "."
#
# -r  Output folder
#
# -g  Taxonomic group file used to identify the correct
#     taxon names in the tree headers
#
# -m  Folder containing corresponding MAFFT files.
#     APPPFormat can move/copy these into the output folder
#     and change the .mafft extension to .fa.


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -f "${APPPF_PATH}" ]; then
    echo "ERROR: APPPFormat executable not found:"
    echo "${APPPF_PATH}"
    exit 1
fi

if [ ! -d "${TREE_FILES}" ]; then
    echo "ERROR: INGROUP tree folder not found:"
    echo "${TREE_FILES}"
    exit 1
fi

if [ ! -f "${TAXONOMIC_GROUP_FILE}" ]; then
    echo "ERROR: Taxonomic group file not found:"
    echo "${TAXONOMIC_GROUP_FILE}"
    exit 1
fi


# ------------------------------------------------------------
# CREATE OUTPUT DIRECTORY
# ------------------------------------------------------------

mkdir -p "${APPPF_OUTPUT}" || {
    echo "ERROR: Could not create output folder:"
    echo "${APPPF_OUTPUT}"
    exit 1
}


# ============================================================
# RUN APPPFORMAT - INGROUP
# ============================================================

echo
echo "============================================================"
echo "Running APPPFormat - INGROUP"
echo "============================================================"
echo
echo "Tree folder:      ${TREE_FILES}"
echo "Tree extension:   .${TREEFORMAT}"
echo "Taxonomic groups: ${TAXONOMIC_GROUP_FILE}"
echo "Output folder:    ${APPPF_OUTPUT}"
echo


"${APPPF_PATH}" \
    -i "${TREE_FILES}" \
    -t "${TREEFORMAT}" \
    -r "${APPPF_OUTPUT}" \
    -g "${TAXONOMIC_GROUP_FILE}" \
    -m "${TREE_FILES}" \
    || exit 1


# ------------------------------------------------------------
# COPY EXISTING .fa ALIGNMENTS
# ------------------------------------------------------------

# APPPFormat handles .mafft files through the -m option.
#
# If MIAF already produced .fa alignment files, APPPFormat
# currently does not process these through -m.
#
# Therefore copy existing .fa files manually.

shopt -s nullglob

FASTA_FILES=("${TREE_FILES}"/*.fa)

if [ ${#FASTA_FILES[@]} -gt 0 ]; then

    echo
    echo "Copying existing INGROUP .fa alignment files"

    cp "${FASTA_FILES[@]}" "${APPPF_OUTPUT}/" || exit 1

fi


echo
echo "============================================================"
echo "APPPFormat INGROUP completed successfully"
echo "============================================================"
