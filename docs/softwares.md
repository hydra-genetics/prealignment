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

## [Dorado trim](https://github.com/nanoporetech/dorado)
Adapter and primer trimming of unaligned ONT reads with `dorado trim`. The unaligned BAM from the `bam` column of
`units.tsv` is trimmed and written as FASTQ, which is then passed on to Filtlong.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__dorado__dorado_trim#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__dorado__dorado_trim#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__dorado_trim#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__dorado_trim#

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
