# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL3"


rule fastp_pe:
    input:
        sample=lambda wildcards: [
            get_fastq_file(units, wildcards, "fastq1"),
            get_fastq_file(units, wildcards, "fastq2"),
        ],
    output:
        trimmed=[
            "prealignment/fastp_pe/{sample}_{run}_{lane}_{unit}_fastq1.fastq.gz",
            "prealignment/fastp_pe/{sample}_{run}_{lane}_{unit}_fastq2.fastq.gz",
        ],
        html="prealignment/fastp_pe/{sample}_{run}_{lane}_{unit}.html",
        json="prealignment/fastp_pe/{sample}_{run}_{lane}_{unit}.json",
    params:
        adapters=lambda wildcards: " --adapter_sequence {} --adapter_sequence_r2 {} ".format(
            *get_fastq_adapter(units, wildcards).split(",")
        ),
        extra=config.get("fastp", {}).get("extra", ""),
    conda:
        "../envs/fastp.yaml"
    log:
        "prealignment/fastp/{sample}_{run}_{lane}_{unit}_fastp.fastp_trimming.log",
    threads: 5
    benchmark:
        repeat(
            "prealignment/fastp/{sample}_{run}_{lane}_{unit}.fastq.gz.fastp_trimming.benchmark.tsv",
            config.get("benchmark", {}).get("repeats", 1),
        )
    container:
        config.get("singularity", {}).get("fastp", config.get("singularity", {}).get("default", ""))
    wrapper:
        "0.78.0/bio/fastp"
