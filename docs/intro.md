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

## [Module input files](https://hydra-genetics.readthedocs.io/en/read_the_docs/create_sample_files/)
Fastq files are the main input data of the prealignment module. These should be specified in `units.tsv` as well as sequencing meta data. See [input data](https://hydra-genetics.readthedocs.io/en/read_the_docs/create_sample_files/) for further information on how to generate these automatically from `.fastq` files.

Example `samples.tsv` with all required columns:

| sample |
|-|
| sample1 |

<br />
Example `units.tsv` with all required columns:

| sample | type | platform | machine | flowcell | lane | barcode | fastq1 | fastq2 | adapter |
|-|-|-|-|-|-|-|-|-|-|
| sample1 | N | NextSeq | NDX550220 | HKTG2BGXG | L001 | ACG+ACG | sample1_R1.fastq.gz | sample1_R2.fastq.gz | AGAT,ACAT |

<br />


## Module output files
Trimmed and merged fastq-files are the main output files of the prealignment module.

* `prealignment/merged/{sample}_{type}_{read}.fastq.gz`

## Module workflow graph

### Trimming and merging
![DAG1](https://github.com/hydra-genetics/prealignment/raw/develop/images/prealignment_fastp_merge.svg)

### Only trimming
![DAG2](https://github.com/hydra-genetics/prealignment/raw/develop/images/prealignment_merge.svg)
