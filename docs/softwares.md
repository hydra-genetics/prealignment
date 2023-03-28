# Softwares used in the prealignment module

## [Fastp](https://github.com/OpenGene/fastp) (rule: [fastp_pe](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/fastp.smk))
Trim `.fastq` files by removing adapter sequences and other unwanted sequences. Adapter sequences are specified in `units.tsv` under the adapter column.

| Rule parameters | Key | Value | Description |
|-|-|-|-|
| Input | sample | Fastq files specified in `units.tsv` obatined by [get_fastq_file](https://github.com/hydra-genetics/hydra-genetics/blob/develop/hydra_genetics/utils/units.py) | Untrimmed `.fastq` files from the same sample |
| Output | trimmed | `prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastq1.fastq.gz` | Trimmed `.fastq` files from the same sample |
| |_ _| `prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastq2.fastq.gz` |_ _|
| | html | `prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastp.html` | html QC report |
|_ _| json | `prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastp.html` | json QC report |
| Container | container | [docker://hydragenetics/fastp:{version}](https://hub.docker.com/r/hydragenetics/fastp) | fastp docker container |

<br />

| Software settings | Parameter | Value |
|-|-|-|
| Parameters | extra | Additional parameters to the program |
| [Resources](https://hydra-genetics.readthedocs.io/en/read_the_docs/config/) | threads | Recommendation: Use multiple threads for decreased run time. <br /> **Note** If multiple threads is used it is also best to increase memory <br /> **Note** If multiple threads is used the read order of the fastq files will differ between runs |


## Fastq merging (rule: [merged](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/merged.smk))
Merge `.fastq` files generated for example on different lanes by simply concatenating them using cat  

| Rule parameters | Key | Value | Description |
|-|-|-|-|
| Input | fastq | [merged_input](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/common.smk) function | Several `.fastq` files from the same sample |
| Output | fastq | `prealignment/merged/{sample}_{type}_{read}.fastq.gz` | Merged `.fastq` file |
| Container | container | [docker://hydragenetics/common:{version}](https://hub.docker.com/r/hydragenetics/common) | General hydra-genetics docker container |

## [Sortmerna](https://github.com/biocore/sortmerna) (rule: [sortmerna](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/sortmerna.smk))
Filter out ribosomal RNA (rRNA) from RNA data  

| Rule parameters | Key | Value | Description |
|-|-|-|-|
| Input | fq1 | `prealignment/merged/{sample}_{type}_fastq1.fastq.gz` | Unfiltered merged `.fastq` files from the same sample |
| | fq2 | `prealignment/merged/{sample}_{type}_fastq1.fastq.gz` |_ _|
| | ref | `config.yaml`: sortmera: fasta:{file} | Fasta reference genome |
|_ _| idx | `config.yaml`: sortmera: idx:{directory} | Sortmera index directory |
| Output | other | `prealignment/sortmerna/{sample}_{type}.fq.gz` | rRNA filtered merged `.fastq` file |
| | align | `prealignment/sortmerna/{sample}_{type}.rrna.fq.gz` |  Fastq with reads that align to ribosomal rna |
| | kvdb | `prealignment/sortmerna/{sample}_{type}/kvdb` |  workdir kvd with key-value datastore for alignment results |
| | out | `prealignment/sortmerna/{sample}_{type}.rrna.log` |  workdir readb with temporary read info |
|_ _| readb | `prealignment/sortmerna/{sample}_{type}/readb` |  Sortmeras ribosomal log file |

<br />

| Software settings | Parameter | Value |
|-|-|-|
| Parameters | extra | Additional parameters to the program |
| [Resources](https://hydra-genetics.readthedocs.io/en/read_the_docs/config/) | threads | Recommendation: Use multiple threads for decreased run time. <br /> **Note** If multiple threads is used it is also best to increase memory |

<br />
