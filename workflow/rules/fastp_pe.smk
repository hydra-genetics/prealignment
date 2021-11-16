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
            "prealignment/fastp_pe/{sample}_{run}_{lane}_{type}_fastq1.fastq.gz",
            "prealignment/fastp_pe/{sample}_{run}_{lane}_{type}_fastq2.fastq.gz",
        ],
        html="prealignment/fastp_pe/{sample}_{run}_{lane}_{type}.html",
        json="prealignment/fastp_pe/{sample}_{run}_{lane}_{type}.json",
    params:
        adapters=lambda wildcards: " --adapter_sequence {} --adapter_sequence_r2 {} ".format(
            *get_fastq_adapter(units, wildcards).split(",")
        ),
        extra=config.get("fastp_pe", {}).get("extra", ""),
    log:
        "prealignment/fastp_pe/{sample}_{run}_{lane}_{type}_fastp.fastp_trimming.log",
    threads: config.get("fastp_pe", {}).get('threads', config["default_resources"]["threads"])
    resources:
        threads=config.get("fastp_pe", {}).get('threads', config["default_resources"]["threads"]),
        time=config.get("fastp_pe", {}).get('time', config["default_resources"]["time"]),
        mem_mb=config.get("fastp_pe", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("fastp_pe", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("fastp_pe", {}).get("partition", config["default_resources"]["partition"]),
    benchmark:
        repeat(
            "prealignment/fastp_pe/{sample}_{run}_{lane}_{type}.fastq.gz.fastp_trimming.benchmark.tsv",
            config.get("fastp_pe", {}).get("benchmark_repeats", 1),
        )
    conda:
        "../envs/fastp_pe.yaml"
    container:
        config.get("fastp_pe", {}).get("container", config["default_container"])
    message:
        "{rule}: trim fastq files {input} using fastp,\n\t\t With adapters: {params.adapters}"
    wrapper:
        "0.78.0/bio/fastp"
