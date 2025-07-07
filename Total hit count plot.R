# Load libraries
library(ggplot2)
library(dplyr)
library(readr)
library(patchwork)

# Load key file
key <- read_tsv("sporegene_id_key.tsv")

# Define method colors (exactly as before)
method_colors <- c("BLASTN" = "#1f77b4", "DIAMONDBLASTX" = "#2ca02c", "IMP3" = "#ff7f0e", "BLASTN90" = "#9467bd")

# Function to load and prepare data
load_and_prepare <- function(file, method_name) {
  read_tsv(file) %>%
    left_join(key, by = "uniprot") %>%
    mutate(Method = method_name)
}

# Load datasets using original file names but renaming BLASTP → IMP3
df_blastp     <- load_and_prepare("blastp_final_sporegene_score.trim.s3.tsv", "IMP3")
df_diamond    <- load_and_prepare("diamond_final_sporegene_hits_score.fastp.s3.tsv", "DIAMONDBLASTX")
df_blastn     <- load_and_prepare("fastp_blastn_s3_uniprot.tsv", "BLASTN")
df_blastn90   <- load_and_prepare("fastp_blastn_s3_uniprot.90.tsv", "BLASTN90")

# Plotting function
plot_method <- function(df) {
  method_name <- unique(df$Method)
  ggplot(df, aes(x = number, y = Hits)) +
    geom_bar(stat = "identity", fill = method_colors[method_name]) +
    theme_minimal(base_size = 14) +
    labs(
      title = method_name,
      x = "Sporegene (Fixed Number)",
      y = "Hits"
    ) +
    scale_x_continuous(breaks = 1:65) +  # Force all 65 x-axis ticks
    theme(
      plot.title = element_text(hjust = 0.5),
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)  # Optional: rotate labels for readability
    )
}


# Create individual plots
p1 <- plot_method(df_blastn)
p2 <- plot_method(df_diamond)
p3 <- plot_method(df_blastp)
p4 <- plot_method(df_blastn90)

# Combine vertically
combined_plot <- p1 / p2 / p3 / p4 +
  plot_layout(guides = "collect") &
  theme(legend.position = "none")

# Preview first
combined_plot

# Then save when ready
ggsave("sporegene_hits_all_methods.HitsOnly.colored4.png", plot = combined_plot, width = 10, height = 12, dpi = 300)
