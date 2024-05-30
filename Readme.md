This pipeline does the following:
Takes in the raw sequencing data i.e short read or long read
Maps it to the reference genome provided
Calculate basic sequence stats on the alignment
i.e sequence depth
seq coverage percent at different depths
Number of reads mapped
Total reads
Percentage of reads mapped

For short reads:
Use bwa for short read mapping
Use samtools depth to calculate average depth
Use samtools flagstat to do further stats

For long reads:
Use minimap2 to do long read mapping to the reference
Use samtools depth to calculate average depth
Use samtools flagstat to do further stats

Report these results in a tab delimited file with the following format:
sampleID,avg_depth,percentage_cov10X,percentage_cov10X,reads_mapped,total_reads,reads_mapped_perc