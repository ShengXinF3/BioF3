#!/usr/bin/env Rscript
# Module 04: 质量控制、聚类与细胞类型注释可视化
# 生成 SCI 级别的出版质量图表
# 所有图表文字使用英文，符合 SCI 发表要求

# 设置输出目录
output_dir <- "../static/img/tutorial/module04"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
  cat("✓ Created output directory:", output_dir, "\n\n")
}

# ============================================================================
# 安装和加载必要的包
# ============================================================================
cat("=== Checking and installing packages ===\n")

required_packages <- c(
  "ggplot2", "dplyr", "tidyr", "RColorBrewer", 
  "viridis", "scales", "ggsci", "patchwork", "pheatmap", "ggrepel"
)

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org/")
  }
  library(pkg, character.only = TRUE)
  cat("✓", pkg, "loaded\n")
}

# ============================================================================
# 设置 SCI 出版级别的主题
# ============================================================================
theme_sci <- function() {
  theme_classic() +
    theme(
      text = element_text(family = "sans", size = 12, color = "black"),
      axis.text = element_text(size = 11, color = "black"),
      axis.title = element_text(size = 12, face = "bold", color = "black"),
      plot.title = element_text(size = 13, face = "bold", hjust = 0.5, color = "black"),
      legend.text = element_text(size = 10, color = "black"),
      legend.title = element_text(size = 11, face = "bold", color = "black"),
      axis.line = element_line(color = "black", linewidth = 0.5),
      axis.ticks = element_line(color = "black", linewidth = 0.5),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      legend.background = element_rect(fill = "white", color = NA),
      legend.key = element_rect(fill = "white", color = NA)
    )
}

cat("\n=== Generating publication-quality figures ===\n\n")

# ============================================================================
# 图 1: 分析流程图
# ============================================================================
cat("Generating Figure 1: Analysis workflow\n")

workflow <- data.frame(
  step = 1:8,
  stage = c("Raw Data", "QC Filter", "Normalization", "Feature Selection",
            "PCA", "Clustering", "UMAP", "Annotation"),
  cells_retained = c(100, 95, 95, 95, 95, 95, 95, 95),
  time_min = c(0, 5, 10, 15, 20, 30, 35, 45)
)

p1 <- ggplot(workflow, aes(x = step, y = cells_retained)) +
  geom_line(color = "#00A087", linewidth = 1.5) +
  geom_point(size = 4, color = "#00A087", fill = "white", shape = 21, stroke = 2) +
  geom_text(aes(label = stage), vjust = -1.5, size = 3, fontface = "bold") +
  scale_x_continuous(breaks = 1:8) +
  scale_y_continuous(limits = c(0, 110), breaks = seq(0, 100, by = 20)) +
  labs(
    title = "Single-Cell Analysis Workflow",
    x = "Analysis Step",
    y = "Cells Retained (%)"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "01-workflow.png"), 
       p1, width = 11, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 01-workflow.png\n")

# ============================================================================
# 图 2: QC 指标小提琴图
# ============================================================================
cat("Generating Figure 2: QC metrics violin plots\n")

set.seed(123)
qc_data <- data.frame(
  cell_id = rep(1:800, 3),
  metric = rep(c("nFeature_RNA", "nCount_RNA", "percent.mt"), each = 800),
  value = c(
    rnorm(800, mean = 1500, sd = 500),
    rnorm(800, mean = 4000, sd = 1500),
    abs(rnorm(800, mean = 3, sd = 2))
  )
)

qc_data$value[qc_data$value < 0] <- abs(qc_data$value[qc_data$value < 0])
qc_data$metric <- factor(qc_data$metric, 
                         levels = c("nFeature_RNA", "nCount_RNA", "percent.mt"))

p2 <- ggplot(qc_data, aes(x = metric, y = value, fill = metric)) +
  geom_violin(trim = FALSE, scale = "width", color = "black", linewidth = 0.3) +
  geom_boxplot(width = 0.1, fill = "white", outlier.shape = NA, 
               color = "black", linewidth = 0.5) +
  scale_fill_npg() +
  labs(
    title = "Quality Control Metrics",
    x = "Metric",
    y = "Value"
  ) +
  theme_sci() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(output_dir, "02-qc-violin.png"), 
       p2, width = 9, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 02-qc-violin.png\n")

# ============================================================================
# 图 3: QC 散点图（过滤前后对比）
# ============================================================================
cat("Generating Figure 3: QC scatter plots\n")

