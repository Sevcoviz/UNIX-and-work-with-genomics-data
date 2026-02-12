# Variant Calling

1. pick only data for chromosomes chr1 and chrZ
``` bash
< $FILE zcat |grep -v "^#" | grep -E '^chr[1Z]\s' | wc -l
```
The resulting number is the number of variants on these two chromosomes is: 65869



2. extract the sequencing depth DP from the INFO column
``` bash
< $FILE zcat  | grep -v "^##" | grep -E 'chr[1Z]\s' | grep -o -E "DP=([0-9]+)" | sed 's/DP=//' | head
```
``` bash
6
9
45
22
18
37
3
74
10
75
```

3. extract variant type by checking if the INFO column contains INDEL string
``` bash
zcat $FILE | grep -v "^##" | grep -E 'chr[1Z]' | awk '{if($0 ~ /INDEL/) print "INDEL"; else print "SNP";}' | sort | uniq -c
```
``` bash
 14287 INDEL
  51582 SNP
```

4. merge these two columns together with the first six columns of the VCF

## Workflow
``` bash
#!/bin/bash

DATA_DIR="$HOME"
FILE_NAME=$1
FILE="$FILE_NAME"
OUTPUT=$2

zcat $FILE | grep -v "^#" | grep -E '^chr[1Z]\s' | cut -f1-6 > part1_core.txt

zcat $FILE | grep -v "^#" | grep -E '^chr[1Z]\s' | grep -o -E "DP=[0-9]+" | sed 's/DP=//' > part2_dp.txt

zcat $FILE | grep -v "^#" | grep -E '^chr[1Z]\s' | grep -o -E "DP=[0-9]+" | sed 's/DP=//' > part2_dp.txt

wc -l part1_core.txt part2_dp.txt part3_type.txt

paste part1_core.txt part2_dp.txt part3_type.txt > $OUTPUT


echo "Output saved to $OUTPUT"
wc -l "$OUTPUT"
```

# R studio 
1. barchart of variant types, how many variant are INDELs and how many SNPs (use geom_bar())
``` R
library(tidyverse)

d <- read_tsv('processed_variants.tsv', col_names=c('CHROM', 'POS', 'ID', 'REF', 'ALT', 'QUAL', 'DP', 'TYPE'))
colnames(d)

# Geom Bar
ggplot(d, aes(x=TYPE)) + 
  geom_bar()
```

2. boxplot of qualities for INDELs and SNPs (use geom_boxplot() and additionally scale_y_log10() if you don’t like the outliers)
``` R
# Log10 scale is normalizing the data
# Boxplot
ggplot(d, aes(x=TYPE, y=QUAL)) + 
  geom_boxplot() + 
  scale_y_log10()
```

3. histogram of qualities for INDELs and SNPs (use geom_histogram() and additionally scale_x_log10(), facet_wrap())
``` R
# Histogram
ggplot(d, aes(x=QUAL)) + 
  geom_histogram() + 
  scale_x_log10() + 
  facet_wrap(~TYPE, ncol = 1)
```

``` R
# Filtering the quality
d %>%
  filter(QUAL < 900) %>%
  ggplot(aes(QUAL)) +
  geom_histogram() +
  scale_x_log10() +
  facet_wrap(~TYPE, scales="free_y")
```