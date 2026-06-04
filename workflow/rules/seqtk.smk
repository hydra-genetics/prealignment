__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2025, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule seqtk_subsample:
    input:
        fastq="prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_{read}.fastq.gz",
        fastp_json="prealignment/fastp_pe/{sample}_{type}_{flowcell}_{lane}_{barcode}_fastp.json",
    output:
        fastq=temp("prealignment/seqtk_subsample/{sample}_{type}_{flowcell}_{lane}_{barcode}_{read}.ds.fastq.gz"),
    params:
        extra=config.get("seqtk_subsample", {}).get("extra", "-2"),
        nr_reads_per_fastq=lambda wildcards: get_nr_reads_per_fastq(
            config.get("seqtk_subsample", {}).get("nr_reads", 1000000000), units, wildcards
        ),
        seed=config.get("seqtk_subsample", {}).get("seed", "-s100"),
        fastp_read_field=lambda wildcards: "read1_after_filtering" if wildcards.read == "fastq1" else "read2_after_filtering",
    log:
        "prealignment/seqtk_subsample/{sample}_{type}_{flowcell}_{lane}_{barcode}_{read}.ds.fastq.log",
    benchmark:
        repeat(
            "prealignment/seqtk_subsample/{sample}_{type}_{flowcell}_{lane}_{barcode}_{read}.ds.fastq.benchmark.tsv",
            config.get("seqtk_subsample", {}).get("benchmark_repeats", 1),
        )
    container:
        config.get("seqtk_subsample", {}).get("container", config["default_container"])
    threads: config.get("seqtk_subsample", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("seqtk_subsample", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("seqtk_subsample", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("seqtk_subsample", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("seqtk_subsample", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("seqtk_subsample", {}).get("time", config["default_resources"]["time"]),
    params:
        command="sample",
        extra=lambda wildcards: "{} {}".format(
            config.get("seqtk_subsample", {}).get("extra", "-2"),
            config.get("seqtk_subsample", {}).get("seed", "-s100"),
        ),
        n=lambda wildcards: get_nr_reads_per_fastq(
            config.get("seqtk_subsample", {}).get("nr_reads", 1000000000), units, wildcards
        ),
    message:
        "{rule}: downsample {input.fastq} if it has more reads than the target, otherwise copy it unchanged"
    shell:
        "actual_reads=$(grep -A1 \"{params.fastp_read_field}\" {input.fastp_json} | grep total_reads | grep -oE '[0-9]+'); "
        'if [ "$actual_reads" -le {params.nr_reads_per_fastq} ]; then '
        "cp {input.fastq} {output.fastq}; "
        "else "
        "seqtk sample {params.seed} {params.extra} {input.fastq} {params.nr_reads_per_fastq} | gzip > {output.fastq}; "
        "fi &> {log}"
