library(tidyverse)

d <- read_tsv('processed_variants.tsv', col_names=c('CHROM', 'POS', 'ID', 'REF', 'ALT', 'QUAL', 'DP', 'TYPE'))
colnames(d)

# Geom Bar
ggplot(d, aes(x=TYPE)) + 
  geom_bar()

# Log10 scale is normalizing the data
# Boxplot
ggplot(d, aes(x=TYPE, y=QUAL)) + 
  geom_boxplot() + 
  scale_y_log10()

# Histogram
ggplot(d, aes(x=QUAL)) + 
  geom_histogram() + 
  scale_x_log10() + 
  facet_wrap(~TYPE, ncol = 1)

# Filtering the quality
d %>%
  filter(QUAL < 900) %>%
  ggplot(aes(QUAL)) +
  geom_histogram() +
  scale_x_log10() +
  facet_wrap(~TYPE, scales="free_y")