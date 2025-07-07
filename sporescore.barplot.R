# Load libraries
library(ggplot2)
library(tidyr)
library(dplyr)

# Data with sample names and SporeScores (now including BLASTN90)
sporescore_df <- data.frame(
  Sample = c("Bulk", "Spiked Bulk", "Spore Fraction", "Spiked Spore Fraction"),
  BLASTN = c(0.003011624, 0.003547641, 0.003267393, 0.003174358),
  DIAMONDBLASTX = c(0.002493288, 0.004385605, 0.002019899, 0.004468035),
  IMP3 = c(0.04201282, 0.04431356, 0.04454393, 0.04287023),
  BLASTN90 = c(0.01015231, 0.01826455, 0.01000068, 0.01615766)
)

# Convert Sample to factor with desired order
sporescore_df$Sample <- factor(sporescore_df$Sample,
                               levels = c("Bulk", "Spiked Bulk", "Spore Fraction", "Spiked Spore Fraction"))

# Pivot data to long format
long_df <- sporescore_df %>%
  pivot_longer(cols = -Sample, names_to = "Method", values_to = "SporeScore")

# Define method colors (add color for BLASTN90)
custom_colors <- c(
  "BLASTN" = "#1f77b4",
  "DIAMONDBLASTX" = "#2ca02c",
  "IMP3" = "#ff7f0e",
  "BLASTN90" = "#9467bd"  # purple-ish
)

# Barplot
ggplot(long_df, aes(x = Sample, y = SporeScore, fill = Method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  theme_minimal(base_size = 14) +
  labs(title = "SporeScore by Method", x = "Sample", y = "SporeScore") +
  scale_fill_manual(values = custom_colors) +
  theme(plot.title = element_text(hjust = 0.5))

# Save the plot
ggsave("sporegene_sporescore_comparison_with_blastn90.png", width = 10, height = 6, dpi = 300)
