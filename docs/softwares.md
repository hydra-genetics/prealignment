# Softwares used in the prealignment module
## [Fastp](https://github.com/OpenGene/fastp)
**Function:**  
Trim `.fastq` files by removing adapter sequences and other unwanted sequences  
**Input:**  
Untrimmed `.fastq` file  
**Output:**  
Trimmed `.fastq` file  
**Resources:**  
Use multiple threads for decreased run time

## Fastq merging
**Function:**  
Merge `.fastq` files generated for example on different lanes by simply concatenating them using cat  
**Input:**  
Several `.fastq` files from the same sample  
**Output:**  
Merged `.fastq` file  

## [Sortmerna](https://github.com/biocore/sortmerna)
**Function:**  
Filter out ribosomal RNA (rRNA) from RNA data  
**Input:**  
Unfiltered merged `.fastq` file  
**Output:**  
rRNA filtered merged `.fastq` file  
