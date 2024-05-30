# Develop first with short reads in mind
rule map:
    input:
        r1="{}/{}*_R1*.fastq.gz",
        r2="{}/{}*_R2*.fastq.gz",
        ref="/data/fast/core/minion/minion_runs/20240130_1627_MN33881_FAX56654_97737fa9/demux_bam/marvels/ASHP01.1.fsa_nt.gz"
    output:
        "{sample}.sam"
    shell:
    "bwa mem {ref} {r1} {r2} > {wildcards.sample}.sam"

rule sam2bam:
    input:
        rules.map.output
    output:
        "{sample}.bam"
    shell:
    "samtools view -S -b {input} > {output}"

