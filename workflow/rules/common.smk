# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


import pandas as pandas
from snakemake.utils import validate
from snakemake.utils import min_version

from hydra_genetics.utils.units import *
from hydra_genetics.utils.samples import *

min_version("6.8.0")

### Set and validate config file


configfile: "config.yaml"


validate(config, schema="../schemas/config.schema.yaml")


### Read and validate samples file

samples = pandas.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = pandas.read_table(config["units"], dtype=str).set_index(["sample", "type", "run", "lane"], drop=False)
validate(units, schema="../schemas/units.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),
    unit="N|T|R",
    read="fastq[1|2]",


def compile_output_list(wildcards: snakemake.io.Wildcards):
    return [
        "prealignment/merged/" + sample + "_" + t + "_" + read + ".fastq.gz"
        for sample in get_samples(samples)
        for read in ["fastq1", "fastq2"]
        for t in get_unit_types(units, sample)
    ]
