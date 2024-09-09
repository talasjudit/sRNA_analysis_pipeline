#!/bin/bash -e
#SBATCH -p jic-short
#SBATCH --mail-type=fail,end
#SBATCH --mail-user=judit.talas@jic.ac.uk
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=sRNA_counts

source samtools-1.9

libraries=()


# Create txt to input sRNA counts of desired length
touch ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
# total mapped counts
echo ${libraries[$SLURM_ARRAY_TASK_ID]}_total_count >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
samtools view -@ 2 -h ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28_mapped.bam |cut -f 1 | awk '!seen[$0]++' |wc -l >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt

#sRNA counts of certain lengths
for i in {18..28}
do
echo ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"_count >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
samtools view -@ 2 -h ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28_mapped.bam| \
awk -v s=$i 'length($10)==s||$1~/^@/'| \
cut -f 1|awk '!seen[$0]++'|wc -l >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
done
