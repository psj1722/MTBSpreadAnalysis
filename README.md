# MTBSpreadAnalysis
-------------

This is a program for fast spread analysis based on nonalignment algorithms for M.tuberculosis samples, which are Fastq data under 
the second-generation Illumina machine. The main functions include quality detection, species identification, phylogenetic tree, 
propagation network.

Environment
-------------
Linux(centos7+)

Installation
-------------
Get the docker images:  
```
docker pull microbioinfo/mtb_kneaddata:v1.0.0
docker pull staphb/kraken2:latest
docker pull microbioinfo/mtb:latest
docker pull microbioinfo/tree:v1.0.1
docker pull microbioinfo/mtbnetr:latest
```
If species identification is required, you need to build your own library, and the method of building the library is as follows:
```
Get the image 'staphb/kraken2:latest', get in your database folder and execute the following commands:
docker run --rm staphb/kraken2:latest kraken2-build --download-taxonomy --db Actinomycetes
docker run --rm staphb/kraken2:latest kraken2-build --no-masking --download-library Actinomycetes --db Actinomycetes
docker run --rm staphb/kraken2:latest kraken2-build --build --threads 8 --db Actinomycetes
```
If you are providing a date file, the date file format refer to the file 'date.xlsx' which we provided in the "Files" section.
This file contains at least two columns, the first column is the sample ID, which are the content in front of _1.fastq (.gz) 
in the sequenced data name; The second column is the date of the sample, 0 represents the date of the earliest sample, and the 
date of the subsequent sample is the number of months between the earliest sample. More columns are the information you want to 
display in the graph, such as type, gender, etc.

Usage
-------------
Create two folders, one is the input folder, and all the FASTQ files are placed in this folder; Another one is the output folder, 
and the output files after execution will be in this folder.
```
bash MTBSpread.sh -i ... -o ... [other options]

Options:
-i        The folder of input FASTQ files. All the FASTQ files are in this folder. -i /path/to/input/folder
-o        The folder of output files. -o /path/to/output/folder
-c        SNP cutoff for defining clusters. Isolates will be clustered if they are separated by fewer than this number of SNPs 
          and pass the identity cutoff. [Default:12]
-I        Identity cutoff for defining clusters. Isolates will be clustered if they share at least this proportion of the split kmers 
          in the file with fewer kmers and pass the SNP cutoff. [Default:0.95]
-t        Number of threads. [Default:30]
-T        The tree building method is divided into Y or N. Y: sequence alignment and iqtree maximum likelihood method is 
          used to build the tree; N: no sequence alignment is performed, and fastme is used to build the tree. [Default:N]
-d        The file of date information to create a network. You can choose not to provide the file, if provide, the format should 
          refer to the file 'date.xlsx' . In this table, you can provide more information after the second column, but the first and 
          second column are required, and the first column must be the id of your sample, the second column must be the date 
          information.  -d /path/to/datefile
-k        Whether or not to conduct species identification, and there are two options, Y and N. Y: conduct species identification. 
          If you choose Y, you also need to provide database using the options '-D'. For more information about how to create a 
          library, see the "Installation" section. N: No species identification is performed. [Default:N]
-D        The database of species identification. Enabled when '-k' is Y, i.e. conduct species identification. 
          -D /path/to/database/Actinomycetes
```
