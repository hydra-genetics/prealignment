# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


if config.get("trimmer_software", None) == "fastp":
    input = lambda wildcards: expand(
        "prealignment/fastp_pe/{{sample}}_{run_lane}_{{type}}_{{read}}.fastq.gz",
        run_lane=["{}_{}".format(unit.run, unit.lane) for unit in get_units(units, wildcards, wildcards.type)],
    )
else:
    input = lambda wildcards: get_fastq_files(units, wildcards)


rule merge_fastq_gz_file:
    input:
        input
    output:
        "prealignment/merged/{sample}_{type}_{read}.fastq.gz",
    log:
        "prealignment/merged/{sample}_{type}_{read}.fastq.gz.merge_fastq_gz_file.log",
    benchmark:
        "prealignment/merged/{sample}_{type}_{read}.fastq.gz.merge_fastq_gz_file.benchmark.tsv"
    conda:
        "../envs/merge_fastq.yaml"
    shell:
        """
        cat {input} > {output} 2> {log}
        """
