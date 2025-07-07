#!/bin/bash
#SBATCH --job-name=fastp_trim        # Job name
#SBATCH --output=fastp_output_%j.log # Standard output and error log
#SBATCH --ntasks=1                  # Number of tasks
#SBATCH --cpus-per-task=16          # Number of CPU cores per task
#SBATCH --mem=8G                    # Memory allocation
#SBATCH --time=02:00:00             # Maximum wall time

# Activate the Conda environment where fastp is installed
source /zfs/omics/personal/12171115/miniconda3/bin/activate base

# Set the number of threads for Fastp. for this config file i put the mean quality on 1  instead of 5 for the cut right and cut tail value. hopefully this makes a difference.
THREADS=16
fastp --in1 /home/12171115/personal/nienke/s2/mg.r1.fq.gz \
      --out1 /home/12171115/personal/nienke/s2/fastp.s2/mg.r1.trimmed.fq \
      --in2 /home/12171115/personal/nienke/s2/mg.r2.fq.gz \
      --out2 /home/12171115/personal/nienke/s2/fastp.s2/mg.r2.trimmed.fq \
      --unpaired1 /home/12171115/personal/nienke/s2/fastp.s2/mg.se.trimmed.fq.tmp \
      --unpaired2 //home/12171115/personal/nienke/s2/fastp.s2/mg.se.trimmed.fq.tmp \
      --overrepresentation_analysis \
      --overrepresentation_sampling 20 \
      --merge \
      --merged_out /home/12171115/personal/nienke/s2/fastp.s2/mg.merged.trimmed.fq \
      --length_required 40 \
      --length_limit 0 \
      --cut_right --cut_right_window_size 1 \
      --cut_right_mean_quality 1 \
      --cut_tail --cut_tail_window_size 1 \
      --cut_tail_mean_quality 1 \
      --trim_tail1 1 \
      --trim_front1 10 \
      --trim_poly_g --poly_g_min_len 10 \
      --qualified_quality_phred 15 \
      --unqualified_percent_limit 40 \
      --n_base_limit 5 \
      --average_qual 0 \
      --complexity_threshold 30 \
      --detect_adapter_for_pe \
      --thread 16 \
      --json /home/12171115/personal/nienke/s2/fastp.s2/fastp.mg.json \
      --html /home/12171115/personal/nienke/s2/fastp.s2/fastp.mg.html
cat /home/12171115/personal/nienke/s2/fastp.s2//mg.se.trimmed.fq.tmp /home/12171115/personal/nienke/s2/fastp.s2/mg.merged.trimmed.fq > /home/12171115/personal/nienke/s2/fastp.s2//mg.se.trimmed.fq
