# impute_to_Sequence
Code base for the Bovine "impute to sequence" project at Cigene.

## Div. scripts
`newImputation_dec_2015/prepare_for_phasing/set_diffs_target_ref.R`
**Common samples: **
This script will print common target/ref samples that needs to be excluded from the target VCF before imputing with Beagle.
**Exclusive target markers:**
The scripts will list markers exclusive for the target VCF. Give this list as an excludemarkers= arg to beagle. 

**usage:**
```sh
/mnt/users/tikn/bin/set_diffs_target_ref.R [--help] [--opts OPTS] [--target TARGET] [--ref REF] 

Create intersect and diff files before imputation


flags:
  -h, --help                    show this help message and exit

  optional arguments:
    -x, --opts OPTS                       RDS file containing argument values
    -t, --target TARGET                   target VCF to impute into REF
    -r, --ref REF                 	  reference VCF to impute into
```
