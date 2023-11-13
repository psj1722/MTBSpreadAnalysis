#!/bin/bash
while getopts ":i:t:c:I:T:d:k:D:o:" opt ;do
        case $opt in
                i) inputdir=$OPTARG;;
                t) threads=$OPTARG;;
                c) clusterscut=$OPTARG;;
                I) identitycut=$OPTARG;;
                T) tree=$OPTARG;;
                d) date=$OPTARG;;
                k) kraken=$OPTARG;;
                D) database=$OPTARG;;
                o) outputdir=$OPTARG;;
esac
done
##################tools################
#kneaddata
#kraken2
############ set threads ##############
if [ ! -n "$threads" ];then
        threads=30
fi
if [ ! -n "$clusterscut" ];then
        clusterscut=12
fi
if [ ! -n "$identitycut" ];then
        identitycut=0.95
fi
if [ ! -n "$tree" ];then
        tree=N
fi
if [ ! -n "$kraken" ];then
        kraken=N
fi
#######################################
for file_a in ${inputdir}/*
do
        temp_file=`basename $file_a`
        temp_file=$(echo ${temp_file} | sed 's/-/_/g')
        if [[ $temp_file =~ ".1.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%.1.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#1.fastq#2.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ "_1.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%_1.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#1.fastq#2.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file =~ ".1.fq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%.1.fq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#1.fq#2.fq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file =~ "_1.fq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%%_1.fq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#1.fq#2.fq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file =~ "_R1.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%%_R1.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1.fastq#R2.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file =~ "_R1.fq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%%_R1.fq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1.fq#R2.fq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file =~ ".R1.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%%.R1.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1.fastq#R2.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file =~ ".R1.fq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%%.R1.fq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1.fq#R2.fq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ "_R1_001.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%_R1_001.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#_R1_001.fastq#_R2_001.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ ".R1_001.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%.R1_001.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1_001.fastq#R2_001.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ ".R1_002.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%.R1_002.fastq.gz*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1_002.fastq#R2_002.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ "_R1_002.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%_R1_002.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#_R1_002.fastq#_R2_002.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ ".R1_003.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%.R1_003.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1_003.fastq#R2_003.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ "_R1_003.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%_R1_003.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#_R1_003.fastq#_R2_003.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ ".R1_004.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%.R1_004.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#R1_004.fastq#R2_004.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        elif [[ $temp_file  =~ "_R1_004.fastq" ]]
        then
                file1=${temp_file#*//}
                file2=${file1%_R1_004.fastq*}
                file2=$(echo ${file2} | sed 's/\./_/g')
                read1=$file_a
                read2=`echo "$read1" |sed 's#_R1_004.fastq#_R2_004.fastq#g'`
                name=(${name[@]} $file2)
                pe1=(${pe1[@]} $read1)
                pe2=(${pe2[@]} $read2)
        fi
