#!/bin/bash
#SBATCH --job-name=blastp_job        # Job name
#SBATCH --output=blastp_%j.out       # Standard output (%j is the job ID)
#SBATCH --error=blastp_%j.err        # Standard error (%j is the job ID)
#SBATCH --time=02:00:00              # Time limit (hh:mm:ss)
#SBATCH --mem=8G                     # Memory request
#SBATCH --cpus-per-task=4           # Number of CPU cores per task
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for BLASTp)
#SBATCH --partition=all   # Idk if this is right?

# Activate the correct conda environment
conda activate /zfs/omics/projects/metatools/TOOLS/IMP3/conda/1ba2abbb978e5361e652d0d7c4fb2003
# Define file paths
INPUT_DB="/home/12171115/personal/nienke/s2/IMP_output_s2/Analysis/annotation/prokka.faa"  # Your unknown sequences (query)
QUERY_FILE="/zfs/omics/projects/metatools/SANDBOX/sporeScore/NienkesData/concatenated_uniref.fasta"  # Known sequences (database)
OUTPUT_FILE="/home/12171115/personal/nienke/s2/Blast.result.s2"  # Desired output file path for BLAST results

# Step 1: Build the BLAST database using makeblastdb (if not already built)
echo "Starting makeblastdb..."
start_time_makeblastdb=$(date +%s)  # Record the start time for makeblastdb
makeblastdb -in $INPUT_DB -dbtype prot -parse_seqids
end_time_makeblastdb=$(date +%s)  # Record the end time for makeblastdb
elapsed_time_makeblastdb=$((end_time_makeblastdb - start_time_makeblastdb))
echo "makeblastdb took $elapsed_time_makeblastdb seconds."

# Step 2: Run BLASTp against the database with your query file
echo "Starting blastp..."
start_time_blastp=$(date +%s)  # Record the start time for blastp
blastp -db $INPUT_DB -query $QUERY_FILE -outfmt 7 -out $OUTPUT_FILE -max_target_seqs 1000
end_time_blastp=$(date +%s)  # Record the end time for blastp
elapsed_time_blastp=$((end_time_blastp - start_time_blastp))
echo "blastp took $elapsed_time_blastp seconds."

echo "BLASTp job completed successfully."

