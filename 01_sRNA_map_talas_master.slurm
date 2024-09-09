#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=Judit.Talas@jic.ac.uk
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=2
#SBATCH --job-name=sRNA_map

source package /nbi/software/testing/bin/bowtie-1.0.1
source samtools-1.7

libraries=()

#create bam file with 0 or up to 3 mismatches against TAIR10 with bowtie (optionally sort/remove unmapped reads). Collects *all* hits and sorts them best to worst.

zcat ../fastqs/trimmed/${libraries[$SLURM_ARRAY_TASK_ID]}_trimmed.fastq.gz | \
bowtie \
  -a \
  --best \
  -v 0 \
  -S \
  -q ~/thegroup/Sam_Deans/TAIR10_ref/TAIR10 \
  - | \
samtools view -hb > ../BAMs/${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28.bam

#remove unmapped reads
samtools view -b -F 4 ../BAMs/${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28.bam > ../BAMs/${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28_mapped.bam

#sort bam file and create index
#samtools sort -o sorted_${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25.bam ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25.bam
#samtools index sorted_${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25.bam


#3 mismatches
#zcat ${libraries[$SLURM_ARRAY_TASK_ID]}._trimmed.fastq.gz | \
#bowtie \
#  -a \
#  --best \
#  -v 3 \
#  -S \
#  -q ~/thegroup/Sam_Deans/TAIR10_ref/TAIR10 \
#  - | \
#samtools view -hb > ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_3_mismatch_21_25.bam

#remove unmapped reads
#samtools view -b -F 4 ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25.bam > ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25_mapped.bam

#sort bam file and create index
#samtools sort -o sorted_${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25.bam ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25.bam
#samtools index sorted_${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_21_25.bam
