#!/bin/bash

# ============================================================
# Filter PhyloPyPruner Result (FPPP) - OUTGROUP
#
# FilterPPPResult:
# https://github.com/mjbieren/FilterPPPResult
#
# PhyloPyPruner can split orthogroups into multiple subgroups.
# These resulting groups can contain too few representatives
# from the required taxonomic groups.
#
# FilterPPPResult filters these resulting FASTA files based
# on a taxonomic-group threshold.
#
# This script is specifically for the OUTGROUP dataset.
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

# Path to FilterPPPResult executable
PROGRAMPATH=##                  # Change this

# PhyloPyPruner OUTGROUP output alignments
#
# Usually:
# phylopypruner_output/output_alignments/
INPUT=##                        # Change this

# Output folder for the filtered OUTGROUP loci
OUTPUT=##                       # Change this

# Zygnematophyceae taxonomic group file used for filtering
# the PhyloPyPruner results
TAXONOMIC_GROUPFILE="TaxonomicGroupFile_FPPP_Zygnema.txt"

# Output folder for the FilterPPPResult summary
SUMMARY_FILE=##                 # Change this

# Minimum number of different taxonomic groups that must
# be represented for a locus to be retained
NUMBER_OF_FILTER_GROUPS=10


# ------------------------------------------------------------
# FILTERING SETTINGS
# ------------------------------------------------------------

# This OUTGROUP analysis uses:
#
#   TaxonomicGroupFile_FPPP_Zygnema.txt
#
# with a threshold of:
#
#   10 taxonomic groups
#
# A PhyloPyPruner output locus is retained only when at least
# 10 DIFFERENT taxonomic groups defined in the taxonomic-group
# file are represented.
#
# IMPORTANT:
# NUMBER_OF_FILTER_GROUPS refers to the number of different
# taxonomic groups represented, not simply the number of
# sequences or strains.


# ------------------------------------------------------------
# FILTERPPPRESULT OPTIONS
# ------------------------------------------------------------

# -f  Folder containing the PhyloPyPruner output alignments
#
# -t  Taxonomic group file
#
# -r  Output folder
#
# -n  Minimum number of taxonomic groups required
#
# -s  Path where the summary file should be written
#
# -h  Remove gene IDs from FASTA headers.
#     Only the strain/species names are retained.
#
# -a  Remove alignment gaps ("-") from the sequences.
#
#
# For this workflow we use:
#
#   -a -h
#
# The resulting sequences therefore:
#
#   - contain only strain/species names in their headers
#   - are no longer aligned
#
# These sequences can subsequently be realigned from scratch.


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -f "${PROGRAMPATH}" ]; then
    echo "ERROR: FilterPPPResult executable not found:"
    echo "${PROGRAMPATH}"
    exit 1
fi

if [ ! -d "${INPUT}" ]; then
    echo "ERROR: PhyloPyPruner OUTGROUP alignment folder not found:"
    echo "${INPUT}"
    exit 1
fi

if [ ! -f "${TAXONOMIC_GROUPFILE}" ]; then
    echo "ERROR: FPPP taxonomic group file not found:"
    echo "${TAXONOMIC_GROUPFILE}"
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
# RUN FILTERPPPRESULT - OUTGROUP
# ============================================================

echo
echo "============================================================"
echo "Running FilterPPPResult - OUTGROUP"
echo "============================================================"
echo
echo "Input:             ${INPUT}"
echo "Taxonomic groups:  ${TAXONOMIC_GROUPFILE}"
echo "Minimum groups:    ${NUMBER_OF_FILTER_GROUPS}"
echo "Output:            ${OUTPUT}"
echo "Remove gene IDs:   YES"
echo "Remove gaps:       YES"
echo


"${PROGRAMPATH}" \
    -f "${INPUT}" \
    -t "${TAXONOMIC_GROUPFILE}" \
    -r "${OUTPUT}" \
    -n "${NUMBER_OF_FILTER_GROUPS}" \
    -s "${SUMMARY_FILE}" \
    -a \
    -h \
    || exit 1


echo
echo "============================================================"
echo "FilterPPPResult OUTGROUP completed successfully"
echo "============================================================"