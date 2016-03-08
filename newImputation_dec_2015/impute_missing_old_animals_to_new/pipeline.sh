#!/bin/bash

## First exract the sampels from old HD that I want to impute to new HD, missing in new HD-set.
#plink --bfile ~/Projects/Fatty_acids_bovine/GWAS/Data/genotypes/HD_imputed_FA_genotypes_asreml_maf0.01 \
	#--recode vcf-iid --cow \
	#--out old_to_be_imputed \
	#--keep old_HD_animals_to_impute_to_newHD_2016.txt

#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p cigene,hugemem
#SBATCH -J beagle
#SBATCH --output=slurm/impute50k_777k_job%A_chr_%a.log
##SBATCH --mem=25000
##SBATCH --mem-per-cpu=6000

## Usage: sbatch -a 1-29 beagle_array.sh arrayfile

set -o nounset   # Prevent unset variables from been used.
set -o errexit   # Exit if error occurs

beagle41=/mnt/users/tikn/bioinf_tools/beagle4/beagle.22Feb16.8ef.jar #beagle 4.1 feb22 16
conform=/mnt/users/tikn/bioinf_tools/beagle_utils/conform-gt.r1174.jar

#TASK=$SLURM_ARRAY_TASK_ID
#arrayfile=$1
#chrom=$(awk ' NR=='$TASK' { print $1 ; }' $arrayfile)
chrom=$1 # test on crom 1.

ref=~/Projects/impute_to_Sequence/newImputation_dec_2015/777k_ref/singel_chroms/all_HD_samples_combined_phased_0.5missexclude_chrom_${chrom}.vcf.gz
gt=old_to_be_imputed.vcf
#excludesamples=

module load java

java -jar $conform \
        gt=$gt \
        ref=$ref \
        out=conform_gt/old_HD_conform_new_777k_chrom${chrom} \
        chrom=$chrom \
        match=POS

#java -jar $beagle41 \
#        gt=$gt \
#        ref=$ref \
#        nthreads=8 \
#        out=singel_chrom/affy50k_imputed777k_chrom_${chrom} \
#        ne=200 \
#        chrom=$chrom \
#        niterations=10 \
#	gprobs=true #\
#
