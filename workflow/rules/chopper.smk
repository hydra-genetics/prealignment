__author__ = "Camille Clouard"
__copyright__ = "Copyright 2026, Camille Clouard"
__email__ = "camille.clouard@scilifelab.uu.se"
__license__ = "GPL-3"


rule chopper:
    input:
        bam="prealignment/dorado_trim/{sample}_{type}_{processing_unit}_{barcode}.trimmed.bam",
    output:
        bam=temp("prealignment/chopper/{sample}_{type}_{processing_unit}_{barcode}.filtered.bam"),
    params:
        extra=config.get("chopper", {}).get("extra", ""),
        maxlength=get_chopper_option("maxlength"),
        minlength=get_chopper_option("minlength"),
        quality=get_chopper_option("quality"),
    log:
        "prealignment/chopper/{sample}_{type}_{processing_unit}_{barcode}.filtered.bam.log",
    benchmark:
        repeat(
            "prealignment/chopper/{sample}_{type}_{processing_unit}_{barcode}.filtered.bam.benchmark.tsv",
            config.get("chopper", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("chopper", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("chopper", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("chopper", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("chopper", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("chopper", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("chopper", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("chopper", {}).get("container", config["default_container"])
    message:
        "{rule}: filter reads in {input.bam} with chopper"
    shell:
        "chopper "
        "--threads {threads} "
        "{params.quality} "
        "{params.minlength} "
        "{params.maxlength} "
        "{params.extra} "
        "--input {input.bam} "
        "--output-format bam "
        "> {output.bam} 2> {log}"
