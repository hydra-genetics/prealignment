# Softwares used in the prealignment module

## [Fastp](https://github.com/OpenGene/fastp) (rule: [fastp_pe](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/fastp.smk))
Trim `.fastq` files by removing adapter sequences and other unwanted sequences. Adapter sequences are specified in `units.tsv` under the adapter column.

### Rule content

#### Source
#SNAKEMAKE_RULE_SOURCE__fastp__fastp_pe#

#### Parameters

#SNAKEMAKE_RULE_TABLE__fastp__fastp_pe#

### Software settings

#CONFIGSCHEMA__fastp_pe#

### Resources settings

#RESOURCESSCHEMA__merged#


## Fastq merging (rule: [merged](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/merged.smk))
Merge `.fastq` files generated for example on different lanes by simply concatenating them using cat  

| Rule parameters | Key | Value | Description |
|-|-|-|-|
| Input | fastq | [merged_input](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/common.smk) function | Several `.fastq` files from the same sample |
| Output | fastq | `prealignment/merged/{sample}_{type}_{read}.fastq.gz` | Merged `.fastq` file |
| Container | container | [docker://hydragenetics/common:{version}](https://hub.docker.com/r/hydragenetics/common) | General hydra-genetics docker container |

### Software settings

#CONFIGSCHEMA__merged#

### Resources settings

#RESOURCESSCHEMA__merged#


## [Sortmerna](https://github.com/biocore/sortmerna) (rule: [sortmerna](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/sortmerna.smk))
Filter out ribosomal RNA (rRNA) from RNA data  

| Rule parameters | Key | Value | Description |
|-|-|-|-|
| Input | fq1 | `prealignment/merged/{sample}_{type}_fastq1.fastq.gz` | Unfiltered merged `.fastq` files from the same sample |
| | fq2 | `prealignment/merged/{sample}_{type}_fastq1.fastq.gz` |_ _|
| | ref | `config.yaml` | Fasta reference genome |
|_ _| idx | `config.yaml` | Sortmera index directory |
| Output | other | `prealignment/sortmerna/{sample}_{type}.fq.gz` | rRNA filtered merged `.fastq` file |
| | align | `prealignment/sortmerna/{sample}_{type}.rrna.fq.gz` |  Fastq with reads that align to ribosomal rna |
| | kvdb | `prealignment/sortmerna/{sample}_{type}/kvdb` |  workdir kvd with key-value datastore for alignment results |
| | out | `prealignment/sortmerna/{sample}_{type}.rrna.log` |  workdir readb with temporary read info |
|_ _| readb | `prealignment/sortmerna/{sample}_{type}/readb` |  Sortmeras ribosomal log file |

<br />

### Software settings

#CONFIGSCHEMA__sortmerna#

### Resources settings

#RESOURCESSCHEMA__sortmerna#
