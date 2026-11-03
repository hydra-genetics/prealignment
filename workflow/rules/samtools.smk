__author__ = "Camille Clouard"
__copyright__ = "Copyright 2026, Camille Clouard"
__email__ = "camille.clouard@scilifelab.uu.se"
__license__ = "GPL-3"


rule samtools_fastq:
    input:
        bam="prealignment/dorado_trim/{sample}_{type}_{processing_unit}_{barcode}.trimmed.bam",
    output:
        fastq=temp("prealignment/samtools_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq"),
    params:
        extra=config.get("samtools_fastq", {}).get("extra", ""),
    log:
        "prealignment/samtools_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq.log",
    benchmark:
        repeat(
            "prealignment/samtools_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq.benchmark.tsv",
            config.get("samtools_fastq", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("samtools_fastq", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("samtools_fastq", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("samtools_fastq", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("samtools_fastq", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("samtools_fastq", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("samtools_fastq", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("samtools_fastq", {}).get("container", config["default_container"])
    message:
        "{rule}: convert unaligned bam {input.bam} to fastq"
    shell:
        "samtools fastq "
        "--threads {threads} "
        "{params.extra} "
        "{input.bam} > {output.fastq} 2> {log}"


rule samtools_compress_fastq:
    input:
        fastq="prealignment/samtools_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq",
    output:
        fastq=temp("prealignment/samtools_compress_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq.gz"),
    params:
        extra=config.get("samtools_compress_fastq", {}).get("extra", ""),
    log:
        "prealignment/samtools_compress_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq.gz.log",
    benchmark:
        repeat(
            "prealignment/samtools_compress_fastq/{sample}_{type}_{processing_unit}_{barcode}.fastq.gz.benchmark.tsv",
            config.get("samtools_compress_fastq", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("samtools_compress_fastq", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("samtools_compress_fastq", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("samtools_compress_fastq", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("samtools_compress_fastq", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("samtools_compress_fastq", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("samtools_compress_fastq", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("samtools_compress_fastq", {}).get("container", config["default_container"])
    message:
        "{rule}: compress {input.fastq}"
    shell:
        "gzip -c {params.extra} {input.fastq} > {output.fastq} 2> {log}"
