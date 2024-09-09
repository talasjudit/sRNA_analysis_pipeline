#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=judit.talas@jic.ac.uk # send-to address
#SBATCH --array=0-2
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=total_mapped_reads_cluster

source bedtools-2.27.0

libraries=(WT_root WT_leaf WT_seedling)



source samtools-1.7

srun samtools view -@ 3 ${libraries[$SLURM_ARRAY_TASK_ID]}_24_cluster_overlapped_24_reads.bam |cut -f 1|awk '!seen[$0]++' |wc -l > ${libraries[$SLURM_ARRAY_TASK_ID]}_24_cluster_overlapped_24_reads.txt 

