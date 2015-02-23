suppressPackageStartupMessages(require(dplyr))
require(ggplot2)

## Data setup
setwd("~/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/impute_evaluation")
sites_50_perc_removed.diff <- 
	read.delim(
		"~/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/impute_evaluation/50_perc_removed.diff.sites", 
				  stringsAsFactors=FALSE) %>% tbl_df
eval_50.diff_matrix <- read.delim(
	"~/Projects/impute_to_Sequence/HDgenos/vcf_HDgenos/impute_evaluation/50_perc_removed.diff.discordance_matrix",
	stringsAsFactors=FALSE)
freqs <- read.table("50_perc_removed.frq", header = F, skip = 1, 
			  col.names = c("chrom", "pos", "n_alleles", "vetikke", "major", "maf"))

#' ## Summary
summary(select(sites_50_perc_removed.diff, 1,2,6,7))
qplot(POS/1e6, DISCORDANCE, data = sites_50_perc_removed.diff)

#' ### merge with maf and plot > 50 % feil.

inner_join(sites_50_perc_removed.diff, freqs, by = c("POS" = "pos")) %>%
	tbl_df %>%
	select(1,2,N_DISCORD, DISCORDANCE, maf) %>%
	filter(DISCORDANCE > 0.5) %>% 
	#select(-c(3,4)) %>%
	knitr::kable()

#' ### Plotte denne sammenhengen
	inner_join(sites_50_perc_removed.diff, freqs, by = c("POS" = "pos")) %>%
	tbl_df %>%
	select(1,2,N_DISCORD, DISCORDANCE, maf) %>%
	ggplot(aes(maf, (DISCORDANCE))) + geom_point() + geom_smooth()

