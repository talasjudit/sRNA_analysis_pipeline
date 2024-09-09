#!/bin/bash -e
#SBATCH -p jic-short
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=judit.talas@jic.ac.uk
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=RPKM


libraries=()


# loop for iterating over a range of sRNA sizes - may not be needed
for i in 21 22 24
do
# loop for iterating across desired genic features
for j in cRdDM Hyper_TEs miRNAs MetGenes Genes
do
# define environment variable for desired normalisation (in this case I chose the number of 21-25nt total mapped sRNA reads)
source samtools-1.9;
total_reads=`samtools view -@ 3 ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_18_28_mapped.bam|cut -f 1|awk '!seen[$0]++'|wc -l`;
#creates tsv with positional information + RPKM values
cat "$j"_${libraries[$SLURM_ARRAY_TASK_ID]}_"$i".bedout |\
awk -v OFS="\t" -v reads=$total_reads '{print $1,$2,$3,($4/(reads/1000000)/(($3-$2)/1000))}' > "$j"_${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"_RPKM.tsv
done
done

## optional merging outputs

#for j in merge rep1 rep2
#do
#paste ${libraries[$SLURM_ARRAY_TASK_ID]}_"$j"_24_RPKM.tsv ${libraries[$SLURM_ARRAY_TASK_ID]}_"$j"_25_RPKM.tsv | awk -v OFS="\t" '{print $1,$2,$3,$4,$8}' > ${libraries[$SLURM_ARRAY_TASK_ID]}_"$j"_24_25_RPKM.tsv
#done
