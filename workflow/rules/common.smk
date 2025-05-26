__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


import pandas
import yaml

from hydra_genetics.utils.resources import load_resources
from hydra_genetics.utils.samples import *
from hydra_genetics.utils.units import *
from snakemake.utils import min_version
from snakemake.utils import validate

min_version("7.8.0")

### Set and validate config file

if not workflow.overwrite_configfiles:
    sys.exit("At least one config file must be passed using --configfile/--configfiles, by command line or a profile!")


validate(config, schema="../schemas/config.schema.yaml")
config = load_resources(config, config["resources"])
validate(config, schema="../schemas/resources.schema.yaml")


### Read and validate samples file

samples = pandas.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = pandas.read_table(config["units"], dtype=str)

if units.platform.iloc[0] in ["PACBIO", "ONT"]:
    units = units.set_index(["sample", "type", "processing_unit", "barcode"], drop=False).sort_index()
else:  # assume that the platform Illumina data with a lane and flowcell columns
    units = units.set_index(["sample", "type", "flowcell", "lane", "barcode"], drop=False).sort_index()
validate(units, schema="../schemas/units.schema.yaml")


### Set wildcard constraints


wildcard_constraints:
    barcode="[A-Z+-]+",
    flowcell="[A-Z0-9-]+",
    lane="L[0-9]+",
    sample="|".join(get_samples(samples)),
    type="N|T|R",
    read="fastq[1|2]",


### Functions

if config.get("trimmer_software", None) == "fastp_pe":
    if config.get("subsample", None) == "seqtk":
        merged_input = lambda wildcards: expand(
            "prealignment/seqtk_subsample/{{sample}}_{{type}}_{flowcell_lane_barcode}_{{read}}.ds.fastq.gz",
            flowcell_lane_barcode=[
                "{}_{}_{}".format(unit.flowcell, unit.lane, unit.barcode) for unit in get_units(units, wildcards, wildcards.type)
            ],
        )
    else:
        merged_input = lambda wildcards: expand(
            "prealignment/fastp_pe/{{sample}}_{{type}}_{flowcell_lane_barcode}_{{read}}.fastq.gz",
            flowcell_lane_barcode=[
                "{}_{}_{}".format(unit.flowcell, unit.lane, unit.barcode) for unit in get_units(units, wildcards, wildcards.type)
            ],
        )
else:
    merged_input = lambda wildcards: get_fastq_files(units, wildcards)


def get_nr_reads_per_fastq(nr_reads, units: pandas.DataFrame, wildcards: snakemake.io.Wildcards) -> int:
    return int(nr_reads / len(set([u.lane for u in units.loc[(wildcards.sample, wildcards.type)].itertuples()])))


def get_sortmerna_refs(wildcards: snakemake.io.Wildcards):
    return " --ref ".join(config.get("sortmerna", {}).get("fasta", ""))


def get_pbmarkdup_input(wildcards):
    unit = units.loc[(wildcards.sample, wildcards.type, wildcards.processing_unit, wildcards.barcode)]
    bam_file = unit["bam"]

    return bam_file


def compile_output_list(wildcards: snakemake.io.Wildcards):
    output_files = []
    files = {
        "prealignment/pbmarkdup": [".bam"],
    }
    output_files += [
        f"{prefix}/{sample}_{unit_type}_{processing_unit}_{barcode}{suffix}"
        for prefix in files.keys()
        for sample in get_samples(samples)
        for platform in units.loc[(sample,)].platform
        if platform == "PACBIO"
        for unit_type in get_unit_types(units, sample)
        if unit_type in ["N", "T"]
        for processing_unit in units.loc[(sample,)].processing_unit
        for barcode in units.loc[(sample,)].barcode
        for suffix in files[prefix]
    ]
    output_files += [
        "prealignment/merged/{}_{}_{}.fastq.gz".format(sample, t, read)
        for sample in get_samples(samples)
        for platform in units.loc[(sample,)].platform
        if platform not in ["PACBIO", "ONT"]
        for t in get_unit_types(units, sample)
        for read in ["fastq1", "fastq2"]
    ]
    output_files += [
        "prealignment/sortmerna/{}_R.rrna.fq.gz".format(sample)
        for sample in get_samples(samples)
        for platform in units.loc[(sample,)].platform
        if platform not in ["PACBIO", "ONT"]
        for t in get_unit_types(units, sample)
        if t == "R"
    ]

    return output_files
