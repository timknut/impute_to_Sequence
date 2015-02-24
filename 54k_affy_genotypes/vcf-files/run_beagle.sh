#!/bin/bash

#SBATCH -n 10            # -n cores
#SBATCH -N 1            # -n Nodes
#SBATCH -J beagle4phase5it # sensible name for the job
#SBATCH --output=slurm/beagle_%j.log

set -o nounset   # Prevent unset variables from been used.
set -o errexit   # Exit if error occurs

#chrom=$1
chrom=1
beagle4=~/bioinf_tools/beagle.r1398.jar

time java -Xmx10000m -jar $beagle4 \
	gt=affygenos_chrom_1_50_percent_removed.vcf.gz \
	out=imputed/chrom_${chrom}_50_perc_test_new_ped \
	chrom=$chrom \
	nthreads=10 \
	ref=/mnt/users/tikn/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/impute_evaluation/50_perc_removed/chrom_1_50_percent_removed.vcf.gz \
	ped=/mnt/users/tikn/Projects/impute_to_Sequence/pedigrees_Geno/fam_w_moms.txt 
	#ped=~/Projects/impute_to_Sequence/54k_affy_genotypes/ped_files/affygenos-jan2015_id-edit__hwe-maf-filter.fam
#	excludesamples=exclude_animals.txt
#	phase-its=10
#	impute-its=10
