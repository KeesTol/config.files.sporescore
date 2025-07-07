#!/bin/bash
#SBATCH --job-name=fastq_to_fasta    # Job name
#SBATCH --output=fastq_to_fasta_%j.log # Output log
#SBATCH --ntasks=1                   # Number of tasks
#SBATCH --cpus-per-task=4            # Number of CPU cores
#SBATCH --mem=4G                     # Memory allocation
#SBATCH --time=01:00:00              # Max time

# Load Seqtk module (if applicable, otherwise remove this line)
module load seqtk

# Convert FASTQ to FASTA
seqtk seq -a mg.se.trimmed.fq > mg.se.trimmed.fasta
seqtk seq -a mg.r1.trimmed.fq > mg.r1.trimmed.fasta
seqtk seq -a mg.r2.trimmed.fq > mg.r2.trimmed.fasta

# Combine all FASTA files into one
cat mg.se.trimmed.fasta mg.r1.trimmed.fasta mg.r2.trimmed.fasta > combined.fasta.fastp

# Count reads and store in read_countst.txt
echo -e "mg.r1.trimmed.fq\t$(($(wc -l < mg.r1.trimmed.fq) / 4))" >> read_countst.txt
echo -e "mg.r2.trimmed.fq\t$(($(wc -l < mg.r2.trimmed.fq) / 4))" >> read_countst.txt
echo -e "mg.se.trimmed.fq\t$(($(wc -l < mg.se.trimmed.fq) / 4))" >> read_countst.txt

echo "Conversion and read counting complete!"
