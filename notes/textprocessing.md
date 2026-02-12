# Text processing

## Regular expressions
Match string patterns according to certain rules
``` bash
^A      #Match A at the beginning of line
A$      #Match A at the end of line
[0-9]   #Match numerichal character
[A-Z]   # Match alphabetical character
[ATGC]  # Match A,T,C,G
[^A]    # Match any character except A
. A*    # Match A zero or more times (e.g., "", "A", "AAAA")
A{2}    # Match exactly 2 A's (i.e., "AA")
A{1,} or A+   # Match at least one A
A{1,3}  # Match between 1 and 3 A's
AATT|TTAA  # Match AATT or TTAA (useful for restriction sites)
\d      # Match digit (same as [0-9])
\s      # match whitespacve
\t 
```


| Pattern | Meaning | Example / Note |
|:---|:---|:---|
| `[0-9]` | **interval** | Matches numerical character. |
| `[A-Z]` | **alphabeth** | Matches alphabetical character. |
| `^A` | **Begining of the line** | atch A at the beginning of line |
| `A$` | **End of the line** | Match A at the end of line |
| `[^A]` | **Negation** | Matches any character *except* "A". |
| `.` | **Wildcard** | Matches any single character except a newline. |
| `A*` | **Kleene Star** | Matches "A" **zero or more** times (e.g., "", "A", "AAAA"). |
| `A{2}` | **Exact Quantifier** | Matches exactly 2 "A"s (`AA`). |
| `A{1,}` or `A+` | **One or More** | Matches at least one "A". |
| `A{1,3}` | **Range** | Matches between 1 and 3 "A"s. |
| `AATT\|TTAA` | **Alternation** | Matches "AATT" **OR** "TTAA" (useful for restriction sites). |
| `\d` | **Digit** | Same as `[0-9]`. |
| `\w` | **Word Character** | Matches alphanumeric characters and underscores `[A-Za-z0-9_]`. |
| `\s` | **Whitespace** | Matches spaces, tabs, and newlines (`\n`). |
| `\{` | **Bracket** | Matches bracket { |


``` bash
grep pattern file.txt # Returns lines matching a pattern
grep -v pattern file.txt # Returns lines not matching a pattern
grep -o pattern file.txt # Returns only matching part of lines
grep -E regex file.txt # Extended regular expressions
grep -c pattern file.txt # Returns number of lines matching a pattern
grep -B pattern file.txt # Returns number of lines before a line matching a pattern
man grep # For other options
```

Word count
``` bash
wc file.txt # Returns number of bytes, words and lines
wc -c file.txt # Returns number of bytes (i.e. number of characters incl. \n)
wc -w file.txt # Returns number of words in a file
wc -l file.txt # Returns number of lines in a file
wc -l *.txt # Returns number of lines in all TXT files by file
```

## Exercise 1
### 1. What is the number of SNPs in the VCF file

**View**
View the content of the zipped file
``` bash
< <file.vcf.gz> zcat | less
```
*-N* number the lines \
*-S* unwrapp the lines \
*q* quit

**Remove headder**
Remove lines starting with ## (finding ## with grep and -v as the opposite)
``` bash
< <file.vcf.gz> zcat | grep -v "^##" | less
```

**Remove header and the colnames**
We use # \
To count nuber of lines *wc -l*
``` bash
< <file.vcf.gz> zcat | grep -v "^#" |  wc -l
```


## Retrieve & count unique records
``` bash
# Select columns
cut -f1-3 file.txt
cut -d ',' -f1-3 file.txt
cut --complement -f4 file.txt # exctract all the comolmns expect column 4
```

Extract first three columns from the data (chromosome, position, ID)
```bash 
< <file.vcf.gz> zcat | grep -v "^##" | cut -f1-3 | head
```

Explore variant specific part of data not the sample / genotypes
```bash
< <file.vcf.gz> zcat | grep -v "^##" | cut -f1-9 | less
```
Explore sample part and genotypes from column 10 and more
```bash
< <file.vcf.gz> zcat | grep -v "^##" | cut -f10- | less
```

Count number of columns
```bash
zcat <file.vcf.gz> | grep -v "^##" | head -n 1 | awk '{print NF}'
```



``` bash
# Sorting data based on selected column
sort -k1,1 file.txt
sort -k1,1 -k2,2nr file.txt
sort -k1,3 file.txt
# Retrieve unique records
sort -u file.txt
< file.txt sort | uniq -c
```

Default sorting: alphabeticaly \
Flag n - numeric sorting \
Flag r - reverse sorting \
Flag k - sort by column

**Sort all the variant by the chromosome and then by position, keep first 2 columns**
``` bash
< <file.vcf.gz> zcat | grep -v "^##" | cut -f1-3 | sort -k1,1 -k2,2n
```
-k2,2n - sort by column 2 (position) numerically \
-k2,2nr - sort by column 2 (position) numerically in reverse order \
-k1,1 - sort by column 1 (chromosome) alphabetically \

**Get unique records**
Uniq doesn't work without sorting first, so we need to sort the data first and then get unique records
Count number of variants on the chromosomes
``` bash
< <file.vcf.gz> zcat | grep -v "^##" | cut -f1-3 | sort -k1,1 -k2,2n | uniq -c
```
Flag -c - count the number of times each unique record appears  (get number of varints on the cromosome)\

Analogy - sort -u 

**Get the number of variant in the givenn chromosomes**
```bash
< <file.vcf.gz> zcat | grep -v "^##" | cut -f1 | sort | uniq -c | sort -k1,1nr
```

## Exercise 2
### Get the first six base pairs from every read and calculate prevalence of the these kmers
```bash
cat *.fastq |
grep -E "^[ACGT]+$" |
cut -c1-6 |
sort |
uniq -c |
sort -k1,1nr |
less
```

Select lines that contain only A, C, G, T characters (i.e., DNA sequences).
``` bash
grep -E "^[ACGT]+$" 
```
Extract the first 6 characters from each line (i.e., the first 6 base pairs).
``` bash
cut -c1-6 
```

Sort the extracted 6-mers alphabetically, Count the occurrences of each unique 6-mer and Sort the counted 6-mers in reverse numerical order (most common first).
``` bash
sort | 
uniq -c |
sort -k1,1nr 
```

``` bash
 cat *.fastq | grep -E "^[ACTGN]+$" | cut -c1-6 | sort | uniq -c |sort -k1,1nr > adapters.txt

head adapters.txt
  62954 AAGCAG
   1486 AGCAGT
    589 GCAGTG
    265 CAGTGG
    226 AGTGGT
    180 GTGGTA
     91 AAAGCA
     66 AACAGT
     54 ACAGTG
     48 AAGCAA
```


We can also use two steps grep
``` bash
cat *.fastq | grep -E "^[ACGT]+$" | grep -E -o "^.{6}" | sort | uniq -c | sort -k1,1nr | head
```



## String exctraction and replacement
`tr` (TRansliterate)
- Replaces or deletes individual characters
- Ideal for changing delimiters, removing line endings, uppercase to lowercase conversion

``` bash
tr ";" "\t" file.txt # Replace delimiter
tr -d "\n" file.txt # Remove line ending character
tr "[ATGCN]" "[atgcn]" file.txt # Uppercase to lowercase
```

*\n* is line ending character \
Flag -d - delete characters \
Treats characters separately, so it will replace each character in the first set with the corresponding character in the second set

## Excercise 3
### Exctract the list of samples from the VCF file
``` bash
< <file.vcf.gz> zcat | grep -v "^##" | head -n 1 | cut -f10- | tr "\t" "\n"
```

```bash
user19@ngs-course-2026:~/data$ < luscinia_vars_flags.vcf.gz zcat | grep -v "^##" | head -n 1 | cut -f10- | tr "\t" "\n" | cat -n
     1  lu01
     2  lu03
     3  lu04
     4  lu06
     5  lu08
     6  lu09
     7  lu11
     8  lu13
     9  lu02
    10  lu05
    11  lu07
    12  lu10
    13  lu12
    14  lu14
    15  lu15
```


`sed` (text Stream Editor)
- Matches, replaces and extracts complex patterns
- Useful for extraction of a value according a specific tag from a gff3 or vcf file
- Can match pattern over multiple lines

``` bash
sed 's/pattern/replacement/'
# Remove anything that is not ACGT at the beginning of line
sed 's/^[ACGTN]\{6\}/NNNNNN/'
# The same thing using extended regular expressions
sed -r 's/^[ACGTN]{6}/NNNNNN/'
echo 'AAATTTCCCGGG' | sed -r 's/A+(T+)C+(G+)/\1\2/'
# The result would be 'TTTGGG'
```

Flag -r - use extended regular expressions \

## Exercise 4
### Replace "chr" in the CHROM column
``` bash
< luscinia_vars_flags.vcf.gz zcat | grep -v "^##" | sed -r "s/chr//" | less
```

## Excercise 5
### Retrieve an overall read depth from a VCF file
``` bash
< luscinia_vars_flags.vcf.gz zcat | grep -v "^##" | cut -f8 | sed -r "s/.*DP=([0-9]+);.*/\1/" | head
```
or
``` bash
 < $FILE zcat | grep -o -E 'DP=([0-9]+)' | sed 's/DP=//' | head
```

## Exercise 6
### What is the number of SNPs per chromosome in the VCF file?? ...without using cut command:
``` bash
< $FILE zcat | grep -v "^##" | grep -o -E '^chr[Z0-9]+' | sort | uniq -c | sort -nr
```
or 
``` bash
< $FILE zcat | grep -v "^##" | awk '{print ($1)}' | sort | uniq -c | sort -k2,2 -nr
```

## Exercise 7
### Microsatellites statistics: Extract all AT dinucleotides repeating at least twice and calculate their frequency distribution in the whole dataset.
``` bash
cat *.fastq | grep -E "^[ATCG]+$" | grep -o -E "(AT){2,}" | sort | uniq -c | less -S
 137125 ATAT
  10952 ATATAT
   1159 ATATATAT
    243 ATATATATAT
    122 ATATATATATAT
     61 ATATATATATATAT
     20 ATATATATATATATAT
      6 ATATATATATATATATAT
      2 ATATATATATATATATATAT
```



`grep -o`
- Returns only matching parts of the text
- Useful for extraction of repeating patterns (e.g. microsatellites)
``` bash
# Match AT di-nucleotide twice or more times
grep -o -E "(AT){2,}"
# Match GTC tri-nucleotide twice or more times
grep -o -E "(GTC){2,}"
# Match any repeating pattern
grep -o -E "([ATGC]{1,})\1+"
```

## Exercise 6
### Retrieve an overall read depth from a VCF file with grep -o:
``` bash
user19@ngs-course-2026:~/data$ < luscinia_vars_flags.vcf.gz zcat | grep -v "^#" | grep -o -E "DP=([0-9]+)" | sed s/"DP="// | head
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



## Join and paste data
`join` - Join lines of two files on a common field (e.g., gene ID, chromosome position)
`paste` - Merge lines of files horizontally (side by side)
- align files by a common field (e.g., gene ID, chromosome position)
- no key column is required, but files must be sorted by the join field
- 

``` bash
# Join file1.txt and file2.txt based on 2nd and 3rd column
sort -k2,2 file1.txt > file1.tmp
sort -k3,3 file2.txt > file2.tmp
join -12 -23 file1.tmp file2.tmp > joined-file.txt

# Merge vertically two files
paste file1.txt file2.txt > file-merged.txt

# Transpose file
< filte.txt paste - -
```

## Exercise 7
### Convert FASTQ file to TAB separated file with each read on one line
``` bash
cat *.fastq |
paste - - - - |
cut --complement -f3 \
> reads.tab
```

