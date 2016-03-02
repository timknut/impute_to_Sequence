#!/usr/bin/env Rscript
#args = commandArgs(trailingOnly=TRUE)

lib_loc <- "/mnt/users/tikn/R/x86_64-pc-linux-gnu-library/3.2"
suppressPackageStartupMessages(library(dplyr, lib.loc = lib_loc))
library(argparser, quietly=TRUE, lib.loc = lib_loc)

main_function <- function(gt, ref){
# Load pkgs and set lib.loc -----------------------------------------------
library(readr, lib.loc = lib_loc)
library(RLinuxModules, lib.loc = lib_loc)
moduleInit()
module("load samtools")

gt <- gt
ref <- ref

# temp files --------------------------------------------------------------
gt_temp_samples <- tempfile()
gt_temp_markers <- tempfile()
ref_temp_samples <- tempfile()
ref_temp_markers <- tempfile()

# bcftools ----------------------------------------------------------------
bcftools <-
  sprintf(
    "bcftools query -f '%%CHROM\\_%%POS\t%%ID\n' %s > %s
    bcftools query -f '%%CHROM\\_%%POS\t%%ID\n' %s > %s
    bcftools query -l %s > %s
    bcftools query -l %s > %s
    ",
    gt,
    gt_temp_markers,
    ref,
    ref_temp_markers,
    gt,
    gt_temp_samples,
    ref,
    ref_temp_samples
  )
# system(sprintf("sh bcftools.sh %s %s",gt , ref))
system(bcftools)

# Read sample and marker data ---------------------------------------------
gt_samples <-
  read_csv(gt_temp_samples, col_types = "c", col_names = F)
gt_markers <-
  read_delim(
    file = gt_temp_markers,
    delim = "\t",
    col_types = "cc",
    col_names = F
  )

ref_samples <-
  read_delim(
    file = ref_temp_samples,
    delim = "\t",
    col_types = "c",
    col_names = F
  )
ref_markers <-
  read_delim(
    file = ref_temp_markers,
    delim = "\t",
    col_types = "cc",
    col_names = F
  )


# Do intersects and diffs -------------------------------------------------
common_samples_gt_ref <- intersect(gt_samples$X1, ref_samples$X1)
different_markers_gt_ref <- setdiff(gt_markers$X2, ref_markers$X2)
different_markers_gt_ref <-
  filter(gt_markers, gt_markers$X2 %in% different_markers_gt_ref)

# head(common_samples_gt_ref)
# head(different_markers_gt_ref)
# cat("All ok\n")


# Now write the files and run the imputation ------------------------------
cat(common_samples_gt_ref, file = "common_gt_ref_samples_2_exclude.txt", sep = "\n")
write_csv(different_markers_gt_ref[2],
          path = "exclusive_gt_ref_markers_2_exclude.txt",
          col_names = F)

# Delete temp files -------------------------------------------------------
remove_res <- file.remove(gt_temp_markers,
            gt_temp_samples,
            ref_temp_markers,
            ref_temp_samples)
if (any(remove_res)) {
  message("temp files deleted. Program finished")
}
}

# gt <-
#   "~tikn/Projects/impute_to_Sequence/newImputation_dec_2015/raw_data/54k/vcf/54k_updateids_updateparents_hwe.vcf.gz"
#  ref <-
#    "~tikn/Projects/impute_to_Sequence/newImputation_dec_2015/raw_data/vcf/all_HD_samples_combined_idfix_parentsupdate_crossvalexclude_me_hwe.vcf.gz"

# Create a parser and add arguments, and parse the command line arguments
# All steps are chained together, courtesy of magrittr
p <- arg_parser("Create intersect and diff files before imputation") %>% 
  add_argument("--gt", help="genotype VCF to impute", type="character") %>% 
  add_argument("--ref", help="reference VCF to imute into", type="character")

# Parse the command line arguments
# This step is kept separate to simply error message
argv <- parse_args(p)
# Do work based on the passed arguments

gt <- argv$gt
ref <- argv$ref

if(!is.na(gt) && !is.na(ref)){
  if(file.exists(gt) && file.exists(ref)){
    main_function(gt = gt, ref = ref)
  } else {
    message("ERROR!\nCheck file paths.\n")
  }
} else {
  message("No arguments! run: ./set_diffs_gt_ref.R -h for help")
}

