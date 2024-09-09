#!/bin/bash -e
#SBATCH -p jic-short
#SBATCH --mail-type=fail,end
#SBATCH --mail-user=judit.talas@jic.ac.uk
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=sRNA_counts

source bedtools-2.27.1

libraries=()

touch ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt

# define desired sRNA lengths
for i in 21 22 24
# define desired genic feaatures/clusters
do
for j in classy1_dependent classy2_dependent classy3_dependent classy4_dependent classy1_2_dependent classy3_4_dependent classy_quad_dependent
do
echo "$j"_${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"_count >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
srun cut -f 1,4,5,6 ${libraries[$SLURM_ARRAY_TASK_ID]}_w1_"$i"_overlapped_clusters.gff | \
sort -k1,1 -k2,2n | sed  "s/"chr"//g"| \
intersectBed -a "$j"_sorted.bed -b - -wa -wb -sorted | \
bedtools groupby -g 1,2,3 -c 7 -o sum | \
awk -v s=$i -v OFS="\t" '{print $1,$2,$3,$4/s}' | \
awk '{sum+=$4} END{print sum}' >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
done
# add total sRNA counts to txt files
echo ${libraries[$SLURM_ARRAY_TASK_ID]}_total_count >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
srun cut -f 1,4,5,6 ${libraries[$SLURM_ARRAY_TASK_ID]}_w1_"$i"_overlapped_clusters.gff | \
sort -k1,1 -k2,2n |sed  "s/"chr"//g"| \
bedtools groupby -g 1,2,3 -c 4 -o sum | \
awk -v s=$i -v OFS="\t" '{print $1,$2,$3,$4/s}' |\
awk '{sum+=$4} END{print sum}' >> ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_counts.txt
done
