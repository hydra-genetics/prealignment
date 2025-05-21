__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2025, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule seqtk_subsample:
    input:
        fastq="prealignment/merged/{sample}_{type}_{read}.fastq.gz",
    output:
        fastq=temp("prealignment/seqtk_subsample/{sample}_{type}_{read}.ds.fastq.gz"),
    params:
        extra=config.get("seqtk_subsample", {}).get("extra", ""),
        nr_reads=config.get("seqtk_subsample", {}).get("nr_reads", "10000"),
        seed=config.get("seqtk_subsample", {}).get("seed", "-s100"),
    log:
        "prealignment/seqtk_subsample/{sample}_{type}_{read}.ds.fastq.log",
    benchmark:
        repeat(
            "prealignment/seqtk_subsample/{sample}_{type}_{read}.ds.fastq.benchmark.tsv",
            config.get("seqtk_subsample", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("seqtk_subsample", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("seqtk_subsample", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("seqtk_subsample", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("seqtk_subsample", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("seqtk_subsample", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("seqtk_subsample", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("seqtk_subsample", {}).get("container", config["default_container"])
    message:
        "{rule}: downsample {input.fastq}"
    shell:
        'sh -c "'
        "seqtk sample "
        "{params.seed} "
        "{params.extra} "
        "{input.fastq} "
        "{params.nr_reads} "
        "| gzip "
        '> {output.fastq}" >& {log}'
