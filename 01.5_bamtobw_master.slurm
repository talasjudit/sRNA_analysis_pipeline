#!/bin/bash -e
#SBATCH -p jic-short # partition (queue)
#SBATCH -t 0-02:00:00
#SBATCH --mail-type=fail,end
#SBATCH --mail-user=Judit.Talas@jic.ac.uk
#SBATCH --array=0
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=bamtobw

source deeptools-3.1.1
source samtools-1.9

libraries=()

# outputs sorted bigwig files (binsize1)

# desired sRNA lengths
for i in 21 22 24
do
#sort and index mapped bam files
samtools sort -o sorted_${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_"$i"_mapped.bam ${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_"$i"_mapped.bam
samtools index sorted_${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_"$i"_mapped.bam

#create bigwig file (unsorted)
bamCoverage -p 3 -b sorted_${libraries[$SLURM_ARRAY_TASK_ID]}_sRNA_0_mismatch_"$i"_mapped.bam -bs 1 --effectiveGenomeSize 135670229 --normalizeUsing RPKM -o ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1.bw
~/mygroup/bigWigToBedGraph ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1.bw ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1.bedgraph

#convert to bedgraph, sort and convert back 
cat ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1.bedgraph |sort -k1,1 -k2,2n | sed "s/"chr"//g"   > ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1_sorted.bedgraph
~/mygroup/bedGraphToBigWig ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1_sorted.bedgraph ~/mygroup/size_At_genome_modified_Pt_Mt.txt ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1_sorted.bw

#remove bedgraph and unsorted bw files
rm ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1.bedgraph
rm ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1_sorted.bedgraph
rm ${libraries[$SLURM_ARRAY_TASK_ID]}_"$i"nt_binsize1.bw

done