done
mkdir -p ${outputdir}/outputDir
mkdir -p ${outputdir}/tempDir
mkdir -p ${outputdir}/outputDir/skf
tempdir=${outputdir}/tempDir
outdir=${outputdir}/outputDir
for ((i=0;i<${#name[@]};i++))
do
        file2=${name[${i}]}
        mkdir -p ${tempdir}/$file2
        tempDir=${tempdir}/${file2}
        echo "Sample ${file2} QC analysis begins"
        R1=$(echo "${pe1[${i}]}" |sed "s#${inputdir}##g")
        R2=$(echo "${pe2[${i}]}" |sed "s#${inputdir}##g")
        docker run --rm -v /tmp/:/tmp/ -v ${tempDir}:/tempDir -v ${inputdir}:/inputdir mtb_kneaddata:v1.0.0 kneaddata -i /inputdir/${R1} -i /inputdir/${R2} -db /database/humandata/hg37dec_v0.1 --bypass-trf -t ${threads} -o /tempDir --run-fastqc-start --run-fastqc-end
        mv ${tempDir}/${file2}_1_kneaddata_paired_1.fastq ${tempDir}/${file2}_kneaddata_paired_1.fastq
        mv ${tempDir}/${file2}_1_kneaddata_paired_2.fastq ${tempDir}/${file2}_kneaddata_paired_2.fastq
        q1=`awk -F "\t" 'NR==1{print $1}' ${tempDir}/fastqc/*1*fastqc/summary.txt`
        q2=`awk -F "\t" 'NR==1{print $1}' ${tempDir}/fastqc/*2*fastqc/summary.txt`
        if [[ $q1 == PASS && $q2 == PASS ]]
        then
                echo -e "${file2}",PASS >> ${outdir}/quality.txt
        else
                echo -e "${file2}",FAIL >> ${outdir}/quality.txt
        fi
        if [[ -s ${tempDir}/${file2}_kneaddata_paired_1.fastq ]]
        then
                echo "Sample ${file2} QC analysis succeed"
        else
                echo "Sample ${file2} QC analysis failed"
        fi
        ######### MTB species identification (the input files are the output files of QC) #########
        if [[ ${kraken} == "Y" ]]
        then
                echo "Sample ${file2} species identification begins"
                docker run --rm -v /tmp/:/tmp/ -v ${tempDir}:/tempDir -v ${database}:/database staphb/kraken2:latest kraken2 --db /database --report /tempDir/${file2}_kreport1.txt --paired  /tempDir/${file2}_kneaddata_paired_1.fastq /tempDir/${file2}_kneaddata_paired_2.fastq 1>>${tempdir}/${file2}/${file2}__1.out 2>>${tempdir}/${file2}/${file2}__1.log
                cat ${tempDir}/${file2}_kreport1.txt | grep "\<Mycobacterium tuberculosis complex\>" | awk '{print "'$file2'""\t"$0}' | sed 's/\t/,/g' >> ${outdir}/kreport_mtb.txt
                if [[ -s ${tempDir}/${file2}_kreport1.txt ]]
                then
                        echo "Sample ${file2} species identification succeed"
                else
                        echo "Sample ${file2} species identification failed"
                fi
                rm ${tempDir}/${file2}_1*
                rm -rf ${tempDir}/fastqc/1_1_kneaddata_unmatched*
        fi
done

################## get the ids list of MTB (95%) ###################################
if [[ ${kraken} == "Y" ]]
then
        awk -F "," '$2>=95{print $1}' ${outdir}/kreport_mtb.txt > ${outdir}/list_mtb.txt
elif [[ ${kraken} == "N" ]]
then
        awk -F "," '{print $1}' ${outdir}/quality.txt > ${outdir}/list_mtb.txt
fi
i=${#name[@]}
filename=${name[${i}]}
cat ${outdir}/list_mtb.txt |while read id;do
docker run --rm -v /tmp/:/tmp/ -v ${tempdir}:/tempdir -v ${outdir}:/outdir mtb:latest ska fastq -o /outdir/skf/${id} /tempdir/${id}/${id}_kneaddata_paired_1.fastq /tempdir/${id}/${id}_kneaddata_paired_2.fastq
echo -e "/outdir/skf/"${id}".skf" >> ${outdir}/skf/list_skf.txt
done
docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest ska merge -o /outdir/merged -s /outdir/list_mtb.txt -f  /outdir/skf/list_skf.txt
docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest ska weed -i /software/MGEs.skf /outdir/merged.skf
docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest ska distance -s ${clusterscut} -i ${identitycut} -o /outdir/distances /outdir/merged.weeded.skf
cat ${outdir}/distances.distances.tsv | awk -F "\t" '{print $1"\t"$2"\t"$7}' | sed 's/Sample /Sample/g'  > ${outdir}/snp1.csv
cat ${outdir}/snp1.csv | sed '1d' | awk -F "\t" '{print $2"\t"$1"\t"$3}' > ${outdir}/snp2.csv
cat ${outdir}/snp1.csv ${outdir}/snp2.csv > ${outdir}/snp.csv
# rm ${outdir}/snp1.csv ${outdir}/snp2.csv
################################### phylogenetic tree ######################################
echo "Start geting the phylogenetic tree"
if [[ ${tree} == "Y" ]]  ### iqtree
then
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest ska map -o /outdir/reference -r /software/h37rv.fasta /outdir/merged.weeded.skf
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest /software/iqtree/bin/iqtree -s /outdir/reference.aln -m TIM2+I+G -b 100 -T ${threads}
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir tree:v1.0.1 Rscript /script/iqtree.R treefile=/outdir/reference.aln.treefile treefig=/outdir/tree.png
        if [[ -s ${outdir}/reference.aln.treefile ]]
        then
                echo "geting the phylogenetic tree succeed"
        else
                echo "geting the phylogenetic tree failed"
        fi
elif [[ ${tree} == "N" ]]  ## fastme
then
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest python3 /pyfile/csv2matrix.py /outdir/snp.csv > ${outdir}/snp.matrix
        idnum=`cat ${outdir}/list_mtb.txt | wc -l`
        cat ${outdir}/snp.matrix | sed '/Sample/d' | sed "1i $idnum" | sed 's/NaN/0/g' | sed 's/\.0//g' > ${outdir}/snp_distance.txt
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest fastme -i /outdir/snp_distance.txt -m BioNJ
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir tree:v1.0.1 Rscript /script/fastme.R treefile=/outdir/snp_distance.txt_fastme_tree.nwk treefig=/outdir/tree.png
        if [[ -s ${outdir}/snp_distance.txt_fastme_tree.nwk ]]
        then
                echo "geting the phylogenetic tree succeed"
        else
                echo "geting the phylogenetic tree failed"
        fi
fi
################################## spreading network #####################################
echo "Start geting the spreading network"
if [[ -f "$date" ]]
then
        if [[ ! -f ${outdir}/reference.aln ]]
        then
                docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest ska map -o /outdir/reference -r /software/h37rv.fasta /outdir/merged.weeded.skf
        fi
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest /software/seqkit seq /outdir/reference.aln -n -i | awk '$0=NR"\t"$0' > ${outdir}/id.txt
        sed 's/^>.*$/&id/g' ${outdir}/reference.aln > ${outdir}/seq.fasta
        while read -r num text; do
          sed -i "s/>${text}id/>$num/g" ${outdir}/seq.fasta
        done < ${outdir}/id.txt
        cp $date ${outdir}/date.xlsx
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtbnetr:latest Rscript /script/network_type.R idfile=/outdir/id.txt datesfile=/outdir/date.xlsx seqfile=/outdir/seq.fasta netHtml=/outdir/netR.html summary=/outdir/summaryR.txt outfile=/outdir/outR.txt
        if [[ -s ${outdir}/netR.png ]]
        then
                echo "geting the spreading network succeed"
        else
                echo "geting the spreading network failed"
        fi
else
        cat ${outdir}/snp.csv | sed '1d' > ${outdir}/snp_networkx.txt
        docker run --rm -v /tmp/:/tmp/ -v ${outdir}:/outdir mtb:latest python3 /pyfile/net.py /outdir/snp_networkx.txt /outdir/network.png > ${outdir}/network.txt
        if [[ -s ${outdir}/network.png ]]
        then
                echo "geting the spreading network succeed"
        else
                echo "geting the spreading network failed"
        fi
fi
