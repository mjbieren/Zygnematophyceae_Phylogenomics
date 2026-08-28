#!/bin/bash

# ============================================================
# Trinity assembly script
#
# Expected folder structure:
#
# ~/STRAINNAME/
# ├── RawData/
# │   ├── SAMPLE1_1.fq.gz
# │   └── SAMPLE1_2.fq.gz
# └── Trinity.sh
#
# Output:
# STRAINNAME.Trinity.fasta
# STRAINNAME.Trinity.gene_maps
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

SINGULARITY_HOME_PATH="${PWD}"
# Generally don't change unless you know what you're doing ;)

CPU=24
RAM=300G

# Uses the current directory name as strain name
STRAIN="${PWD##*/}"

# Trinity temporary/output directory
# Trinity --full_cleanup normally removes most of this itself
TRINITY_OUTPUT="Trinity_Output"


# ------------------------------------------------------------
# RAW READS
# ------------------------------------------------------------

# Full path to LEFT/R1 reads
IN1="/home/RawData/SAMPLE1_1.fq.gz"

# Full path to RIGHT/R2 reads
IN2="/home/RawData/SAMPLE1_2.fq.gz"

# For multiple libraries, comma-separate the files:
#
# IN1="/path/sample1_1.fq.gz,/path/sample2_1.fq.gz"
# IN2="/path/sample1_2.fq.gz,/path/sample2_2.fq.gz"


# ------------------------------------------------------------
# TRINITY SINGULARITY IMAGE
# ------------------------------------------------------------

SINGULARITY_TRINITY_IMAGE=~/Singularity_Objects/Trinity/trinityrnaseq.v2.15.1.simg


# ------------------------------------------------------------
# NOVOGENE ADAPTER FILE
# ------------------------------------------------------------

NOVOGENE_ADAPTERS="~/novogene_adapter_sequences.fa" #Change this to the right adapater


# ============================================================
# RUN TRINITY
# ============================================================

echo "========================================"
echo "Running Trinity"
echo "Strain: ${STRAIN}"
echo "CPU:    ${CPU}"
echo "RAM:    ${RAM}"
echo "========================================"


singularity exec \
    --home "${SINGULARITY_HOME_PATH}:/home" \
    -e \
    "${SINGULARITY_TRINITY_IMAGE}" \
    Trinity \
    --seqType fq \
    --left "${IN1}" \
    --right "${IN2}" \
    --output "/home/${TRINITY_OUTPUT}" \
    --CPU "${CPU}" \
    --max_memory "${RAM}" \
    --trimmomatic \
    --quality_trimming_params \
    "ILLUMINACLIP:${NOVOGENE_ADAPTERS}:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36" \
    --full_cleanup


# ============================================================
# RENAME OUTPUT
# ============================================================

echo "Renaming Trinity output files..."

mv \
    "${SINGULARITY_HOME_PATH}/${TRINITY_OUTPUT}.Trinity.fasta" \
    "${SINGULARITY_HOME_PATH}/${STRAIN}.Trinity.fasta"

mv \
    "${SINGULARITY_HOME_PATH}/${TRINITY_OUTPUT}.Trinity.fasta.gene_trans_map" \
    "${SINGULARITY_HOME_PATH}/${STRAIN}.Trinity.gene_maps"


# ============================================================
# CLEANUP
# ============================================================

# Remove Trinity output directory if it still exists.
# --full_cleanup normally handles this already.
rm -rf "${SINGULARITY_HOME_PATH:?}/${TRINITY_OUTPUT}" || true


echo "========================================"
echo "Trinity finished: ${STRAIN}"
echo
echo "Output:"
echo "${STRAIN}.Trinity.fasta"
echo "${STRAIN}.Trinity.gene_maps"
echo "========================================"
