#!/bin/bash

#SBATCH -N 1 
#SBATCH -n 8
#SBATCH -p cigene,hugemem
#SBATCH -J phase_777
#SBATCH --output=slurm/impute25k_job%A_arrayJ_%a.log
##SBATCH --mem=25000
##SBATCH --mem-per-cpu=6000

## Usage: sbatch -a 1-29 beagle_array.sh arrayfile

set -o nounset   # Prevent unset variables from been used.
set -o errexit   # Exit if error occurs

beagle41=/mnt/users/tikn/bioinf_tools/beagle4/beagle.22Feb16.8ef.jar #beagle 4.1 feb22 16

TASK=$SLURM_ARRAY_TASK_ID
arrayfile=$1
chrom=$(awk ' NR=='$TASK' { print $1 ; }' $arrayfile)
#chrom=1 # test on crom 1.

gt=all_HD_samples_combined_idfix_parentsupdate_crossvalexclude_me_hwe.vcf.gz
# ref=~/Projects/impute_to_Sequence/Affy_reference/vcf/singel_chrom_phased/affy50K_phased_ne200_chrom_${chrom}.vcf.gz
# excludesamples=~/Projects/impute_to_Sequence/Affy_reference/25k_on50K_2_exclude_imputing.txt

module load java

java  -jar $beagle41 \
  	gt=$gt \
	nthreads=8 \
	out=phased/all_HD_samples_combined_phased_chrom_${chrom} \
	ne=200 \
	chrom=$chrom \
	niterations=10 #\
	#lowmem=true

#ref=$ref \
#excludesamples=$excludesamples \

