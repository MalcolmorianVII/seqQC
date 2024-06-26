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

rule sortbam:
    input:
        rules.sam2bam.output
    output:
        "{sample}.sorted.bam"
    shell:
    "samtools sort -o {output} {input}"

rule indexbam:
    input:
        rules.sortbam.output
    output:
        "{sample}.sorted.bam.bai"
    shell:
    "samtools index {input}"

# should run after indexbam
rule calculate_depth:
    input:
        rules.sortbam.output
    output:
        "{sample}_cov.txt"
    shell:
    "samtools depth -aa {input} > {output}"

rule flagstat:
    input:
        rules.sortbam.output
    output:
        "{sample}_reads_mapped.txt"
    shell:
    "samtools flagstat {input} > {output}"

rule calc_avg_depth:
    input:
        rules.sortbam.output
    output:
        "{sample}_reads_mapped.txt"
    shell:
    """awk "{sum+=\$3} END {print sum/NR}" {}/{}_cov.txt"""

rule calc_avg_depth_10X:
    input:
        rules.sortbam.output
    output:
        "{sample}_reads_mapped.txt"
    shell:
    """awk "\$3 >= 10 {sum+=1} END {print (sum / 2063372) * 100}" {}/{}_cov.txt"""

rule calc_avg_depth_30X:
    input:
        rules.sortbam.output
    output:
        "{sample}_reads_mapped.txt"
    shell:
    """awk "\$3 >= 30 {sum+=1} END {print (sum / 2063372) * 100}" {}/{}_cov.txt"""


rule calc_map_stats:
    input:
        rules.sortbam.output
    output:
        "{sample}_reads_mapped.txt"
    shell:
    """awk "/^([0-9]+) \\+ 0 in total/{total_reads = \$1} /^([0-9]+) \\+ 0 mapped/{reads_mapped = \$1; percentage = \$(NF - 2); print total_reads, reads_mapped, percentage}" {}/{}_reads_mapped.txt"""