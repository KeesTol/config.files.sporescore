#!/bin/bash -i

# Load BLAST module (if using a module system)
conda activate /zfs/omics/projects/metatools/TOOLS/IMP3/conda/1ba2abbb978e5361e652d0d7c4fb2003
#that is why am redoing it. my output is in good2
# Get arguments from command line blastn_run.sh5 1 2 3
QUERY=$1  # First argument: Query FASTA file
DB=$2     # Second argument: BLAST database
OUT=$3    # Third argument: Output file

echo "Starting BLASTn at $(date)"  # Optional: log start time
blastn -task blastn -query "$QUERY" -db "$DB" -evalue 0.001 -out "$OUT" -outfmt 6
echo "BLASTn completed at $(date)"
echo "query = $QUERY , Database = $DB, Output = $OUT"
