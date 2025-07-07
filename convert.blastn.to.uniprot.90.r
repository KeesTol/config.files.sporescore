library(dplyr)
library(readr)

args <- commandArgs(trailingOnly = TRUE)
blastn_file <- args[1]        # Input: blastn result
mapping_file <- args[2]       # Input: ena-to-uniprot mapping
output_file <- args[3]        # Output: grouped by uniprot

# Load data
blastn <- read_tsv(blastn_file, col_types = cols())
mapping <- read_tsv(mapping_file, col_names = c("uniprot", "ENA"))

# Join on ENA
blastn <- blastn %>%
  inner_join(mapping, by = c("ENA" = "ENA"))

# Group and summarize
blastn_grouped <- blastn %>%
  group_by(uniprot) %>%
  summarize(
    Hits = sum(Hits),
    weight = max(weight),  # assuming weight is same for a uniprot
    WeightedHits = sum(WeightedHits),
    .groups = "drop"
  )

# Save output
write_tsv(blastn_grouped, output_file)

# Print for preview
print(head(blastn_grouped))
