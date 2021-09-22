# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


rule merged:
    input:
        merged_input,
    output:
        "prealignment/merged/{sample}_{type}_{read}.fastq.gz",
    threads: config.get("{rule}", config["default"])["cpu"]
    log:
        "prealignment/merged/{sample}_{type}_{read}.fastq.gz.merge_fastq_gz_file.log",
    benchmark:
        repeat(
            "prealignment/merged/{sample}_{type}_{read}.fastq.gz.merged.benchmark.tsv",
            config.get("merged", {}).get("benchmark_repeats", 1),
        )
    conda:
        "../envs/merged.yaml"
    container:
        config.get("merged", {}).get("container", config["default_container"])
    message:
        "{rule}: merge fastq files {input}"
    shell:
        """
        cat {input} > {output} 2> {log}
        """
