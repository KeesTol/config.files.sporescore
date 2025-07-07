# --- Libraries ---
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)
library(GGally)

# --- Files ---
gene_ref <- read_tsv("sporegene_id_key.tsv", col_types = cols()) %>%
  rename(uniprot = uniprot, number = number)

blastp <- read_tsv("blastp_final_sporegene_score.trim.s3.tsv", col_types = cols()) %>%
  select(uniprot, Hits) %>%
  rename(IMP3 = Hits)

diamond <- read_tsv("diamond_final_sporegene_hits_score.fastp.s3.tsv", col_types = cols()) %>%
  select(uniprot, Hits) %>%
  rename(DIAMONDBLASTX = Hits)

blastn <- read_tsv("fastp_blastn_s3_uniprot.tsv", col_types = cols()) %>%
  select(uniprot, Hits) %>%
  rename(BLASTN = Hits)

blastn90 <- read_tsv("fastp_blastn_s3_uniprot.90.tsv", col_types = cols()) %>%
  select(uniprot, Hits) %>%
  rename(BLASTN90 = Hits)

# --- Combine ---
combined <- gene_ref %>%
  left_join(blastp, by = "uniprot") %>%
  left_join(diamond, by = "uniprot") %>%
  left_join(blastn, by = "uniprot") %>%
  left_join(blastn90, by = "uniprot") %>%
  mutate(across(c(IMP3, DIAMONDBLASTX, BLASTN, BLASTN90), ~replace_na(., 0))) %>%
  mutate(TotalHits = IMP3 + DIAMONDBLASTX + BLASTN + BLASTN90) %>%
  arrange(desc(TotalHits))
#  slice(-1:-5)  # Remove top 5 most abundant genes

plot_data <- combined %>% select(IMP3, DIAMONDBLASTX, BLASTN, BLASTN90)

# --- Define method colors # color needs to be identical
method_colors <- c(
  "IMP3" = "#ff7f0e",
  "DIAMONDBLASTX" = "#2ca02c",
  "BLASTN" = "#1f77b4",
  "BLASTN (90% DB)" = "#9467bd"  # New purple color
)

# --- Custom lower panel (scatter + smooth with color)
custom_lower <- function(data, mapping, ...) {
  ggplot(data = data, mapping = mapping) +
    geom_point(color = "black", alpha = 0.6, size = 1.5) +
    geom_smooth(method = "lm", color = "grey40", fill = "grey80", alpha = 0.3, size = 0.5)
}

# --- Custom diagonal (colored density)
custom_diag <- function(data, mapping, ...) {
  method <- rlang::as_label(mapping$x)
  col <- method_colors[[method]]
  ggplot(data = data, mapping = mapping) +
    geom_density(fill = col, alpha = 0.4)
}
#rename
plot_data_renamed <- plot_data %>%
  rename(`BLASTN (90% DB)` = BLASTN90)

#ggpairs plot
p <- ggpairs(
  plot_data_renamed,
  upper = list(continuous = wrap("cor", size = 5, method = "spearman")),
  lower = list(continuous = custom_lower),
  diag = list(continuous = custom_diag),
  title = "Spiked Bulk Hit Correlations"
) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    panel.border = element_rect(color = "black", fill = NA),
    strip.background = element_rect(fill = "#f0f0f0"),
    strip.text = element_text(face = "bold")
  )

# --- Show it
p

# --- Save it
ggsave("sporegene_correlation_s3_spearman_colored.BLASTN90.title2.png", plot = p, width = 10, height = 8, dpi = 300)
