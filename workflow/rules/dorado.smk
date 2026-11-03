__author__ = "Camille Clouard"
__copyright__ = "Copyright 2026, Camille Clouard"
__email__ = "camille.clouard@scilifelab.uu.se"
__license__ = "GPL-3"


rule dorado_trim:
    input:
        bam=get_dorado_trim_input,
    output:
        fastq=temp("prealignment/dorado_trim/{sample}_{type}_{processing_unit}_{barcode}.trimmed.fastq"),
    params:
        extra=config.get("dorado_trim", {}).get("extra", ""),
        sequencing_kit=get_dorado_trim_sequencing_kit,
    log:
        "prealignment/dorado_trim/{sample}_{type}_{processing_unit}_{barcode}.trimmed.fastq.log",
    benchmark:
        repeat(
            "prealignment/dorado_trim/{sample}_{type}_{processing_unit}_{barcode}.trimmed.fastq.benchmark.tsv",
            config.get("dorado_trim", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("dorado_trim", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("dorado_trim", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("dorado_trim", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("dorado_trim", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("dorado_trim", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("dorado_trim", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("dorado_trim", {}).get("container", config["default_container"])
    message:
        "{rule}: trim adapters and primers from {input.bam} with dorado"
    shell:
        "dorado trim "
        "--threads {threads} "
        "{params.sequencing_kit} "
        "{params.extra} "
        "--emit-fastq "
        "{input.bam} > {output.fastq} 2> {log}"
