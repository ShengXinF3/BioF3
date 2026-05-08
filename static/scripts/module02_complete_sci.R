#!/usr/bin/env Rscript
# ============================================================================
# BioF3 Module 02: R and ggplot2 Data Visualization
# Publication-Quality Figures Script
# ============================================================================
# 
# Features:
# 1. All text in English (publication-ready)
# 2. Scientific color schemes (Nature, Science style)
# 3. High-resolution output (300 DPI)
# 4. Professional typography
#
# Usage:
#   Rscript module02_complete_sci.R
#
# ============================================================================

# Set working directory if needed
# setwd("BioF3/scripts")

# Create output directory
output_dir <- "../static/img/tutorial/module02"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
  cat("✓ Created output directory:", output_dir, "\n")
}

# ============================================================================
# Install and load required packages
# ============================================================================

cat("\n=== Checking and installing packages ===\n")

required_packages <- c("ggplot2", "dplyr", "tidyr", "RColorBrewer", 
                       "viridis", "scales", "ggsci", "ComplexHeatmap", "circlize")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing", pkg, "...\n")
    install.packages(pkg, repos = "https://cloud.r-project.org/")
    library(pkg, character.only = TRUE)
  } else {
    cat("✓", pkg, "loaded\n")
  }
}

# Set random seed for reproducibility
set.seed(123)

# ============================================================================
# Define publication-quality theme (SCI style - NO GRID LINES)
# ============================================================================

theme_publication <- function(base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) +
    theme(
      # Text elements
      plot.title = element_text(size = rel(1.2), face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = rel(1), hjust = 0.5),
      axis.title = element_text(size = rel(1), face = "bold"),
      axis.text = element_text(size = rel(0.9), color = "black"),
      legend.title = element_text(size = rel(1), face = "bold"),
      legend.text = element_text(size = rel(0.9)),
      
      # NO GRID LINES - SCI style
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_blank(),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
      
      # Axis
      axis.line = element_line(color = "black", linewidth = 0.5),
      axis.ticks = element_line(color = "black", linewidth = 0.5),
      
      # Legend
      legend.key = element_blank(),
      legend.background = element_blank(),
      legend.position = "right",
      
      # Strip (for facets)
      strip.background = element_rect(fill = "grey95", color = "black"),
      strip.text = element_text(size = rel(1), face = "bold")
    )
}

# Scientific color palettes
# Nature-style colors
nature_colors <- c("#E64B35", "#4DBBD5", "#00A087", "#3C5488", 
                   "#F39B7F", "#8491B4", "#91D1C2", "#DC0000")

# Science-style colors  
science_colors <- c("#3B4992", "#EE0000", "#008B45", "#631879",
                    "#008280", "#BB0021", "#5F559B", "#A20056")

cat("\n=== Generating publication-quality figures ===\n\n")

# ============================================================================
# Figure 1: Bar Plot - Gene Expression Levels
# ============================================================================

cat("Generating Figure 1: Bar plot\n")

gene_data <- data.frame(
  gene = c("Gene1", "Gene2", "Gene3", "Gene4"),
  expression = c(5.2, 3.8, 7.1, 4.5)
)

p1 <- ggplot(gene_data, aes(x = gene, y = expression)) +
  geom_bar(stat = "identity", fill = nature_colors[1], width = 0.7) +
  labs(title = "Gene Expression Levels",
       x = "Gene",
       y = "Expression Level (log2 TPM)") +
  theme_publication() +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 8))

