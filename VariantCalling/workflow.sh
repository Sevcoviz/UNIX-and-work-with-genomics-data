#!/bin/bash

DATA_DIR="$HOME"
FILE_NAME=$1
FILE="$FILE_NAME"
OUTPUT=$2

zcat $FILE | grep -v "^#"| grep -E '^chr[1Z]\s' > no_headers.vcf

FILEPro=no_headers.vcf


cat $FILEPro | cut -f1-6 > part1_core.tsv

cat $FILEPro | grep -o -E "DP=[0-9]+" | sed 's/DP=//' > part2_dp.tsv

cat $FILEPro | awk '{if($8 ~ /INDEL/) print "INDEL"; else print "SNP"}' > part3_type.tsv

wc -l part1_core.tsv part2_dp.tsv part3_type.tsv

paste part1_core.tsv part2_dp.tsv part3_type.tsv > $OUTPUT


echo "Output saved to $OUTPUT"
wc -l "$OUTPUT"
