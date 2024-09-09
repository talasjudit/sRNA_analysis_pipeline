#!/bin/bash -e
#SBATCH -p nbi-medium
#SBATCH --mem=20G
#SBATCH -t 0-06:00
#SBATCH --array=0
#SBATCH --cpus-per-task=1
#SBATCH --job-name=sstck
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=Judit.Talas@jic.ac.uk

libraries=()

source samtools-1.9
source perl-5.16.2
source shortstack-3.8.5
source bowtie-1.1.2

#samtools sort -o ${libraries[$SLURM_ARRAY_TASK_ID]}_sorted_sRNA_0_mismatch_24_mapped.bam ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_24_mapped.bam

srun perl ~/thegroup/Judit_Talas/ShortStack/ShortStack.pl --nohp \
--bamfile ${libraries[$SLURM_ARRAY_TASK_ID]}_sorted_sRNA_0_mismatch_24_mapped.bam \
--genomefile ~/thegroup/Judit_Talas/TAIR10_ref/TAIR10_reference.fasta \
--outdir ShortStack_${libraries[$SLURM_ARRAY_TASK_ID]}_24_0_mismatch

