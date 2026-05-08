#!/usr/bin/env Rscript
# ============================================================================
# BioF3 Module 01: Jupyter Notebooks and Database Introduction
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
#   Rscript module01_complete_sci.R
#
# ============================================================================

# Create output directory
output_dir <- "../static/img/tutorial/module01"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
  cat("✓ Created output directory:", output_dir, "\n")
}

# ============================================================================
# Install and load required packages
# ============================================================================

cat("\n=== Checking and installing packages ===\n")

required_packages <- c("ggplot2", "dplyr", "tidyr", "RColorBrewer", 
                       "viridis", "scales", "ggsci", "pheatmap", "patchwork")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org/")
  }
  library(pkg, character.only = TRUE)
  cat("✓", pkg, "loaded\n")
}

# ============================================================================
# Define color schemes and theme
# ============================================================================

# Nature journal colors
nature_colors <- c('#E64B35', '#4DBBD5', '#00A087', '#3C5488', 
                   '#F39B7F', '#8491B4', '#91D1C2', '#DC0000')

# Publication theme
theme_publication <- function(base_size = 12) {
  theme_bw(base_size = base_size) +
    theme(
      # Remove background
      panel.background = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      
      # Axis
      axis.line = element_line(color = "black", size = 0.5),
      axis.text = element_text(size = 10, color = "black"),
      axis.title = element_text(size = 12, face = "bold"),
      axis.ticks = element_line(color = "black", size = 0.5),
      
      # Legend
      legend.background = element_blank(),
      legend.key = element_blank(),
      legend.text = element_text(size = 10),
      legend.title = element_text(size = 11, face = "bold"),
      
      # Title
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 11, hjust = 0.5),
      
      # Strip (for facets)
      strip.background = element_rect(fill = "grey90", color = "black"),
      strip.text = element_text(size = 10, face = "bold")
    )
}

cat("\n=== Generating publication-quality figures ===\n\n")

# ============================================================================
# Figure 1: Simple Gene Expression Bar Plot
# ============================================================================

cat("Generating Figure 1: Gene expression bar plot\n")

set.seed(123)
gene_data <- data.frame(
  Gene = paste0("Gene", 1:5),
  Expression = c(5.2, 3.8, 7.1, 2.4, 6.5)
)

p1 <- ggplot(gene_data, aes(x = Gene, y = Expression)) +
  geom_bar(stat = "identity", fill = nature_colors[2], width = 0.7) +
  labs(title = "Gene Expression Levels",
       x = "Gene",
       y = "Expression Level") +
  theme_publication() +
  ylim(0, 8)

