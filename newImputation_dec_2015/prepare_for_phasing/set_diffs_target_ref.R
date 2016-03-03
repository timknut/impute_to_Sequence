#!/local/genome/packages/R/3.2.3/bin/Rscript

lib_loc <- "/mnt/users/tikn/R/x86_64-pc-linux-gnu-library/3.2"
suppressPackageStartupMessages(library(dplyr, lib.loc = lib_loc))
library(argparser, quietly = TRUE, lib.loc = lib_loc)

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
different_markers_gt_ref <- setdiff(gt_markers$X1, ref_markers$X1)
different_markers_gt_ref <-
  filter(gt_markers, gt_markers$X1 %in% different_markers_gt_ref)

# Now write the files and run the imputation ------------------------------
file1 <- "common_samples_2_exclude.txt"
file2 <- "exclusive_target_markers_2_exclude.txt"
cat(common_samples_gt_ref, file = file1, sep = "\n")
# sub _ with : and write to file
cat(gsub(x = different_markers_gt_ref$X1, "_", ":"), sep = "\n", file = file2)

# Delete temp files -------------------------------------------------------
remove_res <- file.remove(gt_temp_markers,
            gt_temp_samples,
            ref_temp_markers,
            ref_temp_samples)
if (any(remove_res)) {
  message(sprintf(
"temp files deleted. Program finished.
See %s and %s", file1, file2))
}
}

# gt <-
#   "~tikn/Projects/impute_to_Sequence/newImputation_dec_2015/raw_data/54k/vcf/54k_updateids_updateparents_hwe.vcf.gz"
#  ref <-
#    "~tikn/Projects/impute_to_Sequence/newImputation_dec_2015/raw_data/vcf/all_HD_samples_combined_idfix_parentsupdate_crossvalexclude_me_hwe.vcf.gz"

# Create a parser and add arguments, and parse the command line arguments
# All steps are chained together, courtesy of magrittr
p <- arg_parser("Create intersect and diff files before imputation") %>% 
  add_argument("--target", help="target VCF to impute into REF", type="character") %>% 
  add_argument("--ref", help="reference VCF to impute into", type="character")

# Parse the command line arguments
# This step is kept separate to simply error message
argv <- parse_args(p)
# Do work based on the passed arguments

gt <- argv$target
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

