# Hydra-genetics prealignment module

The prealignment module consists of alignment pre-processing steps, such as trimming and merging of `.fastq`-files
as well as filtering out rRNA sequences from RNA reads. We **strongly** recommend trimming `.fastq`-files
prior to alignment. For rRNA filtering, SortMeRNA can additionally be used.

## Enable trimming

Trimmer software rule must be specified in your `config.yaml` file. Example:  
```yaml
trimmer_software: "fastp_pe"
```
Can be set to `None` for no trimming and only merging.

## [Input data](xxx)

Input data should be specified via the files `samples.tsv` and `units.tsv`. See [input data](xxx) for
further information on how to generate these automatically from `.fastq` files.
