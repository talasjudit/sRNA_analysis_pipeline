#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH -t 0-01:00:00
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=judit.talas@jic.ac.uk # send-to address
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=bamclusterOL

libraries=()

source bedtools-2.27.0

bedtools intersect -abam ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_24_mapped.bam -b ${libraries[$SLURM_ARRAY_TASK_ID]}_24nt_clusters_sorted.gff -wa > ${libraries[$SLURM_ARRAY_TASK_ID]}_24_cluster_overlapped_24_reads.bam
