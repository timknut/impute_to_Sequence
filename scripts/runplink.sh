#!/bin/bash
#SBATCH -n 5            	# 1 core
#SBATCH -N 1            	# 1 core
#SBATCH -J plink	# sensible name for the job
#SBATCH --output=slurm/plink_vcf_convert_%j.log
## Below you can put your scripts
plink --cow  --bfile HDgenos --alleleACGT --nonfounders --recode vcf --maf 0.01 --hwe midp 1e-20 --out ./vcf_HDgenos/HDgenos
#plink --cow  --bfile HDgenos --missing --out ./vcf/btaHD
