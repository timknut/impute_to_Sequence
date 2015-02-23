conform=~/bioinf_tools/conform-gt.r1174.jar
#ref=~/Projects/impute_to_Sequence/vcf_HDgenos/phased/chrom_1.vcf.gz
gt=~/Projects/impute_to_Sequence/54k_affy_genotypes/vcf-files/affygenos_jan2015_common_777k_removed.vcf

for i in $(seq 1 29); do \
	java -jar $conform \
	ref=/mnt/users/tikn/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/phased/chrom_${i}.vcf.gz \
	gt=${gt} \
	chrom=$i \
	match=POS \
	out=conform_vcfs/affygenos_chr_${i}_conform;
done
