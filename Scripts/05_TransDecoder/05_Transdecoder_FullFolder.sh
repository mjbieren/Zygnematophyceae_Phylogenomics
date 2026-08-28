#!/bin/bash

# ============================================================
# TransDecoder + BLAST
#
# Runs TransDecoder on ALL SuperTranscript files:
#     *_genes_supertranscript.fasta
#
# Normal/local use - no SLURM/HPC
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

CPU=24

# Folder containing the SuperTranscript FASTA files
SUPERTRANSCRIPT_FOLDER=##     # Change this


# ------------------------------------------------------------
# BLAST REFERENCE DATABASE
# ------------------------------------------------------------

# WARNING:
# A BLAST protein database has to be created BEFORE running
# this script.
#
# Use the Zygnematophyceae axenic .faa protein sequences:
#
# makeblastdb \
#     -in Zygnematophyceae_axenic.faa \
#     -parse_seqids \
#     -title "Zygnematophyceae_axenic_DB" \
#     -dbtype prot \
#     -blastdb_version 4
#
# BLAST_DB must point to the resulting BLAST database prefix.
#
# If makeblastdb was run directly on:
#
#     Zygnematophyceae_axenic.faa
#
# without specifying -out, this will normally be:
#
#     /path/to/Zygnematophyceae_axenic.faa

BLAST_DB="/path/to/Zygnematophyceae_axenic.faa"    # Change this


# ------------------------------------------------------------
# OPTIONAL: ACTIVATE CONDA ENVIRONMENT
# ------------------------------------------------------------

# Uncomment/change if TransDecoder and BLAST are installed
# in a Conda environment.
#
# source "$(conda info --base)/etc/profile.d/conda.sh"
# conda activate transdecoder


# ============================================================
# RUN TRANSDECODER FOR EVERY SUPERTRANSCRIPT FILE
# ============================================================

shopt -s nullglob

FILES=("${SUPERTRANSCRIPT_FOLDER}"/*_genes_supertranscript.fasta)

if [ ${#FILES[@]} -eq 0 ]; then
    echo "ERROR: No *_genes_supertranscript.fasta files found in:"
    echo "${SUPERTRANSCRIPT_FOLDER}"
    exit 1
fi


for IN1 in "${FILES[@]}"
do

    # --------------------------------------------------------
    # Set filenames
    # --------------------------------------------------------

    FILE_NAME=$(basename "${IN1}")
    STRAIN="${FILE_NAME%_genes_supertranscript.fasta}"

    OUT="${IN1}.transdecoder_dir"
    IN2="${OUT}/longest_orfs.pep"
    OUT2="${OUT}/blastp.outfmt6"


    echo
    echo "============================================================"
    echo "Processing: ${STRAIN}"
    echo "Input:      ${IN1}"
    echo "============================================================"


    # --------------------------------------------------------
    # Create output folder
    # --------------------------------------------------------

    mkdir -p "${OUT}" || exit 1


    # ========================================================
    # STEP 1
    # Extract long open reading frames
    # ========================================================

    echo
    echo "Step 1: Extract long open reading frames"

    TransDecoder.LongOrfs \
        -t "${IN1}" \
        -O "${OUT}" \
        || exit 1


    # ========================================================
    # STEP 2
    # Identify ORFs with homology using BLASTP
    # ========================================================

    echo
    echo "Step 2: Identify ORFs with BLASTP"

    blastp \
        -query "${IN2}" \
        -db "${BLAST_DB}" \
        -max_target_seqs 1 \
        -outfmt 6 \
        -evalue 1e-5 \
        -num_threads "${CPU}" \
        > "${OUT2}" \
        || exit 1


    # ========================================================
    # STEP 3
    # Predict likely coding regions
    # ========================================================

    echo
    echo "Step 3: Predict likely coding regions"

    TransDecoder.Predict \
        -t "${IN1}" \
        -O "${OUT}" \
        --single_best_only \
        --retain_blastp_hits "${OUT2}" \
        || exit 1


    echo
    echo "${STRAIN}: TransDecoder completed successfully."

done


echo
echo "============================================================"
echo "ALL SUPERTRANSCRIPT FILES FINISHED"
echo "============================================================"