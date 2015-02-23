#!/bin/bash

#SBATCH -n 25            # -n cores
#SBATCH -N 1            # -n Nodes
#SBATCH -J beagle4 # sensible name for the job
#SBATCH --output=slurm/beagle_%j.log

set -o nounset   # Prevent unset variables from been used.
set -o errexit   # Exit if error occurs

#chrom=$1
chrom=1
beagle4=~/bioinf_tools/beagle.r1398.jar

time java -Xmx10000m -jar $beagle4 \
	gt=conform_chr1.vcf.gz \
	out=imputed/chrom_${chrom} \
	chrom=$chrom \
	nthreads=25 \
	phase-its=10 \
	ref=../vcf_HDgenos/phased/chrom_1.vcf.gz
#	excludesamples=exclude_animals.txt


#	ped=GSreference_jan2015.fam \
