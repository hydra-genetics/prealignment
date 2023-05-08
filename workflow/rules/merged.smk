__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


rule merged:
    input:
        fastq=merged_input,
    output:
        fastq=temp("prealignment/merged/{sample}_{type}_{read}.fastq.gz"),
    log:
        "prealignment/merged/{sample}_{type}_{read}.fastq.gz.log",
    benchmark:
        repeat(
            "prealignment/merged/{sample}_{type}_{read}.fastq.gz.benchmark.tsv",
            config.get("merged", {}).get("benchmark_repeats", 1),
        )
    resources:
        mem_mb=config.get("merged", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("merged", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("merged", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("merged", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("merged", {}).get("time", config["default_resources"]["time"]),
    threads: config.get("merged", {}).get("threads", config["default_resources"]["threads"])
    container:
        config.get("merged", {}).get("container", config["default_container"])
    message:
        "{rule}: merge fastq files {input}"
    shell:
        "cat {input.fastq} > {output.fastq} 2> {log}"