set.seed(456)
scatter_data <- data.frame(
  n_counts = abs(rnorm(1000, mean = 4000, sd = 2000)),
  n_genes = abs(rnorm(1000, mean = 1500, sd = 600)),
  mito_pct = abs(rnorm(1000, mean = 4, sd = 3))
)

scatter_data$pass_qc <- scatter_data$n_genes > 200 & 
                        scatter_data$n_genes < 2500 & 
                        scatter_data$mito_pct < 5

p3a <- ggplot(scatter_data, aes(x = n_counts, y = n_genes, color = pass_qc)) +
  geom_point(size = 1.5, alpha = 0.6) +
  geom_hline(yintercept = 200, linetype = "dashed", color = "red", linewidth = 0.8) +
  geom_hline(yintercept = 2500, linetype = "dashed", color = "red", linewidth = 0.8) +
  scale_color_manual(values = c("FALSE" = "#E64B35", "TRUE" = "#00A087"),
                     labels = c("Filtered", "Retained")) +
  labs(x = "UMI Counts", y = "Gene Counts", color = "QC Status") +
  theme_sci()

p3b <- ggplot(scatter_data, aes(x = n_counts, y = mito_pct, color = pass_qc)) +
  geom_point(size = 1.5, alpha = 0.6) +
  geom_hline(yintercept = 5, linetype = "dashed", color = "red", linewidth = 0.8) +
  scale_color_manual(values = c("FALSE" = "#E64B35", "TRUE" = "#00A087"),
                     labels = c("Filtered", "Retained")) +
  labs(x = "UMI Counts", y = "Mitochondrial %", color = "QC Status") +
  theme_sci()

p3 <- (p3a | p3b) +
  plot_annotation(
    title = "Quality Control Filtering",
    theme = theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5))
  )

