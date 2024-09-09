#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH -t 0-01:00:00
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=judit.talas@jic.ac.uk # send-to address
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=bam2gff_weighted

source samtools-1.7
source python-2.7.5
source bssequel-0.0.1
source xftools-0.0.1

libraries=()

srun weighted_w1_extractor -i ${libraries[$SLURM_ARRAY_TASK_ID]}_24_cluster_overlapped_24_reads.bam -o ${libraries[$SLURM_ARRAY_TASK_ID]}_w1_24_overlapped_clusters.gff



#Everything below is to remove rRNA reads. May not be needed.


#perl -S window_gff.pl -w 1 -s 1 -c sum ${libraries[$SLURM_ARRAY_TASK_ID]}.gff -o ${libraries[$SLURM_ARRAY_TASK_ID]}.summed.gff

#perl -S overlaps_gff.pl -g TAIR10_GFF3-rRNA.Xiao25K.v2.gff -m -k -t 'ID' ${libraries[$SLURM_ARRAY_TASK_ID]}.summed.gff > ${libraries[$SLURM_ARRAY_TASK_ID]}.rRNAoverlap.w1.summed.gff

#finds reads in gff format overlapping rRNA.

#grep -v "ID=AT" ${libraries[$SLURM_ARRAY_TASK_ID]}.rRNAoverlap.w1.summed.gff > ${libraries[$SLURM_ARRAY_TASK_ID]}.rRNAdepleted.summed.gff

#removes rRNA reads in gff format
