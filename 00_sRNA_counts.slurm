#!/bin/bash -e
#SBATCH -p jic-short
#SBATCH --mail-type=fail,end
#SBATCH --mail-user=judit.talas@jic.ac.uk
#SBATCH --array=0-8
#SBATCH --mem=20G
#SBATCH --cpus-per-task=2
#SBATCH --job-name=sRNA_counts

source samtools-1.9

libraries=(
WT_SD_rep1 \
WT_SD_rep2 \
WT_SD_merge \
WT_RT_rep1 \
WT_RT_rep2 \
WT_RT_merge \
WT_LF_rep1 \
WT_LF_rep2 \
WT_LF_merge )


touch ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
echo ${libraries[$SLURM_ARRAY_TASK_ID]}_total_count >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
samtools view -@ 2 -h ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28_mapped.bam |cut -f 1 | awk '!seen[$0]++' |wc -l >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt

for i in {18..28}
do
echo ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"_count >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
samtools view -@ 2 -h ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28_mapped.bam| \
awk -v s=$i 'length($10)==s||$1~/^@/'| \
cut -f 1|awk '!seen[$0]++'|wc -l >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
done
