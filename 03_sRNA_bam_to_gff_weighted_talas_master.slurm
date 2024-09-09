#!/bin/bash -e
#SBATCH -p jic-medium # partition (queue)
#SBATCH -t 0-06:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=judit.talas@jic.ac.uk
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=6
#SBATCH --job-name=bam2gff_weighted

source samtools-1.7
source python-2.7.5
source bssequel-0.0.1
source xftools-0.0.1

libraries=()

# creates w1 gff file, loop for sRNA lengths optional

for i in 21 22 24
do
srun weighted_w1_extractor -i ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_"$i"_mapped.bam -o ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i".gff
done

#Everything below is to remove rRNA reads. May not be needed.


#perl -S window_gff.pl -w 1 -s 1 -c sum ${libraries[$SLURM_ARRAY_TASK_ID]}.gff -o ${libraries[$SLURM_ARRAY_TASK_ID]}.summed.gff

#perl -S overlaps_gff.pl -g TAIR10_GFF3-rRNA.Xiao25K.v2.gff -m -k -t 'ID' ${libraries[$SLURM_ARRAY_TASK_ID]}.summed.gff > ${libraries[$SLURM_ARRAY_TASK_ID]}.rRNAoverlap.w1.summed.gff

#finds reads in gff format overlapping rRNA.

#grep -v "ID=AT" ${libraries[$SLURM_ARRAY_TASK_ID]}.rRNAoverlap.w1.summed.gff > ${libraries[$SLURM_ARRAY_TASK_ID]}.rRNAdepleted.summed.gff

#removes rRNA reads in gff format
