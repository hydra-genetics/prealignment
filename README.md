# :snake: hydra-genetics/prealignment

#### Snakemake module containing processing steps that should be performed before sequence alignment

![Lint](https://github.com/hydra-genetics/prealignment/actions/workflows/lint.yaml/badge.svg?branch=develop)
![Snakefmt](https://github.com/hydra-genetics/prealignment/actions/workflows/snakefmt.yaml/badge.svg?branch=develop)
![snakemake dry run](https://github.com/hydra-genetics/prealignment/actions/workflows/snakemake-dry-run.yaml/badge.svg?branch=develop)
![integration test](https://github.com/hydra-genetics/prealignment/actions/workflows/integration.yaml/badge.svg?branch=develop)

[![License: GPL-3](https://img.shields.io/badge/License-GPL3-yellow.svg)](https://opensource.org/licenses/gpl-3.0.html)

## :speech_balloon: Introduction

The module consists of alignment pre-processing steps, such as trimming and merging of `.fastq`-files.
We strongly recommend trimming `.fastq`-files prior to alignment. To enable trimming the
`trimmer_software`-stanza in the `config.yaml` may be set to the name of the trimming rule, e.g.
`fastp_pe`, or `None` if trimming should be omitted. Input data should be specified via `samples.tsv`
and `units.tsv`.

## :heavy_exclamation_mark: Dependencies

In order to use this module, the following dependencies are required:

[![hydra-genetics](https://img.shields.io/badge/hydragenetics-v0.5.0-blue)](https://github.com/hydra-genetics/)
[![pandas](https://img.shields.io/badge/pandas-1.3.1-blue)](https://pandas.pydata.org/)
[![python](https://img.shields.io/badge/python-3.8-blue)](https://www.python.org/)
[![snakemake](https://img.shields.io/badge/snakemake-6.10.0-blue)](https://snakemake.readthedocs.io/en/stable/)
[![singularity](https://img.shields.io/badge/singularity-3.0.0-blue)](https://sylabs.io/docs/)

## :school_satchel: Preparations

### Sample data

1. Add all sample ids to [`samples.tsv`](https://github.com/hydra-genetics/prealignment/blob/develop/config/samples.tsv)
in the column `sample` and the tumor cell content to `tumor_content`.
2. Add all unit data information to [`units.tsv`](https://github.com/hydra-genetics/prealignment/blob/develop/config/units.tsv).
Each row represents a `fastq` file pair with corresponding forward and reverse reads. Indicate
the sample id, sample type (**T**umor, **N**ormal, **R**NA), platform, run id and lane number,
barcode, path to forward and reverse reads and adapter sequence.

## :white_check_mark: Testing

The workflow repository contains a small test dataset `.tests/integration` which can be run like so:

```bash
$ cd .tests/integration
$ snakemake -s ../../Snakefile -j1 --use-singularity
```

## :rocket: Usage

To use this module in your workflow, follow the description in the
[snakemake docs](https://snakemake.readthedocs.io/en/stable/snakefiles/modularization.html#modules).
Add the module to your `Snakefile` like so:

```bash
module prealignment:
    snakefile:
        github(
            "hydra-genetics/prealignment",
            path="workflow/Snakefile",
            tag="1.0.0",
        )
    config:
        config


use rule * from prealignment as prealignment_*
```

### Output files

The following output files should be targeted:

- `prealignment/merged/{sample}_{type}_fastq1.fastq.gz`: Merged and possibly trimmed foward reads
- `prealignment/merged/{sample}_{type}_fastq2.fastq.gz`: Merged and possibly trimmed reverse reads

## :judge: Rule Graph

### Trim and merge fastq

![rule_graph](images/prealignment_fastp_merge.svg)

### Only merge fastq

![rule_graph](images/prealignment_merge.svg)
