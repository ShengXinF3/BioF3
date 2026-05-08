#!/usr/bin/env Rscript
# Module 05: 多样本数据整合可视化
# 生成 SCI 级别的出版质量图表
# 所有图表文字使用英文，符合 SCI 发表要求

# 设置输出目录
output_dir <- "../static/img/tutorial/module05"
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
# 图 1: 批次效应来源示意图
# ============================================================================
cat("Generating Figure 1: Batch effect sources\n")

batch_sources <- data.frame(
  category = rep(c("Technical", "Biological"), each = 3),
  source = c("Sequencing Batch", "Operator", "Reagent Lot",
             "Individual", "Tissue Site", "Time Point"),
  impact = c(30, 20, 25, 40, 35, 30)
)

batch_sources$source <- factor(batch_sources$source, 
                                levels = rev(batch_sources$source))

p1 <- ggplot(batch_sources, aes(x = impact, y = source, fill = category)) +
  geom_bar(stat = "identity", color = "black", linewidth = 0.3) +
  scale_fill_manual(values = c("Technical" = "#E64B35", "Biological" = "#4DBBD5")) +
  labs(
    title = "Sources of Batch Effects",
    x = "Relative Impact (%)",
    y = "Source",
    fill = "Category"
  ) +
  theme_sci() +
  theme(legend.position = "top")

ggsave(file.path(output_dir, "01-batch-sources.png"), 
       p1, width = 10, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 01-batch-sources.png\n")

# ============================================================================
# 图 2: 整合方法对比
# ============================================================================
cat("Generating Figure 2: Integration methods comparison\n")

methods <- data.frame(
  method = c("CCA", "Harmony", "scVI", "LIGER", "Combat"),
  speed = c(7, 9, 4, 5, 8),
  accuracy = c(8, 7, 9, 7, 5),
  scalability = c(7, 9, 6, 6, 8)
)

methods_long <- methods %>%
  pivot_longer(cols = c(speed, accuracy, scalability),
               names_to = "metric",
               values_to = "score")

methods_long$metric <- factor(methods_long$metric,
                               levels = c("speed", "accuracy", "scalability"),
                               labels = c("Speed", "Accuracy", "Scalability"))

p2 <- ggplot(methods_long, aes(x = method, y = score, fill = metric)) +
  geom_bar(stat = "identity", position = "dodge", 
           color = "black", linewidth = 0.3, width = 0.7) +
  scale_fill_npg() +
  scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 2)) +
  labs(
    title = "Integration Methods Comparison",
    x = "Method",
    y = "Score (0-10)",
    fill = "Metric"
  ) +
  theme_sci() +
  theme(legend.position = "top")

