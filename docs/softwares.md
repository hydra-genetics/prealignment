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

## [Samtools](https://www.htslib.org/doc/samtools-fasta.html)
Conversion of unaligned ONT bam files (the `bam` column of `units.tsv`) to fastq with `samtools fastq`,
followed by gzip compression of the fastq file. The compressed fastq file is the input to Filtlong.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__samtools__samtools_fastq#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__samtools__samtools_fastq#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__samtools_fastq#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__samtools_fastq#

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__samtools__samtools_compress_fastq#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__samtools__samtools_compress_fastq#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__samtools_compress_fastq#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__samtools_compress_fastq#

---

## [Filtlong](https://github.com/rrwick/Filtlong)
Quality filtering of long reads (e.g. ONT). Reads outside the `min_length`/`max_length` range are discarded,
and the remaining reads are filtered on mean quality and the percentage of best bases to keep (set via `extra`).

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__filtlong__filtlong#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__filtlong__filtlong#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__filtlong#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__filtlong#

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

## [seqtk_downsample](https://github.com/lh3/seqtk)
Downsamples fastq files to the specified number of reads

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__seqtk__seqtk_subsample#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__seqtk__seqtk_subsample#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__seqtk_subsample#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__seqtk_subsample#