ggsave(file.path(output_dir, "01-bar-plot.png"), 
       plot = p1, width = 6, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 01-bar-plot.png\n")

# ============================================================================
# Figure 2: Scatter Plot - Gene Correlation
# ============================================================================

cat("Generating Figure 2: Scatter plot\n")

set.seed(123)
cell_data <- data.frame(
  cell_id = 1:50,
  gene1 = rnorm(50, mean = 5, sd = 2),
  gene2 = rnorm(50, mean = 6, sd = 1.5)
)

# Calculate correlation
cor_value <- cor(cell_data$gene1, cell_data$gene2)

p2 <- ggplot(cell_data, aes(x = gene1, y = gene2)) +
  geom_point(color = nature_colors[2], size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", color = nature_colors[1], 
              fill = nature_colors[1], alpha = 0.2) +
  labs(title = "Gene Expression Correlation",
       x = "Gene 1 Expression (log2 TPM)",
       y = "Gene 2 Expression (log2 TPM)") +
  annotate("text", x = 2, y = 9, 
           label = sprintf("R = %.2f", cor_value),
           size = 4, fontface = "bold") +
  theme_publication()

ggsave(file.path(output_dir, "02-scatter-plot.png"), 
       plot = p2, width = 6, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 02-scatter-plot.png\n")

# ============================================================================
# Figure 3: Box Plot - Condition Comparison
# ============================================================================

cat("Generating Figure 3: Box plot\n")

set.seed(123)
expression_data <- data.frame(
  condition = rep(c("Control", "Treatment"), each = 30),
  expression = c(rnorm(30, mean = 5, sd = 1),
                 rnorm(30, mean = 7, sd = 1.2))
)

p3 <- ggplot(expression_data, aes(x = condition, y = expression, fill = condition)) +
  geom_boxplot(outlier.shape = 21, outlier.size = 2, width = 0.6) +
  scale_fill_manual(values = c(nature_colors[3], nature_colors[1])) +
  labs(title = "Gene Expression by Condition",
       x = "Experimental Condition",
       y = "Expression Level (log2 TPM)") +
  theme_publication() +
  theme(legend.position = "none")

ggsave(file.path(output_dir, "03-box-plot.png"), 
       plot = p3, width = 6, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 03-box-plot.png\n")

# ============================================================================
# Figure 4: Histogram - Count Distribution
# ============================================================================

cat("Generating Figure 4: Histogram\n")

set.seed(123)
gene_counts <- data.frame(
  counts = rpois(1000, lambda = 10)
)

p4 <- ggplot(gene_counts, aes(x = counts)) +
  geom_histogram(bins = 30, fill = nature_colors[4], 
                 color = "white", alpha = 0.8) +
  labs(title = "Gene Count Distribution",
       x = "Read Count",
       y = "Frequency") +
  theme_publication() +
  scale_y_continuous(expand = c(0, 0))

ggsave(file.path(output_dir, "04-histogram.png"), 
       plot = p4, width = 6, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 04-histogram.png\n")

# ============================================================================
# Figure 5: Violin Plot - Distribution Comparison
# ============================================================================

cat("Generating Figure 5: Violin plot\n")

p5 <- ggplot(expression_data, aes(x = condition, y = expression, fill = condition)) +
  geom_violin(alpha = 0.7, trim = FALSE) +
  geom_boxplot(width = 0.15, fill = "white", outlier.shape = NA) +
  scale_fill_manual(values = c(nature_colors[3], nature_colors[1])) +
  labs(title = "Expression Distribution Comparison",
       x = "Condition",
       y = "Expression Level (log2 TPM)") +
  theme_publication() +
  theme(legend.position = "none")

ggsave(file.path(output_dir, "05-violin-plot.png"), 
       plot = p5, width = 6, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 05-violin-plot.png\n")

# ============================================================================
# Figure 6: Theme Comparison
# ============================================================================

cat("Generating Figure 6: Theme comparison\n")

p_base <- ggplot(gene_data, aes(x = gene, y = expression)) +
  geom_bar(stat = "identity", fill = nature_colors[2], width = 0.7) +
  labs(x = "Gene", y = "Expression Level")

# Create four different themes
p6_pub <- p_base + 
  labs(title = "Publication Theme") +
  theme_publication()

p6_classic <- p_base + 
  labs(title = "Classic Theme") +
  theme_classic(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

p6_minimal <- p_base + 
  labs(title = "Minimal Theme") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

p6_bw <- p_base + 
  labs(title = "Black & White Theme") +
  theme_bw(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# Combine using patchwork if available
if (require("patchwork", quietly = TRUE)) {
  p6_combined <- (p6_pub | p6_classic) / (p6_minimal | p6_bw)
  ggsave(file.path(output_dir, "06-themes-comparison.png"), 
         plot = p6_combined, width = 12, height = 10, dpi = 300, bg = "white")
  cat("  ✓ Saved: 06-themes-comparison.png\n")
} else {
  ggsave(file.path(output_dir, "06-theme-publication.png"), 
         plot = p6_pub, width = 6, height = 5, dpi = 300, bg = "white")
  cat("  ✓ Saved: 06-theme-publication.png\n")
}

# ============================================================================
# Figure 7: Facet Plot - Multi-gene Comparison
# ============================================================================

cat("Generating Figure 7: Facet plot\n")

set.seed(123)
multi_data <- data.frame(
  gene = rep(c("Gene A", "Gene B", "Gene C"), each = 20),
  condition = rep(rep(c("Control", "Treatment"), each = 10), 3),
  expression = c(rnorm(20, 5, 1), rnorm(20, 6, 1), rnorm(20, 7, 1))
)

p7 <- ggplot(multi_data, aes(x = condition, y = expression, fill = condition)) +
  geom_boxplot(width = 0.6, outlier.shape = 21) +
  facet_wrap(~ gene, ncol = 3) +
  scale_fill_manual(values = c(nature_colors[3], nature_colors[1])) +
  labs(title = "Multi-Gene Expression Comparison",
       x = "Condition",
       y = "Expression Level (log2 TPM)",
       fill = "Condition") +
  theme_publication() +
  theme(legend.position = "bottom")

ggsave(file.path(output_dir, "07-facet-plot.png"), 
       plot = p7, width = 10, height = 4, dpi = 300, bg = "white")

cat("  ✓ Saved: 07-facet-plot.png\n")

# ============================================================================
# Practice Project: Gene Expression Analysis
# ============================================================================

cat("\nGenerating practice project figures\n")

# Create simulated data
set.seed(123)
n_genes <- 100
n_samples <- 6

gene_expression <- data.frame(
  gene_id = paste0("Gene_", 1:n_genes),
  control_1 = rpois(n_genes, lambda = 50),
  control_2 = rpois(n_genes, lambda = 50),
  control_3 = rpois(n_genes, lambda = 50),
  treatment_1 = rpois(n_genes, lambda = 75),
  treatment_2 = rpois(n_genes, lambda = 75),
  treatment_3 = rpois(n_genes, lambda = 75)
)

# Data transformation
gene_long <- gene_expression %>%
  pivot_longer(cols = -gene_id, 
               names_to = "sample", 
               values_to = "counts") %>%
  mutate(
    condition = ifelse(grepl("control", sample), "Control", "Treatment")
  )

# Calculate mean expression
gene_summary <- gene_long %>%
  group_by(gene_id, condition) %>%
  summarize(mean_counts = mean(counts), .groups = "drop")

# Identify differentially expressed genes
gene_wide <- gene_summary %>%
  pivot_wider(names_from = condition, values_from = mean_counts) %>%
  mutate(
    fold_change = Treatment / Control,
    log2_fc = log2(fold_change),
    diff_expressed = abs(log2_fc) > 0.5
  )

# ============================================================================
# Figure 8: Expression Distribution (Practice)
# ============================================================================

cat("Generating Figure 8: Expression distribution\n")

p8 <- ggplot(gene_long, aes(x = condition, y = counts, fill = condition)) +
  geom_violin(alpha = 0.7, trim = FALSE) +
  geom_boxplot(width = 0.15, fill = "white", outlier.shape = NA) +
  scale_fill_manual(values = c(nature_colors[3], nature_colors[1])) +
  labs(title = "Gene Expression Distribution",
       x = "Condition",
       y = "Read Count") +
  theme_publication() +
  theme(legend.position = "none") +
  scale_y_continuous(trans = "log10")

ggsave(file.path(output_dir, "08-expression-distribution.png"), 
       plot = p8, width = 6, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 08-expression-distribution.png\n")

# ============================================================================
# Figure 9: Volcano Plot (Practice)
# ============================================================================

cat("Generating Figure 9: Volcano plot\n")

# Add simulated p-values
set.seed(123)
gene_wide$pvalue <- runif(nrow(gene_wide), 0.001, 0.5)
gene_wide$significance <- ifelse(gene_wide$pvalue < 0.05 & abs(gene_wide$log2_fc) > 0.5,
                                 ifelse(gene_wide$log2_fc > 0, "Up", "Down"),
                                 "NS")

p9 <- ggplot(gene_wide, aes(x = log2_fc, y = -log10(pvalue))) +
  geom_point(aes(color = significance), alpha = 0.6, size = 2) +
  scale_color_manual(values = c("Up" = nature_colors[1], 
                                 "Down" = nature_colors[2],
                                 "NS" = "grey70"),
                     labels = c("Up" = "Upregulated", 
                                "Down" = "Downregulated",
                                "NS" = "Not Significant")) +
  geom_vline(xintercept = c(-0.5, 0.5), linetype = "dashed", 
             color = "grey30", size = 0.5) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", 
             color = "grey30", size = 0.5) +
  labs(title = "Volcano Plot of Differential Expression",
       x = expression(Log[2]~Fold~Change),
       y = expression(-Log[10]~P~value),
       color = "Regulation") +
  theme_publication() +
  theme(legend.position = c(0.15, 0.85),
        legend.background = element_rect(fill = "white", color = "black"))

ggsave(file.path(output_dir, "09-volcano-plot.png"), 
       plot = p9, width = 7, height = 6, dpi = 300, bg = "white")

cat("  ✓ Saved: 09-volcano-plot.png\n")

# ============================================================================
# Figure 10: Heatmap using ComplexHeatmap (Practice)
# ============================================================================

cat("Generating Figure 10: ComplexHeatmap\n")

# Prepare data
expr_matrix <- as.matrix(gene_expression[1:20, -1])
rownames(expr_matrix) <- gene_expression$gene_id[1:20]

# Scale by row (z-score)
expr_matrix_scaled <- t(scale(t(expr_matrix)))

# Create annotation
library(ComplexHeatmap)
library(circlize)

# Column annotation
column_ha <- HeatmapAnnotation(
  Condition = c(rep("Control", 3), rep("Treatment", 3)),
  col = list(Condition = c("Control" = nature_colors[3], 
                           "Treatment" = nature_colors[1])),
  annotation_name_side = "left",
  annotation_legend_param = list(
    Condition = list(title = "Condition",
                     title_gp = gpar(fontsize = 10, fontface = "bold"),
                     labels_gp = gpar(fontsize = 9))
  )
)

# Color function
col_fun <- colorRamp2(c(-2, 0, 2), c(nature_colors[2], "white", nature_colors[1]))

# Create heatmap
ht <- Heatmap(
  expr_matrix_scaled,
  name = "Z-score",
  
  # Colors
  col = col_fun,
  
  # Column settings
  top_annotation = column_ha,
  cluster_columns = TRUE,
  show_column_names = TRUE,
  column_names_gp = gpar(fontsize = 9),
  column_names_rot = 45,
  
  # Row settings
  cluster_rows = TRUE,
  show_row_names = TRUE,
  row_names_gp = gpar(fontsize = 8),
  row_names_side = "left",
  
  # Clustering
  clustering_distance_rows = "euclidean",
  clustering_method_rows = "complete",
  clustering_distance_columns = "euclidean",
  clustering_method_columns = "complete",
  
  # Legend
  heatmap_legend_param = list(
    title = "Expression\n(Z-score)",
    title_gp = gpar(fontsize = 10, fontface = "bold"),
    labels_gp = gpar(fontsize = 9),
    legend_height = unit(4, "cm"),
    legend_direction = "vertical"
  ),
  
  # Borders
  border = TRUE,
  rect_gp = gpar(col = "white", lwd = 1),
  
  # Size
  width = unit(6, "cm"),
  height = unit(10, "cm")
)

# Save heatmap
png(file.path(output_dir, "10-heatmap.png"), 
    width = 8, height = 10, units = "in", res = 300)
draw(ht, heatmap_legend_side = "right", annotation_legend_side = "right")
dev.off()

cat("  ✓ Saved: 10-heatmap.png\n")

# ============================================================================
# Completion
# ============================================================================

cat("\n=== All publication-quality figures generated! ===\n")
cat("\nOutput directory:", normalizePath(output_dir), "\n")
cat("\nGenerated figures:\n")
print(list.files(output_dir, pattern = "\\.png$"))

cat("\n✓ Script completed successfully!\n")
cat("✓ Total figures generated:", length(list.files(output_dir, pattern = "\\.png$")), "\n")

# Session info
cat("\n=== Session Information ===\n")
sessionInfo()