ggsave(file.path(output_dir, "03-qc-scatter.png"), 
       p3, width = 14, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 03-qc-scatter.png\n")

# ============================================================================
# 图 4: 高变异基因
# ============================================================================
cat("Generating Figure 4: Highly variable genes\n")

set.seed(789)
hvg_data <- data.frame(
  gene = paste0("Gene", 1:2000),
  mean_expression = 10^runif(2000, -2, 2),
  variance = 10^runif(2000, -2, 3)
)

hvg_data$dispersion <- hvg_data$variance / hvg_data$mean_expression
hvg_data$highly_variable <- hvg_data$dispersion > quantile(hvg_data$dispersion, 0.9)

top_genes <- hvg_data %>% 
  filter(highly_variable) %>% 
  arrange(desc(dispersion)) %>% 
  head(10)

p4 <- ggplot(hvg_data, aes(x = mean_expression, y = dispersion, color = highly_variable)) +
  geom_point(size = 1.5, alpha = 0.5) +
  geom_text_repel(data = top_genes, aes(label = gene), 
                  size = 3, fontface = "bold", max.overlaps = 20) +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_manual(values = c("FALSE" = "gray70", "TRUE" = "#E64B35"),
                     labels = c("Other Genes", "Highly Variable")) +
  labs(
    title = "Highly Variable Genes Selection",
    x = "Mean Expression (log10)",
    y = "Dispersion (log10)",
    color = "Gene Type"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "04-hvg.png"), 
       p4, width = 10, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 04-hvg.png\n")

# ============================================================================
# 图 5: PCA 方差解释图（Elbow Plot）
# ============================================================================
cat("Generating Figure 5: PCA elbow plot\n")

pca_variance <- data.frame(
  PC = 1:50,
  variance = exp(-seq(0.1, 5, length.out = 50)) * 100
)

p5 <- ggplot(pca_variance, aes(x = PC, y = variance)) +
  geom_line(color = "#4DBBD5", linewidth = 1.5) +
  geom_point(size = 2, color = "#4DBBD5") +
  geom_vline(xintercept = 20, linetype = "dashed", color = "red", linewidth = 1) +
  annotate("text", x = 25, y = 80, label = "Selected: 20 PCs", 
           size = 4, color = "red", fontface = "bold") +
  scale_x_continuous(breaks = seq(0, 50, by = 5)) +
  labs(
    title = "PCA Variance Explained (Elbow Plot)",
    x = "Principal Component",
    y = "Variance Explained (%)"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "05-pca-elbow.png"), 
       p5, width = 10, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 05-pca-elbow.png\n")

# ============================================================================
# 图 6: PCA 散点图
# ============================================================================
cat("Generating Figure 6: PCA scatter plot\n")

set.seed(111)
pca_data <- data.frame(
  PC1 = rnorm(500, mean = 0, sd = 2),
  PC2 = rnorm(500, mean = 0, sd = 1.5),
  cluster = factor(sample(1:5, 500, replace = TRUE))
)

p6 <- ggplot(pca_data, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 2, alpha = 0.7) +
  scale_color_npg() +
  labs(
    title = "PCA Visualization",
    x = "PC1",
    y = "PC2",
    color = "Cluster"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "06-pca-plot.png"), 
       p6, width = 9, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 06-pca-plot.png\n")

# ============================================================================
# 图 7: UMAP 聚类图
# ============================================================================
cat("Generating Figure 7: UMAP clustering\n")

set.seed(222)
n_cells <- 600
umap_data <- data.frame(
  UMAP1 = c(rnorm(100, -5, 1), rnorm(100, 5, 1), rnorm(100, 0, 1),
            rnorm(100, -3, 1.5), rnorm(100, 3, 1.5), rnorm(100, 0, 2)),
  UMAP2 = c(rnorm(100, 5, 1), rnorm(100, 5, 1), rnorm(100, -5, 1),
            rnorm(100, 0, 1), rnorm(100, 0, 1), rnorm(100, 2, 1.5)),
  cluster = factor(rep(0:5, each = 100))
)

cluster_centers <- umap_data %>%
  group_by(cluster) %>%
  summarise(UMAP1 = mean(UMAP1), UMAP2 = mean(UMAP2))

p7 <- ggplot(umap_data, aes(x = UMAP1, y = UMAP2, color = cluster)) +
  geom_point(size = 1.5, alpha = 0.7) +
  geom_text(data = cluster_centers, aes(label = cluster), 
            size = 6, fontface = "bold", color = "black") +
  scale_color_npg() +
  labs(
    title = "UMAP Clustering",
    x = "UMAP1",
    y = "UMAP2",
    color = "Cluster"
  ) +
  theme_sci() +
  theme(legend.position = "right")

ggsave(file.path(output_dir, "07-umap-clusters.png"), 
       p7, width = 10, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 07-umap-clusters.png\n")

# ============================================================================
# 图 8: UMAP 基因表达图
# ============================================================================
cat("Generating Figure 8: UMAP gene expression\n")

umap_data$CD3D <- abs(rnorm(n_cells, mean = ifelse(umap_data$cluster %in% c(0, 1), 2, 0), sd = 0.5))
umap_data$CD14 <- abs(rnorm(n_cells, mean = ifelse(umap_data$cluster == 2, 2, 0), sd = 0.5))
umap_data$MS4A1 <- abs(rnorm(n_cells, mean = ifelse(umap_data$cluster == 3, 2, 0), sd = 0.5))
umap_data$NKG7 <- abs(rnorm(n_cells, mean = ifelse(umap_data$cluster == 4, 2, 0), sd = 0.5))

p8a <- ggplot(umap_data, aes(x = UMAP1, y = UMAP2, color = CD3D)) +
  geom_point(size = 1.5, alpha = 0.8) +
  scale_color_viridis_c(option = "plasma") +
  labs(title = "CD3D (T cells)", x = "UMAP1", y = "UMAP2", color = "Expression") +
  theme_sci() +
  theme(legend.position = "right")

p8b <- ggplot(umap_data, aes(x = UMAP1, y = UMAP2, color = CD14)) +
  geom_point(size = 1.5, alpha = 0.8) +
  scale_color_viridis_c(option = "plasma") +
  labs(title = "CD14 (Monocytes)", x = "UMAP1", y = "UMAP2", color = "Expression") +
  theme_sci() +
  theme(legend.position = "right")

p8c <- ggplot(umap_data, aes(x = UMAP1, y = UMAP2, color = MS4A1)) +
  geom_point(size = 1.5, alpha = 0.8) +
  scale_color_viridis_c(option = "plasma") +
  labs(title = "MS4A1 (B cells)", x = "UMAP1", y = "UMAP2", color = "Expression") +
  theme_sci() +
  theme(legend.position = "right")

p8d <- ggplot(umap_data, aes(x = UMAP1, y = UMAP2, color = NKG7)) +
  geom_point(size = 1.5, alpha = 0.8) +
  scale_color_viridis_c(option = "plasma") +
  labs(title = "NKG7 (NK cells)", x = "UMAP1", y = "UMAP2", color = "Expression") +
  theme_sci() +
  theme(legend.position = "right")

p8 <- (p8a | p8b) / (p8c | p8d) +
  plot_annotation(
    title = "Marker Gene Expression on UMAP",
    theme = theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5))
  )

