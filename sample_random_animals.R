require(dplyr)
common_animals_54_and_777k <- read.table("~/Projects/impute_to_Sequence/exclude_animals_54k.txt", 
											 quote="\"", stringsAsFactors=FALSE)
to_remove_from_777 <- sample_frac(common_animals_54_and_777k, 0.5)

animals_keep_54k <-  setdiff(common_animals_54_and_777k, to_remove_from_777)


## write lists to files
write(file = "keep54_remove_777k_animals.txt", ncolumns = 1, animals_keep_54k$V1)
write(file = "keep777_remove_54k_animals.txt", ncolumns = 1, to_remove_from_777$V1)

