#!/bin/bash

# ==============================================================================
# FilterPPPResult (FPPP)
# ==============================================================================

# Program
PROGRAMPATH="/home/maaike/Programs/FilterPPPResult/FilterPPPResult_Debian.out"

# Input: PhyloPyPruner output alignments
INPUT="/data/maaike/Phylogenomics/Zygnematophyceae/Without_Roya/13_PPP/COGS/phylopypruner_output/output_alignments/"

# Output
OUTPUT="/data/maaike/Phylogenomics/Zygnematophyceae/Without_Roya/14_FPPP/30_COGS/"

# Taxonomic group file
TAXONOMIC_GROUPFILE="/data/maaike/Phylogenomics/Zygnematophyceae/TaxonomicGroup/TaxonomicGroupFile_FPPP_Zygnema.txt"

# Directory for the summary file
SUMMARY_FILE="/data/maaike/Phylogenomics/Zygnematophyceae/Without_Roya/14_FPPP/"

# Minimum number of taxonomic groups required
NUMBER_OF_FILTER_GROUPS=30


# ==============================================================================
# Run FilterPPPResult
# ==============================================================================

# With gene IDs and alignments
# "$PROGRAMPATH" \
#     -f "$INPUT" \
#     -t "$TAXONOMIC_GROUPFILE" \
#     -r "$OUTPUT" \
#     -n "$NUMBER_OF_FILTER_GROUPS" \
#     -s "$SUMMARY_FILE"

# Without gene IDs or alignments
"$PROGRAMPATH" \
    -f "$INPUT" \
    -t "$TAXONOMIC_GROUPFILE" \
    -r "$OUTPUT" \
    -n "$NUMBER_OF_FILTER_GROUPS" \
    -s "$SUMMARY_FILE" \
    -a \
    -h
