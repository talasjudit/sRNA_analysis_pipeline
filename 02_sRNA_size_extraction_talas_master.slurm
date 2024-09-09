#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=judit.talas@jic.ac.uk # send-to address
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=2
#SBATCH --job-name=sRNA_size_extraction

source samtools-1.7

libraries=()

# optional loop extracts sRNA sizes 21 to 24

for i in 21 22 24
do
srun samtools view -@ 2 -h ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25_mapped.bam| \
awk -v s=$i 'length($10)==s||$1~/^@/'| \
samtools view -bS - > ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_"$i"_mapped.bam
done
