# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


if config.get("trimmer_software", None) == "fastp":
    input = lambda wildcards: expand(
        "prealignment/fastp_pe/{{sample}}_{run_lane}_{{unit}}_{{read}}.fastq.gz",
        run_lane=["{}_{}".format(unit.run, unit.lane) for unit in get_units(units, wildcards, wildcards.unit)],
    )
else:
    input = lambda wildcards: get_fastq_files(units, wildcards)


rule decompress_and_merge_fastq_files:
    input:
        input,
    output:
        pipe("prealignment/merged/{sample}_{unit}_{read}.fastq"),
    log:
        "prealignment/merged/{sample}_{unit}_{read}.fastq.decompress_and_merge_fastq_files.logs",
    benchmark:
        "prealignment/merged/{sample}_{unit}_{read}.fastq.decompress_and_merge_fastq_files.benchmark.tsv"
    conda:
        "../envs/merge_fastq.yaml"
    shell:
        """
        pigz -dc -p {threads} {input} > {output} 2> {log}
        """


rule compress_fastq_file:
    input:
        "prealignment/merged/{sample}_{unit}_{read}.fastq",
    output:
        "prealignment/merged/{sample}_{unit}_{read}.fastq.gz",
    log:
        "prealignment/merged/{sample}_{unit}_{read}.fastq.gz.compress_fastq_files.log",
    benchmark:
        "prealignment/merged/{sample}_{unit}_{read}.fastq.gz.compress_fastq_files.benchmark.tsv"
    conda:
        "../envs/merge_fastq.yaml"
    shell:
        """
        pigz -p {threads} -f {input} > {output} 2> {log}
        """
