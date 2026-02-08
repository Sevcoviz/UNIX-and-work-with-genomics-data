# Running a project



## Exercise 8
### we want to count the annotations per each chromosome
``` bash
< $INPUT cut -f1 | sort | uniq -c | sort -k2,2n | awk '{print $2, $1}'
```

# awk
Record number 'NR' - number of the current record (line) \
``` bash
< $INPUT awk '{print NR}' | uniq
```
prints the line number of each line in the file ????



#### Put the first 4 columns (one sample) to one line
```bash
<data/HRTMUOC01.RL12.01.fastq paste - - - - | less
```

**Get the length of the sequence in the second column**
``` bash
<data/HRTMUOC01.RL12.01.fastq paste - - - - | awk '{print $1, length($2)}' | head
```


**Let’s filter on the sequence length, keeping only reads longer than 100 bases. We’d like to output a valid fastq file (that means reversing the paste operation):**
``` bash
<data/HRTMUOC01.RL12.01.fastq paste - - - - | awk 'length($2) >= 100' | tr "\t" "\n" | less
``` 

# Functions in the Shell
Create a function
``` bash
uniqt() { uniq -c | sed -r 's/^ *([0-9]+) /\1\t/' ;}
```

## Exercise 2
### Create a function that will filter fastq file based on the minimum length of the sequence
``` bash
fastq-min-length() { paste - - - - | awk -v min_length="$1" 'length($2) >= min_length' | tr "\t" "\n" ;}
```


### which will be used like this:
``` bash
<data/HRTMUOC01.RL12.01.fastq fastq-min-length 90 > data/filtered.fastq
```

# Bash scripts
``` bash
#!/bin/bash

DATA_DIR="$HOME/unix02_2/data"
FILE_NAME=$1
MAXLEN=$2

INPUT="$DATA_DIR/$FILE_NAME"

echo $INPUT

< $INPUT paste - - - - |
awk -v maxlen="$MAXLEN" 'length($2) < maxlen' |
tr "\t" "\n"
```

``` bash
chmod +x filter_fastq.sh
```

``` bash
./filter_fastq.sh HRTMUOC01.RL12.01.fastq 90 > data/filtered.fastq
```

# R Studio plotting
Data preparation

filter columns we are interested in 
``` bash
< $IN zcat | grep -v '^##' | head -1 | tr "\t" "\n" | nl | grep -e RDS -e KCT -e MWN -e BAG | awk '{print $1}' | paste -sd,
```

