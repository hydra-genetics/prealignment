# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("6.8.0")

### Set and validate config file


configfile: "config.yaml"


validate(config, schema="../schemas/config.schema.yaml")


### Read and validate samples file

samples = pd.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

<<<<<<< 41dd6eccbba6af37ea27f3660cbbdb49c46416aa
units = pd.read_table(config["units"], dtype=str).set_index(["sample", "type", "run", "lane"], drop=False)
=======
units = pd.read_table(config["units"], dtype=str).set_index(["sample", "unit", "run", "lane"], drop=False)
>>>>>>> Workflow that can trim using fastp and merge files.
validate(units, schema="../schemas/units.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),
<<<<<<< 41dd6eccbba6af37ea27f3660cbbdb49c46416aa


def get_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample, wildcards.type, wildcards.run, wildcards.lane), ["fastq1", "fastq2"]].dropna()
    return {"fwd": fastqs.fastq1, "rev": fastqs.fastq2}


def get_sample_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample, wildcards.type), ["fastq1", "fastq2"]].dropna()
    return {"fwd": fastqs["fastq1"].tolist(), "rev": fastqs["fastq2"].tolist()}


def compile_output_list(wildcards):
    return ["dummy.txt"]
=======
    unit="N|T|R",
    read="fastq[1|2]",


def get_unit(units: pd.DataFrame, wildcards: snakemake.io.Wildcards) -> pd.Series:
    """
    function used to extract one unit(row) from units.tsv

    Args:
        units: DataFrame generate by importing a file following schema defintion
               found in pre-alignment/workflow/schemas/units.schema.tsv
        wildcards: wildcards object with at least the following widlcard names
               sample, unit, run, and lane

    Returns:
        Series containing data of the selected row

    Raises:
        raises and exception if no unit can be extracted from the Dataframe
    """
    unit = units.loc[(wildcards.sample, wildcards.unit, wildcards.run, wildcards.lane)].dropna()
    return unit


def get_fastq_file(units: pd.DataFrame, wildcards: snakemake.io.Wildcards, read_pair: str = "fastq1") -> str:
    """
    function used to extract path for one unit(row) from units.tsv

    Args:
        units: DataFrame generate by importing a file following schema defintion
               found in pre-alignment/workflow/schemas/units.schema.tsv
        wildcards: wildcards object with at least the following widlcard names
               sample, unit, run, and lane
        read_pair: fast1 or fastq2

    Returns:
        path for fastq file as a str

    Raises:
        raises and exception if no unit can be extracted from the Dataframe
    """
    unit = get_unit(units, wildcards)
    if len(unit) == 0:
        raise ValueError("No data found!")
    return unit[read_pair]


def get_fastq_adapter(units: pd.DataFrame, wildcards: snakemake.io.Wildcards) -> str:
    """
    function used to extract adapters for one unit(row) from units.tsv

    Args:
        units: DataFrame generate by importing a file following schema defintion
               found in pre-alignment/workflow/schemas/units.schema.tsv
        wildcards: wildcards object with at least the following widlcard names
               sample, unit, run, and lane

    Returns:
        return adapter with format seq1,seq2

    Raises:
        raises and exception if no unit can be extracted from the Dataframe
    """
    unit = get_unit(units, wildcards)
    return unit["adapter"]


def get_units(units: pd.DataFrame, wildcards: snakemake.io.Wildcards, unit: str = None) -> pd.DataFrame:
    """
    function used to extract one or more units from units.tsv

    Args:
        units: DataFrame generate by importing a file following schema defintion
               found in pre-alignment/workflow/schemas/units.schema.tsv
        wildcards: wildcards object with at least the following widlcard names
               sample and unit (optional, can also be passed as an argument).
        unit: N,T or R

    Returns:
        all units from the DataFrame that can be filtereted out using sample name
        and unit type (N,T,R)

    Raises:
        raises and exception if no unit(s) can be extracted from the Dataframe
    """
    if unit is None:
        files = units.loc[(wildcards.sample, wildcards.unit)].dropna()
    else:
        files = units.loc[(wildcards.sample, unit)].dropna()
    if len(files) == 0:
        raise Exception("No units found")
    return [file for file in files.itertuples()]


def get_fastq_files(units: pd.DataFrame, wildcards: snakemake.io.Wildcards, unit: str = None):
    """
    function used to extract all fastq files for a sample with a sepecific unit-

    Args:
        units: DataFrame generate by importing a file following schema defintion
               found in pre-alignment/workflow/schemas/units.schema.tsv
        wildcards: wildcards object with at least the following widlcard names
               sample, read and unit (optional, can also be passed as an argument).
        unit: N,T or R

    Returns:
        all units from the DataFrame that can be filtereted out using sample name
        ,fastq (1 or 2) and unit type (N,T,R)

    Raises:
        raises and exception if no unit(s) can be extracted from the Dataframe
    """
    return [getattr(file, wildcards.read) for file in get_units(units, wildcards, unit)]


def compile_output_list(wildcards: snakemake.io.Wildcards):
    return ["prealignment/merged/HD827sonic_N_fastq1.fastq.gz", "prealignment/merged/HD827sonic_N_fastq2.fastq.gz"]
>>>>>>> Workflow that can trim using fastp and merge files.
