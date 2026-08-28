#!/bin/bash

# ============================================================
# OrthoFinder
#
# Input:
#   One protein FASTA file per species/strain.
#
# The input folder can contain the positive protein datasets
# produced after the GPDS decontamination step.
#
# OrthoFinder:
# https://github.com/davidemms/OrthoFinder
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

CPU_SEARCH=40
CPU_ANALYSIS=12

# Folder containing one protein FASTA file per species/strain
SPECIES_DIR=##          # Change this

# Rooted guide/species tree
TREE_FILE=##            # Change this

# Output directory
#
# WARNING:
# Do NOT create the final OrthoFinder results directory
# manually. OrthoFinder creates its result directory itself.
OUTPUT_DIR=##           # Change this

# Name appended to the OrthoFinder results directory
OUTPUT_SUFFIX=##        # Change this


# ------------------------------------------------------------
# OPTIONAL: ACTIVATE CONDA ENVIRONMENT
# ------------------------------------------------------------

# If OrthoFinder is installed in a Conda environment:
#
# source "$(conda info --base)/etc/profile.d/conda.sh"
# conda activate orthofinder


# ------------------------------------------------------------
# CHECK INPUT
# ------------------------------------------------------------

if [ ! -d "${SPECIES_DIR}" ]; then
    echo "ERROR: Species input directory not found:"
    echo "${SPECIES_DIR}"
    exit 1
fi

if [ ! -f "${TREE_FILE}" ]; then
    echo "ERROR: Guide tree not found:"
    echo "${TREE_FILE}"
    exit 1
fi


# ------------------------------------------------------------
# IMPORTANT INPUT NOTES
# ------------------------------------------------------------

# OrthoFinder expects one protein FASTA file per species/strain.
#
# For this workflow, these can be the positive protein datasets
# obtained after the GPDS decontamination step.
#
# The filename is used by OrthoFinder to identify the species,
# so use clear and unique strain/species names.
#
# Example:
#
# ACOI_1666.fa
# ACOI_1668.fa
# SAG_698-1a.fa
# ZygnemaMat.fa
#
#
# WARNING:
# TREE_FILE must contain the same species/strain names as the
# input FASTA files.
#
# For example, if the input is:
#
#     ACOI_1666.fa
#
# the guide tree should contain:
#
#     ACOI_1666
#
# Mismatching names can cause problems when OrthoFinder tries
# to use the user-supplied species tree.


# ============================================================
# RUN ORTHOFINDER
# ============================================================

echo
echo "============================================================"
echo "Running OrthoFinder"
echo "Input folder: ${SPECIES_DIR}"
echo "Guide tree:   ${TREE_FILE}"
echo "============================================================"
echo


orthofinder \
    -f "${SPECIES_DIR}" \
    -S diamond \
    -M msa \
    -A mafft \
    -T fasttree \
    -t "${CPU_SEARCH}" \
    -a "${CPU_ANALYSIS}" \
    -y \
    -s "${TREE_FILE}" \
    -n "${OUTPUT_SUFFIX}" \
    -o "${OUTPUT_DIR}" \
    > "orthofinder_${OUTPUT_SUFFIX}.log" 2>&1


if [ $? -ne 0 ]; then
    echo
    echo "ERROR: OrthoFinder failed."
    echo "See:"
    echo "orthofinder_${OUTPUT_SUFFIX}.log"
    exit 1
fi


echo
echo "============================================================"
echo "OrthoFinder completed successfully"
echo
echo "Log file:"
echo "orthofinder_${OUTPUT_SUFFIX}.log"
echo "============================================================"