ggsave(file.path(output_dir, "02-methods-comparison.png"), 
       p2, width = 10, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 02-methods-comparison.png\n")

# ============================================================================
# 图 3: 整合前 UMAP（显示批次效应）
# ============================================================================
cat("Generating Figure 3: UMAP before integration\n")

set.seed(123)
n_cells <- 900
before_data <- data.frame(
  UMAP1 = c(rnorm(300, -3, 1.5), rnorm(300, 0, 1.5), rnorm(300, 3, 1.5)),
  UMAP2 = c(rnorm(300, 2, 1.5), rnorm(300, 0, 1.5), rnorm(300, -2, 1.5)),
  batch = factor(rep(c("Batch 1", "Batch 2", "Batch 3"), each = 300)),
  cell_type = factor(rep(rep(c("T cells", "B cells", "Monocytes"), each = 100), 3))
)

p3 <- ggplot(before_data, aes(x = UMAP1, y = UMAP2, color = batch)) +
  geom_point(size = 1.5, alpha = 0.6) +
  scale_color_npg() +
  labs(
    title = "Before Integration (Batch Effect Visible)",
    x = "UMAP1",
    y = "UMAP2",
    color = "Batch"
  ) +
  theme_sci() +
  theme(legend.position = "right")

ggsave(file.path(output_dir, "03-before-integration.png"), 
       p3, width = 10, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 03-before-integration.png\n")

# ============================================================================
# 图 4: 整合后 UMAP（批次混合）
# ============================================================================
cat("Generating Figure 4: UMAP after integration\n")

set.seed(456)
after_data <- data.frame(
  UMAP1 = c(rnorm(100, -5, 1), rnorm(100, -5, 1), rnorm(100, -5, 1),
            rnorm(100, 0, 1), rnorm(100, 0, 1), rnorm(100, 0, 1),
            rnorm(100, 5, 1), rnorm(100, 5, 1), rnorm(100, 5, 1)),
  UMAP2 = c(rnorm(100, 0, 1), rnorm(100, 0, 1), rnorm(100, 0, 1),
            rnorm(100, 5, 1), rnorm(100, 5, 1), rnorm(100, 5, 1),
            rnorm(100, -5, 1), rnorm(100, -5, 1), rnorm(100, -5, 1)),
  batch = factor(rep(rep(c("Batch 1", "Batch 2", "Batch 3"), each = 100), 3)),
  cell_type = factor(rep(c("T cells", "B cells", "Monocytes"), each = 300))
)

p4 <- ggplot(after_data, aes(x = UMAP1, y = UMAP2, color = batch)) +
  geom_point(size = 1.5, alpha = 0.6) +
  scale_color_npg() +
  labs(
    title = "After Integration (Batches Mixed)",
    x = "UMAP1",
    y = "UMAP2",
    color = "Batch"
  ) +
  theme_sci() +
  theme(legend.position = "right")

ggsave(file.path(output_dir, "04-after-integration.png"), 
       p4, width = 10, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 04-after-integration.png\n")

# ============================================================================
# 图 5: 整合前后对比（并排）
# ============================================================================
cat("Generating Figure 5: Before vs After comparison\n")

p5 <- (p3 + ggtitle("Before Integration")) | 
      (p4 + ggtitle("After Integration"))

p5 <- p5 + plot_annotation(
  title = "Integration Effect Comparison",
  theme = theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5))
)

ggsave(file.path(output_dir, "05-comparison.png"), 
       p5, width = 16, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 05-comparison.png\n")

# ============================================================================
# 图 6: 按细胞类型着色（整合后）
# ============================================================================
cat("Generating Figure 6: Cell types after integration\n")

p6 <- ggplot(after_data, aes(x = UMAP1, y = UMAP2, color = cell_type)) +
  geom_point(size = 1.5, alpha = 0.7) +
  scale_color_manual(values = c("T cells" = "#E64B35", 
                                 "B cells" = "#4DBBD5", 
                                 "Monocytes" = "#00A087")) +
  labs(
    title = "Cell Types After Integration",
    x = "UMAP1",
    y = "UMAP2",
    color = "Cell Type"
  ) +
  theme_sci() +
  theme(legend.position = "right")

ggsave(file.path(output_dir, "06-cell-types.png"), 
       p6, width = 10, height = 7, dpi = 300, bg = "white")
cat("  ✓ Saved: 06-cell-types.png\n")

# ============================================================================
# 图 7: 整合质量评估（LISI 分数）
# ============================================================================
cat("Generating Figure 7: Integration quality (LISI scores)\n")

lisi_data <- data.frame(
  method = c("No Integration", "CCA", "Harmony", "scVI", "LIGER"),
  lisi_score = c(2.8, 1.3, 1.2, 1.1, 1.4),
  bio_conservation = c(100, 85, 80, 90, 82)
)

lisi_data$method <- factor(lisi_data$method, 
                            levels = c("No Integration", "CCA", "Harmony", "scVI", "LIGER"))

p7a <- ggplot(lisi_data, aes(x = method, y = lisi_score, fill = method)) +
  geom_bar(stat = "identity", color = "black", linewidth = 0.3, width = 0.6) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red", linewidth = 1) +
  scale_fill_npg() +
  labs(
    title = "LISI Score (Lower is Better)",
    x = "Method",
    y = "LISI Score"
  ) +
  theme_sci() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

p7b <- ggplot(lisi_data, aes(x = method, y = bio_conservation, fill = method)) +
  geom_bar(stat = "identity", color = "black", linewidth = 0.3, width = 0.6) +
  geom_hline(yintercept = 80, linetype = "dashed", color = "blue", linewidth = 1) +
  scale_fill_npg() +
  scale_y_continuous(limits = c(0, 110)) +
  labs(
    title = "Biological Conservation (%)",
    x = "Method",
    y = "Conservation (%)"
  ) +
  theme_sci() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

p7 <- p7a | p7b

ggsave(file.path(output_dir, "07-quality-metrics.png"), 
       p7, width = 14, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 07-quality-metrics.png\n")

# ============================================================================
# 图 8: 不同方法的整合效果对比
# ============================================================================
cat("Generating Figure 8: Multiple methods comparison\n")

set.seed(789)
methods_comp <- data.frame(
  UMAP1 = rep(c(rnorm(300, -5, 1.2), rnorm(300, 0, 1.2), rnorm(300, 5, 1.2)), 4),
  UMAP2 = rep(c(rnorm(300, 0, 1.2), rnorm(300, 5, 1.2), rnorm(300, -5, 1.2)), 4),
  batch = factor(rep(rep(c("Batch 1", "Batch 2", "Batch 3"), each = 300), 4)),
  method = factor(rep(c("CCA", "Harmony", "scVI", "LIGER"), each = 900))
)

# 添加一些方法特异性的变化
methods_comp$UMAP1[methods_comp$method == "Harmony"] <- 
  methods_comp$UMAP1[methods_comp$method == "Harmony"] * 0.9
methods_comp$UMAP1[methods_comp$method == "scVI"] <- 
  methods_comp$UMAP1[methods_comp$method == "scVI"] * 1.1

p8 <- ggplot(methods_comp, aes(x = UMAP1, y = UMAP2, color = batch)) +
  geom_point(size = 0.8, alpha = 0.5) +
  facet_wrap(~method, nrow = 2) +
  scale_color_npg() +
  labs(
    title = "Integration Methods Comparison",
    x = "UMAP1",
    y = "UMAP2",
    color = "Batch"
  ) +
  theme_sci() +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold"))

ggsave(file.path(output_dir, "08-methods-umap.png"), 
       p8, width = 12, height = 10, dpi = 300, bg = "white")
cat("  ✓ Saved: 08-methods-umap.png\n")

# ============================================================================
# 图 9: 基因表达保留（整合前后）
# ============================================================================
cat("Generating Figure 9: Gene expression preservation\n")

set.seed(111)
gene_expr <- data.frame(
  gene = rep(paste0("Gene", 1:20), 2),
  condition = rep(c("Before", "After"), each = 20),
  batch1 = c(rnorm(20, 5, 2), rnorm(20, 5, 1.5)),
  batch2 = c(rnorm(20, 7, 2), rnorm(20, 5.2, 1.5)),
  batch3 = c(rnorm(20, 4, 2), rnorm(20, 4.8, 1.5))
)

gene_expr_long <- gene_expr %>%
  pivot_longer(cols = starts_with("batch"),
               names_to = "batch",
               values_to = "expression")

gene_expr_long$batch <- factor(gene_expr_long$batch,
                                levels = c("batch1", "batch2", "batch3"),
                                labels = c("Batch 1", "Batch 2", "Batch 3"))

p9 <- ggplot(gene_expr_long, aes(x = gene, y = expression, fill = batch)) +
  geom_boxplot(outlier.size = 0.5) +
  facet_wrap(~condition, nrow = 2) +
  scale_fill_npg() +
  labs(
    title = "Gene Expression Distribution Before and After Integration",
    x = "Gene",
    y = "Expression Level",
    fill = "Batch"
  ) +
  theme_sci() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 8),
        legend.position = "bottom",
        strip.background = element_rect(fill = "gray90", color = "black"),
        strip.text = element_text(face = "bold"))

ggsave(file.path(output_dir, "09-gene-expression.png"), 
       p9, width = 14, height = 8, dpi = 300, bg = "white")
cat("  ✓ Saved: 09-gene-expression.png\n")

# ============================================================================
# 图 10: 整合工作流程
# ============================================================================
cat("Generating Figure 10: Integration workflow\n")

workflow <- data.frame(
  step = 1:7,
  stage = c("Load Data", "QC & Filter", "Normalize", "Find Anchors",
            "Integrate", "Clustering", "Validation"),
  time_min = c(5, 10, 15, 45, 60, 75, 85),
  status = c("Complete", "Complete", "Complete", "Complete", 
             "Complete", "Complete", "Complete")
)

p10 <- ggplot(workflow, aes(x = step, y = time_min)) +
  geom_line(color = "#00A087", linewidth = 1.5) +
  geom_point(size = 5, color = "#00A087", fill = "white", shape = 21, stroke = 2) +
  geom_text(aes(label = stage), vjust = -1.5, size = 3.5, fontface = "bold") +
  scale_x_continuous(breaks = 1:7) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
  labs(
    title = "Data Integration Workflow",
    x = "Workflow Step",
    y = "Cumulative Time (minutes)"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "10-workflow.png"), 
       p10, width = 11, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 10-workflow.png\n")

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
