#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH -t 0-01:00:00
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=judit.talas@jic.ac.uk # send-to address
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=bedout2RPKM

libraries=()

for i in 21 22 24
do
# loop for iterating across desired genic features
for j in cRdDM Hyper_TEs miRNAs MetGenes Genes
do
#creates tsv with positional information + RPKM values
cat "$j"_${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"_RPKM.tsv | \
awk -v OFS="\t" '{print $1,$2,$3,(log($4+1)/log(2))}' > "$j"_${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"_RPKM_log2_norm_total_reads.tsv
done
done

