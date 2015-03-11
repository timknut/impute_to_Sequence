#!/bin/bash

#SBATCH -n 4            # -n cores
#SBATCH -N 1            # -n Nodes
#SBATCH -J Impute_all # sensible name for the job
#SBATCH --output=slurm/beagle_%j.log

set -o nounset   # Prevent unset variables from been used.
set -o errexit   # Exit if error occurs

chrom=$1
#chrom=1
beagle4=~/bioinf_tools/beagle.r1398.jar
gt=/mnt/users/tikn/Projects/impute_to_Sequence/54k_affy_genotypes/vcf-files/conform_vcfs/affygenos_chr_${chrom}_conform.vcf.gz
out=/mnt/users/tikn/Projects/impute_to_Sequence/54k_affy_genotypes/vcf-files/imputed/affygenos_imputed_chrom_${chrom}
ref=/mnt/users/tikn/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/phased/chrom_${chrom}.vcf.gz

time java -Xmx10000m -jar $beagle4 \
	gt=${gt} \
	out=${out} \
	chrom=$chrom \
	nthreads=4 \
	ref=${ref} \
	ped=/mnt/users/tikn/Projects/impute_to_Sequence/pedigrees_Geno/fam_w_moms.txt \
	phase-its=10 \
	impute-its=10
#	excludesamples=exclude_animals.txt
