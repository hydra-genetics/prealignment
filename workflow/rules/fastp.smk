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
        trimmed=temp(
            [
                "prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastq1.fastq.gz",
                "prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastq2.fastq.gz",
            ]
        ),
        html="prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastp.html",
        json="prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastp.json",
    params:
        adapters=lambda wildcards: " --adapter_sequence {} --adapter_sequence_r2 {} ".format(
            *get_fastq_adapter(units, wildcards).split(",")
        ),
        extra=config.get("fastp_pe", {}).get("extra", ""),
    log:
        "prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastq.fastq.gz.log",
    benchmark:
        repeat(
            "prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastq.fastq.gz.benchmark.tsv",
            config.get("fastp_pe", {}).get("benchmark_repeats", 1),
        )
    resources:
        mem_mb=config.get("fastp_pe", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("fastp_pe", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("fastp_pe", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("fastp_pe", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("fastp_pe", {}).get("time", config["default_resources"]["time"]),
    threads: config.get("fastp_pe", {}).get("threads", config["default_resources"]["threads"])
    container:
        config.get("fastp_pe", {}).get("container", config["default_container"])
    message:
        "{rule}: trim fastq files {input.sample} using fastp,\n\t\t with adapters: {params.adapters}"
    wrapper:
        "0.78.0/bio/fastp"
