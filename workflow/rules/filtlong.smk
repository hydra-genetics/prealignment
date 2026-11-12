__author__ = "Camille Clouard"
__copyright__ = "Copyright 2026, Camille Clouard"
__email__ = "camille.clouard@scilifelab.uu.se"
__license__ = "GPL-3"


rule filtlong:
    input:
        fastq="prealignment/samtools_compress_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq.gz",
    output:
        fastq=temp("prealignment/filtlong/{sample}_{type}_{processing_unit}_{barcode}.filtered.fastq.gz"),
    params:
        extra=config.get("filtlong", {}).get("extra", ""),
        max_length=config.get("filtlong", {}).get("max_length", 30000),
        min_length=config.get("filtlong", {}).get("min_length", 50),
    log:
        "prealignment/filtlong/{sample}_{type}_{processing_unit}_{barcode}.filtered.fastq.gz.log",
    benchmark:
        repeat(
            "prealignment/filtlong/{sample}_{type}_{processing_unit}_{barcode}.filtered.fastq.gz.benchmark.tsv",
            config.get("filtlong", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("filtlong", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("filtlong", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("filtlong", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("filtlong", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("filtlong", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("filtlong", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("filtlong", {}).get("container", config["default_container"])
    message:
        "{rule}: filter reads in {input.fastq} by quality and length ({params.min_length}-{params.max_length} bp)"
    shell:
        "(filtlong "
        "--min_length {params.min_length} "
        "--max_length {params.max_length} "
        "{params.extra} "
        "{input.fastq} | gzip > {output.fastq}) 2> {log}"
