module load vcftools

#vcf_affy=/mnt/users/tikn/Projects/impute_to_Sequence/54k_affy_genotypes/vcf-files/imputed/chrom_1_50_perc_ref.vcf.gz
vcf_affy_all=/mnt/users/tikn/Projects/impute_to_Sequence/54k_affy_genotypes/vcf-files/affygenos_chr_1_conform_unmask.vcf.gz
hdvcf=~tikn/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/phased/chrom_1.vcf.gz
#outfile=50_perc_removed
outfile=compare_54k_777k
#eval_script=diff-discordance-matrix
#eval_script=diff-site-discordance
eval_script=diff-indv-discordance
#eval_script=freq2

## discordance
#srun \
#vcftools --gzvcf ${vcf_affy} \
#--gzdiff $hdvcf \
#--out $outfile \
#--${eval_script}

# discordance 54k mot HD
srun \
vcftools \
--gzdiff ${vcf_affy_all} \
--gzvcf ${hdvcf} \
--out $outfile \
--${eval_script} \
--keep common_animals_54k_777k.txt \
--positions common_sites_54k_777k.txt


# allele freq HD-ref used. 
#srun \
#vcftools --gzvcf ~/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/phased/chrom_1.vcf.gz \
#--out $outfile \
#--${eval_script} \
#--remove ~/Projects/impute_to_Sequence/keep777_remove_54k_animals.txt