ggsave(file.path(output_dir, "01-gene-expression-bar.png"), 
       plot = p1, width = 7, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 01-gene-expression-bar.png\n")

# ============================================================================
# Figure 2: Cell Total Counts Distribution
# ============================================================================

cat("Generating Figure 2: Cell total counts distribution\n")

set.seed(123)
n_cells <- 200
total_counts <- rnorm(n_cells, mean = 5000, sd = 1000)
total_counts <- pmax(total_counts, 0)  # No negative values

counts_df <- data.frame(TotalCounts = total_counts)

p2 <- ggplot(counts_df, aes(x = TotalCounts)) +
  geom_histogram(bins = 30, fill = nature_colors[3], 
                 color = "white", alpha = 0.8) +
  geom_vline(xintercept = mean(total_counts), 
             linetype = "dashed", color = nature_colors[1], size = 1) +
  labs(title = "Distribution of Total Counts per Cell",
       x = "Total Counts",
       y = "Number of Cells") +
  theme_publication() +
  annotate("text", x = mean(total_counts) + 500, y = Inf, 
           label = paste0("Mean = ", round(mean(total_counts))),
           vjust = 2, hjust = 0, size = 4, color = nature_colors[1])

ggsave(file.path(output_dir, "02-cell-counts-distribution.png"), 
       plot = p2, width = 7, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 02-cell-counts-distribution.png\n")

# ============================================================================
# Figure 3: Gene Mean Expression Distribution
# ============================================================================

cat("Generating Figure 3: Gene mean expression distribution\n")

set.seed(123)
n_genes <- 500
gene_means <- rgamma(n_genes, shape = 2, rate = 0.5)

gene_means_df <- data.frame(MeanExpression = gene_means)

p3 <- ggplot(gene_means_df, aes(x = MeanExpression)) +
  geom_histogram(bins = 40, fill = nature_colors[5], 
                 color = "white", alpha = 0.8) +
  labs(title = "Distribution of Mean Gene Expression",
       x = "Mean Expression",
       y = "Number of Genes") +
  theme_publication() +
  scale_x_continuous(limits = c(0, 20))

ggsave(file.path(output_dir, "03-gene-mean-distribution.png"), 
       plot = p3, width = 7, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 03-gene-mean-distribution.png\n")

# ============================================================================
# Figure 4: Expression Matrix Heatmap
# ============================================================================

cat("Generating Figure 4: Expression matrix heatmap\n")

set.seed(123)
n_genes <- 20
n_cells <- 30

# Create expression matrix
expr_matrix <- matrix(rpois(n_genes * n_cells, lambda = 5), 
                      nrow = n_genes, ncol = n_cells)
rownames(expr_matrix) <- paste0("Gene_", 1:n_genes)
colnames(expr_matrix) <- paste0("Cell_", 1:n_cells)

# Log transform
expr_matrix_log <- log1p(expr_matrix)

# Create heatmap
png(file.path(output_dir, "04-expression-matrix-heatmap.png"), 
    width = 8, height = 6, units = "in", res = 300)

pheatmap(expr_matrix_log,
         color = colorRampPalette(c("white", nature_colors[2], nature_colors[1]))(100),
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = TRUE,
         show_colnames = FALSE,
         fontsize = 8,
         fontsize_row = 7,
         main = "Gene Expression Matrix (log scale)",
         border_color = NA)

dev.off()

cat("  ✓ Saved: 04-expression-matrix-heatmap.png\n")

# ============================================================================
# Figure 5: Quality Control Scatter Plot
# ============================================================================

cat("Generating Figure 5: Quality control scatter plot\n")

set.seed(123)
n_cells <- 300

qc_data <- data.frame(
  nGenes = rnorm(n_cells, mean = 2000, sd = 500),
  nCounts = rnorm(n_cells, mean = 5000, sd = 1500),
  CellType = sample(c("Type A", "Type B", "Type C"), n_cells, replace = TRUE)
)

# Ensure positive values
qc_data$nGenes <- pmax(qc_data$nGenes, 500)
qc_data$nCounts <- pmax(qc_data$nCounts, 1000)

p5 <- ggplot(qc_data, aes(x = nGenes, y = nCounts, color = CellType)) +
  geom_point(alpha = 0.6, size = 2) +
  scale_color_manual(values = nature_colors[1:3]) +
  labs(title = "Quality Control: Genes vs Counts",
       x = "Number of Genes Detected",
       y = "Total Counts",
       color = "Cell Type") +
  theme_publication() +
  theme(legend.position = c(0.85, 0.2))

ggsave(file.path(output_dir, "05-qc-scatter.png"), 
       plot = p5, width = 7, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 05-qc-scatter.png\n")

# ============================================================================
# Figure 6: Database Comparison
# ============================================================================

cat("Generating Figure 6: Database comparison\n")

database_data <- data.frame(
  Database = c("GEO", "SCEA", "HCA", "CellxGene", "SRA"),
  Datasets = c(150000, 800, 300, 500, 200000),
  Category = c("General", "Curated", "Atlas", "Interactive", "Raw")
)

database_data$Database <- factor(database_data$Database, 
                                 levels = database_data$Database)

p6 <- ggplot(database_data, aes(x = Database, y = Datasets, fill = Category)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = nature_colors[1:5]) +
  scale_y_log10(labels = scales::comma) +
  labs(title = "Public Database Comparison",
       x = "Database",
       y = "Number of Datasets (log scale)",
       fill = "Type") +
  theme_publication() +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 0))

ggsave(file.path(output_dir, "06-database-comparison.png"), 
       plot = p6, width = 8, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 06-database-comparison.png\n")

# ============================================================================
# Figure 7: Data Analysis Workflow
# ============================================================================

cat("Generating Figure 7: Data analysis workflow\n")

workflow_data <- data.frame(
  Step = factor(c("Download", "QC", "Normalization", "Analysis", "Visualization"),
                levels = c("Download", "QC", "Normalization", "Analysis", "Visualization")),
  Time = c(2, 1, 1.5, 3, 2),
  Complexity = c("Low", "Medium", "Medium", "High", "Medium")
)

p7 <- ggplot(workflow_data, aes(x = Step, y = Time, fill = Complexity)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = c("Low" = nature_colors[3], 
                                "Medium" = nature_colors[2],
                                "High" = nature_colors[1])) +
  labs(title = "Typical Data Analysis Workflow",
       x = "Analysis Step",
       y = "Relative Time (hours)",
       fill = "Complexity") +
  theme_publication() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(output_dir, "07-workflow.png"), 
       plot = p7, width = 8, height = 5, dpi = 300, bg = "white")

cat("  ✓ Saved: 07-workflow.png\n")

# ============================================================================
# Figure 8: Combined QC Metrics
# ============================================================================

cat("Generating Figure 8: Combined QC metrics\n")

set.seed(123)
n_cells <- 200

qc_combined <- data.frame(
  CellID = 1:n_cells,
  nGenes = rnorm(n_cells, mean = 2000, sd = 500),
  nCounts = rnorm(n_cells, mean = 5000, sd = 1500),
  MitoPercent = rbeta(n_cells, 2, 20) * 100
)

# Ensure positive values
qc_combined$nGenes <- pmax(qc_combined$nGenes, 500)
qc_combined$nCounts <- pmax(qc_combined$nCounts, 1000)

# Create three plots
p8a <- ggplot(qc_combined, aes(x = nGenes)) +
  geom_histogram(bins = 30, fill = nature_colors[2], alpha = 0.7) +
  labs(x = "Genes Detected", y = "Cells") +
  theme_publication() +
  theme(axis.title = element_text(size = 10))

p8b <- ggplot(qc_combined, aes(x = nCounts)) +
  geom_histogram(bins = 30, fill = nature_colors[3], alpha = 0.7) +
  labs(x = "Total Counts", y = "Cells") +
  theme_publication() +
  theme(axis.title = element_text(size = 10))

p8c <- ggplot(qc_combined, aes(x = MitoPercent)) +
  geom_histogram(bins = 30, fill = nature_colors[1], alpha = 0.7) +
  labs(x = "Mitochondrial %", y = "Cells") +
  theme_publication() +
  theme(axis.title = element_text(size = 10))

# Combine plots
p8 <- (p8a | p8b | p8c) +
  plot_annotation(title = "Quality Control Metrics Overview",
                  theme = theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5)))

ggsave(file.path(output_dir, "08-qc-combined.png"), 
       plot = p8, width = 12, height = 4, dpi = 300, bg = "white")

cat("  ✓ Saved: 08-qc-combined.png\n")

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
