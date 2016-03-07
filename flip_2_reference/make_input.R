## Get into 1000 Bulls format for getSNP_flanks. 
# Chr6    88738458        CT/C
# Chr6    88738692        T/TA
# Chr6    88739045        A/G
setwd("~/Projects/impute_to_Sequence/flip_2_reference")

library(RLinuxModules)
moduleInit()
module("load anaconda")
module("load slurm")

convert_2_getflank <- function (df) {
  transmute(df, 
          Chr = paste("Chr", quote(Chr), sep = ""), 
          bp = MapInfo, 
          snp = str_replace_all(SNP, "\\[|\\]", ""),
          flank_seq_manifes_Top = TopGenomicSeq)
}
#dna_lookup <- c(A = 'T', C = 'G', G = 'C', T = 'A', N = 'N')

dna_rev_comp <- function(x){
  dna <- toupper(chartr("ACGTacgt", "TGCAtgca", x))
  stringi::stri_reverse(dna)
}

# dna_rev_comp(c("AACGTGG", "agt"))


hd_mainfest_getflank_format <- read_csv("~/Projects/impute_to_Sequence/HDgenos/illumina_manifest/bovinehd-manifest-b.csv", 
                        skip = 7, col_types = paste(rep("c", 21), collapse = ""))# %>% 
  convert_2_getflank() %>% 
  filter(str_detect(Chr, "Chr[1-9]{1}|Chr[12][1-9]")) ## Remove non-autosomes

# test_getflank <- select(hd_mainfest, Chr, MapInfo, SNP) %>% head()

hd_getflank_infile <- "hd_manifest_getflank.txt"
#  write_tsv(hd_mainfest_getflank_format, hd_getflank_infile, col_names = F)

hd_getflank_outfile <- "hd_manifest_getflank_result.txt"
# cat(sprintf("#!/bin/bash
#       python ~/bioinf_tools/getFlankingSeq_mod.py \\
#       umd_3_1_reference_1000_bull_genomes.fa \\
#       %s 20 \\
#       %s", hd_getflank_infile, hd_getflank_outfile), file = "getflank.sh")
# 
# system("sbatch getflank.sh")

getflank_res <- read_delim(hd_getflank_outfile,delim = "\t", 
                               col_names = c("chr_bp_getflank", "flankseq_getflank", "ref_base"))

hdmanifest_getflank_merge <- bind_cols(hd_mainfest_getflank_format, getflank_res) %>% 
  mutate(ref_flank = plyr::ldply(str_split(flankseq_getflank, "\\["))$V1) #%>% 
  select(-flankseq_getflank)

## Clean up mem
rm(hd_mainfest_getflank_format, getflank_res)
gc()

## Add complement of chip_flank sequence.
system.time(hdmanifest_getflank_merge$ref_flank_complement <- dna_rev_comp(hdmanifest_getflank_merge$ref_flank))
#user  system elapsed 
#3.913   0.006   3.918 


## Now set up two str_detect ifelse tests. 
df_res_fliptest <- mutate(hdmanifest_getflank_merge, 
                          flip = ifelse(str_detect(flank_seq_manifes_Top, ref_flank), 0, 1),
                          flip_revcomp = ifelse(str_detect(flank_seq_manifes_Top, ref_flank_complement), 1, 0),
                          flip_final = ifelse(flip + flip_revcomp == 2, 'YES', 
                                              ifelse(flip + flip_revcomp == 0, 'NO', "Unknown"))
)


## Read allele info from Bovine HD. 
bovineHD_allele_info <- read_tsv(
  "/mnt/users/tikn/Projects/impute_to_Sequence/flip_2_reference/all_swe_fin_nor_HD_samples_combined_phase_chr1_29.vcf_alleles.txt",
  col_names = c("chr_pos_HD", "alleles_HD"))

df_res_fliptest <- mutate(df_res_fliptest, 
       chr_pos2 = str_replace(chr_bp_getflank, "Chr", "")) %>% 
  inner_join(bovineHD_allele_info, by = c("chr_pos2" = "chr_pos_HD")) %>% 
  select(3:ncol(x = .))



# debug -------------------------------------------------------------------
debug_1 <- mutate(hdmanifest_getflank_merge, flip = ifelse(str_detect(flank_seq, ref_flank), "no", "yes")) %>% head 
debug_2 <- debug_1 %>% 
  mutate(fliptest_revcomp = dna_rev_comp(ref_flank))# %>% 
  select(1:4, ref_flank, flip, ref_base, fliptest_revcomp)


  mutate(fliptest_revcomp = ifelse(str_detect(flank_seq, dna_rev_comp(ref_flank)), "no", "yes")) %>% 
  select(1:4, ref_flank, flip, ref_base, fliptest_revcomp)




## Works for small example. 
## Now add sanity check for reverse complement.


## Implement with plink flip, and a1 allele from list. Convert to VCF.