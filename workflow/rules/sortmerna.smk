__author__ = "Martin Rippin"
__copyright__ = "Copyright 2021, Martin Rippin"
__email__ = "martin.rippin@scilifelab.uu.se"
__license__ = "GPL3"


rule sortmerna:
    input:
        reads=["prealignment/merged/{sample}_{type}_fastq1.fastq.gz", "prealignment/merged/{sample}_{type}_fastq2.fastq.gz"],
        ref=config.get("sortmerna", {}).get("fasta", []),
        idx_dir=config.get("sortmerna", {}).get("index", []),
    output:
        aligned=temp("prealignment/sortmerna/{sample}_{type}.rrna.fq.gz"),
        other=temp("prealignment/sortmerna/{sample}_{type}.fq.gz"),
    params:
        extra=config.get("sortmerna", {}).get("extra", ""),
    log:
        "prealignment/sortmerna/{sample}_{type}.rrna.fq.gz.log",
    benchmark:
        repeat(
            "prealignment/sortmerna/{sample}_{type}.rrna.fq.gz.benchmark.tsv",
            config.get("sortmerna", {}).get("benchmark_repeats", 1),
        )
    resources:
        mem_mb=config.get("sortmerna", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("sortmerna", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("sortmerna", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("sortmerna", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("sortmerna", {}).get("time", config["default_resources"]["time"]),
    threads: config.get("sortmerna", {}).get("threads", config["default_resources"]["threads"])
    container:
        config.get("sortmerna", {}).get("container", config["default_container"])
    message:
        "{rule}: identify ribosomal rna in {input.reads[0]} and {input.reads[1]}"
    wrapper:
        "master/bio/sortmerna"
