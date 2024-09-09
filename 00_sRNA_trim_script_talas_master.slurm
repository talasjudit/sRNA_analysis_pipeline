#!/bin/bash -e
#SBATCH -p jic-short
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=judit.talas@jic.ac.uk
#SBATCH --array=0-3
#SBATCH --mem=20G
#SBATCH --cpus-per-task=2
#SBATCH --job-name=sRNA_trim


source fastqc-0.11.3
source trim_galore-0.4.2
source cutadapt-1.9.1

libraries=(SC_rep1 SN_rep1 SC_rep2 SN_rep2)


#############
#For Normal sRNA-seq libraries,the below command is used to remove adaptors
#Check adaptor sequence is correct.

#cutadapt -m 21 -M 25 -a TGGAATTCTCGGGTGCCAAGG ${ARRAY[$SLURM_ARRAY_TASK_ID]}.fastq.gz -o ${ARRAY[$SLURM_ARRAY_TASK_ID]}.fastq_remove_adaptor.gz

#The below command is specialized for removing adaptors from sRNA libraries using the Realseq kit
# -m 21 -M 25 keeps reads of sizes 21-25

srun cutadapt -u 1 -m 21 -M 25 -a TGGAATTCTCGGGTGCCAAGG ${libraries[$SLURM_ARRAY_TASK_ID]}.fastq.gz -o ${libraries[$SLURM_ARRAY_TASK_ID]}_trimmed.fastq.gz

fastqc ${libraries[$SLURM_ARRAY_TASK_ID]}_trimmed.fastq.gz
