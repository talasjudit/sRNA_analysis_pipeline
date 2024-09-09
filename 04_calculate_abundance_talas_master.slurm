#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=judit.talas@jic.ac.uk # send-to address
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=sRNA_abundance

libraries=()


source bedtools-2.27.0

# inner loop creates .bedout file from gff file which calculates an abundance score for sRNA reads for a given genomic feature (in this case it loops through cRdDM Hyper_TEs miRNAs MetGenes Genes annotations )

for i in 21 22 24
do
for j in cRdDM Hyper_TEs miRNAs MetGenes Genes
do
srun cut -f 1,4,5,6 ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i".gff |\
sort -k1,1 -k2,2n |sed  "s/"chr"//g"| \
bedtools intersect -a ./"$j"_sorted.bed -b - -wa -wb -sorted -loj | \
awk '{OFS="\t";if($7==".") print $1,$2,$3,$4,$5,$6,0; else print $0}' | \
bedtools groupby -g 1,2,3 -c 7 -o sum |awk -v s=$i -v OFS="\t" '{print $1,$2,$3,$4/s}' > "$j"_${libraries[$SLURM_ARRAY_TASK_ID]}_"$i".bedout
done
done
