# Softwares used in the prealignment module


## [Fastp](https://github.com/OpenGene/fastp)
Trim `.fastq` files by removing adapter sequences and other unwanted sequences. Adapter sequences are specified in `units.tsv` under the adapter column.


### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__fastp__fastp_pe#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__fastp__fastp_pe#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__fastp_pe#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__fastp_pe#


---

## Fastq merging
Merge `.fastq` files generated for example on different lanes by simply concatenating them using cat  

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__merged__merged#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__merged__merged#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__merged#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__merged#

---

## [pbmarkdup](url_to_tool)
Mark or remove duplicates in unmapped CCS PACBIO reads from amplified an library. 

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__pbmarkdup__pbmarkdup#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__pbmarkdup__pbmarkdup#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__pbmarkdup#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__pbmarkdup#

---

## [Sortmerna](https://github.com/biocore/sortmerna)
Filter out ribosomal RNA (rRNA) from RNA data  

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__sortmerna__sortmerna#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__sortmerna__sortmerna#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__sortmerna#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__sortmerna#

---
