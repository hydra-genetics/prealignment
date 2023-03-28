# Softwares used in the prealignment module

## Choice of trimmer software
Choice of trimmer software is specified in the 'config.yaml' file:
```yaml
trimmer_software: "fastp_pe"
```

## [Fastp](https://github.com/OpenGene/fastp)
Trim `.fastq` files by removing adapter sequences and other unwanted sequences. Adapter sequences are specified in `units.tsv` under the adapter column.

| Rule settings | Description |
|-|-|
| Rule | [fastp_pe](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/fastp.smk) |
| Input | Untrimmed `.fastq` files from the same sample |
| Output | Trimmed `.fastq` files from the same sample |
|| html QC report |
|_ _| json QC report |
| Container | [docker://hydragenetics/fastp:{version}](https://hub.docker.com/r/hydragenetics/fastp) |
| [Resources](https://hydra-genetics.readthedocs.io/en/read_the_docs/config/) | Recommendation: Use multiple threads for decreased run time. <br /> **Note** If multiple threads is used it is also best to increase memory <br /> **Note** If multiple threads is used the read order of the fastq files will differ between runs |

<br />

| Software settings | Parameter | Value |
|-|-|-|
| Parameters | extra | Additional parameters to the program |

## Fastq merging
Merge `.fastq` files generated for example on different lanes by simply concatenating them using cat  

| Setting | Description |
|-|-|
| Rule | [merged](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/merged.smk) |
| Container | [docker://hydragenetics/common:{version}](https://hub.docker.com/r/hydragenetics/common) |
| Input | Several `.fastq` files from the same sample |
| Output | Merged `.fastq` file |

## [Sortmerna](https://github.com/biocore/sortmerna)
Filter out ribosomal RNA (rRNA) from RNA data  

| Setting | Description |
|-|-|
| Rule | [sortmerna](https://github.com/hydra-genetics/prealignment/blob/develop/workflow/rules/sortmerna.smk) |
| Input | Unfiltered merged `.fastq` files from the same sample |
| | Fasta reference genome |
|_ _| Sortmera index directory |
| Output | rRNA filtered merged `.fastq` file |
| | Fastq with reads that align to ribosomal rna |
| | workdir kvd with key-value datastore for alignment results |
| | workdir readb with temporary read info |
|_ _| Sortmeras ribosomal log file |
| [Resources](https://hydra-genetics.readthedocs.io/en/read_the_docs/config/) | Recommendation: Use multiple threads for decreased run time. <br /> **Note** If multiple threads is used it is also best to increase memory |

<br />