ggsave(file.path(output_dir, "08-umap-genes.png"), 
       p8, width = 14, height = 12, dpi = 300, bg = "white")
cat("  ✓ Saved: 08-umap-genes.png\n")

# ============================================================================
# 图 9: 细胞类型注释 UMAP
# ============================================================================
cat("Generating Figure 9: Cell type annotation\n")

cell_types <- c("CD4+ T", "CD8+ T", "Monocytes", "B cells", "NK cells", "DC")
umap_data$cell_type <- factor(cell_types[as.numeric(umap_data$cluster) + 1],
                               levels = cell_types)

type_centers <- umap_data %>%
  group_by(cell_type) %>%
  summarise(UMAP1 = mean(UMAP1), UMAP2 = mean(UMAP2))

p9 <- ggplot(umap_data, aes(x = UMAP1, y = UMAP2, color = cell_type)) +
  geom_point(size = 1.5, alpha = 0.7) +
  geom_text(data = type_centers, aes(label = cell_type), 
            size = 4, fontface = "bold", color = "black",
            box.padding = 0.5) +
  scale_color_npg() +
  labs(
    title = "Cell Type Annotation",
    x = "UMAP1",
    y = "UMAP2",
    color = "Cell Type"
  ) +
  theme_sci() +
  theme(legend.position = "right")

ggsave(file.path(output_dir, "09-cell-types.png"), 
       p9, width = 11, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 09-cell-types.png\n")

# ============================================================================
# 图 10: 标志基因热图
# ============================================================================
cat("Generating Figure 10: Marker genes heatmap\n")

set.seed(333)
genes <- c("IL7R", "CD4", "CD8A", "CD8B", "MS4A1", "CD79A", 
           "CD14", "LYZ", "GNLY", "NKG7", "FCER1A", "CST3")
clusters <- paste0("C", 0:5)

heatmap_data <- matrix(rnorm(length(genes) * length(clusters), mean = 0, sd = 1),
                       nrow = length(genes), ncol = length(clusters))
rownames(heatmap_data) <- genes
colnames(heatmap_data) <- clusters

# 添加一些模式
heatmap_data[1:2, 1] <- heatmap_data[1:2, 1] + 2  # CD4+ T
heatmap_data[3:4, 2] <- heatmap_data[3:4, 2] + 2  # CD8+ T
heatmap_data[5:6, 3] <- heatmap_data[5:6, 3] + 2  # B cells
heatmap_data[7:8, 4] <- heatmap_data[7:8, 4] + 2  # Monocytes
heatmap_data[9:10, 5] <- heatmap_data[9:10, 5] + 2  # NK cells
heatmap_data[11:12, 6] <- heatmap_data[11:12, 6] + 2  # DC

png(file.path(output_dir, "10-marker-heatmap.png"), 
    width = 10, height = 8, units = "in", res = 300, bg = "white")

par(mar = c(2, 2, 2, 2))
pheatmap(heatmap_data,
         color = colorRampPalette(c("#3C5488", "white", "#E64B35"))(100),
         cluster_rows = FALSE,
         cluster_cols = FALSE,
         fontsize = 12,
         fontsize_row = 11,
         fontsize_col = 11,
         border_color = "gray80",
         main = "Marker Genes Expression Heatmap",
         angle_col = 0,
         cellwidth = 40,
         cellheight = 25,
         padding = unit(c(2, 2, 2, 2), "mm"))

dev.off()
cat("  ✓ Saved: 10-marker-heatmap.png\n")

# ============================================================================
# 完成
# ============================================================================
cat("\n=== All publication-quality figures generated! ===\n\n")
cat("Output directory:", normalizePath(output_dir), "\n")
cat("Generated figures:\n")
list.files(output_dir, pattern = "\\.png$")

cat("\n✓ Script completed successfully!\n")
cat("✓ Total figures generated: 10\n\n")

# 显示会话信息
cat("=== Session Information ===\n")
sessionInfo()
