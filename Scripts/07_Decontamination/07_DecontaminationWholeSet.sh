#!/usr/bin/env bash
set -euo pipefail

# Protein directory after TransDecoder (or predetermined protein files).
WORKDIR="${WORKDIR:-/path/to/proteins}"
# Combined MMseqs2 decontamination database used in the project.
DB="${DB:-/path/to/Decontamination_Zygn_DB.db}"
# GPDS header file describing negative and positive database partitions.
HEADERFILE="${HEADERFILE:-$(dirname "$0")/Headerfile_zygn.txt}"
COPYDIR="${COPYDIR:-/path/to/positive_sets}"
PROGRAM_PATH="${PROGRAM_PATH:-/path/to/GPDS_Debian_Static.out}"
PATH_TO_SIMPLIFY_HEADER_SCRIPT="${PATH_TO_SIMPLIFY_HEADER_SCRIPT:-/path/to/simplify_headers_for_blastdb.py}"
MMSEQSPATH="${MMSEQSPATH:-mmseqs}"
THREADS="${THREADS:-8}"

mkdir -p "$COPYDIR"
cd "$WORKDIR"

for pep in *_genes_supertranscript.fasta.transdecoder.pep; do
    [[ -e "$pep" ]] || continue
    f="${pep%_genes_supertranscript.fasta.transdecoder.pep}"
    echo "[decontamination] $f"

    "$MMSEQSPATH" createdb "$pep" "${f}_DB.db"
    "$MMSEQSPATH" createindex "${f}_DB.db" "tmp_index_${f}" --threads "$THREADS"
    rm -rf "tmp_index_${f}"

    "$MMSEQSPATH" search "${f}_DB.db" "$DB" "${f}_vs_Decontamination.mmseqs2_decont" "tmp_${f}" \
        --start-sens 1 --sens-steps 3 -s 7 --alignment-mode 3 --max-seqs 10 --threads "$THREADS"

    "$MMSEQSPATH" convertalis "${f}_DB.db" "$DB" "${f}_vs_Decontamination.mmseqs2_decont" \
        "${f}_vs_Decontamination.mmseqs2_decont.outfmt6" --format-mode 2

    mkdir -p "${f}_GPDS"
    "$PROGRAM_PATH" -i "$HEADERFILE" -f "$pep" \
        -b "${f}_vs_Decontamination.mmseqs2_decont.outfmt6" -c 11 -s "$f" -r "${WORKDIR}/${f}_GPDS/"

    # GPDS positive-output filename depends on the positive label in the database/header file.
    # Set POSITIVE_FILE explicitly if your GPDS build uses a different filename.
    POSITIVE_FILE="${POSITIVE_FILE:-${WORKDIR}/${f}_GPDS/${f}_Zygnematophyceae.fa}"
    if [[ -f "$POSITIVE_FILE" ]]; then
        python "$PATH_TO_SIMPLIFY_HEADER_SCRIPT" "$POSITIVE_FILE" "$f" > "${COPYDIR}/${f}.fa"
    else
        echo "WARNING: positive GPDS output not found at $POSITIVE_FILE" >&2
    fi
    rm -rf "tmp_${f}"
done
