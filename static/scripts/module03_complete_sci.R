#!/usr/bin/env Rscript
# Module 03: Cell Ranger 数据处理可视化
# 生成 SCI 级别的出版质量图表
# 所有图表文字使用英文，符合 SCI 发表要求

# 设置输出目录
output_dir <- "../static/img/tutorial/module03"
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
  "viridis", "scales", "ggsci", "patchwork", "gridExtra"
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
# 图 1: 10x Genomics 工作流程图
# ============================================================================
cat("Generating Figure 1: 10x Genomics workflow\n")

workflow_data <- data.frame(
  step = factor(1:6, levels = 1:6),
  stage = c("Cell Capture", "GEM Generation", "Barcoding", 
            "cDNA Synthesis", "Library Prep", "Sequencing"),
  time = c(10, 15, 20, 30, 45, 60),
  efficiency = c(95, 92, 90, 88, 85, 95)
)

p1 <- ggplot(workflow_data, aes(x = step, y = efficiency, fill = stage)) +
  geom_bar(stat = "identity", width = 0.7, color = "black", linewidth = 0.3) +
  geom_text(aes(label = paste0(efficiency, "%")), 
            vjust = -0.5, size = 3.5, fontface = "bold") +
  scale_fill_npg() +
  scale_y_continuous(limits = c(0, 100), expand = c(0, 0)) +
  labs(
    title = "10x Genomics Workflow Efficiency",
    x = "Workflow Step",
    y = "Efficiency (%)",
    fill = "Stage"
  ) +
  theme_sci() +
  theme(legend.position = "bottom")

ggsave(file.path(output_dir, "01-workflow-efficiency.png"), 
       p1, width = 10, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 01-workflow-efficiency.png\n")

# ============================================================================
# 图 2: FASTQ 文件结构示意图
# ============================================================================
cat("Generating Figure 2: FASTQ file structure\n")

fastq_structure <- data.frame(
  component = factor(c("Cell Barcode", "UMI", "Poly-T", "cDNA"),
                     levels = c("Cell Barcode", "UMI", "Poly-T", "cDNA")),
  length = c(16, 10, 10, 50),
  read = c("Read 1", "Read 1", "Read 1", "Read 2"),
  position = c(1, 17, 27, 1)
)

p2 <- ggplot(fastq_structure, aes(x = component, y = length, fill = read)) +
  geom_bar(stat = "identity", width = 0.6, color = "black", linewidth = 0.3) +
  geom_text(aes(label = paste0(length, " bp")), 
            vjust = -0.5, size = 4, fontface = "bold") +
  scale_fill_manual(values = c("Read 1" = "#E64B35", "Read 2" = "#4DBBD5")) +
  scale_y_continuous(limits = c(0, 60), expand = c(0, 0)) +
  labs(
    title = "FASTQ File Structure",
    x = "Component",
    y = "Length (bp)",
    fill = "Read Type"
  ) +
  theme_sci() +
  theme(legend.position = "top")

ggsave(file.path(output_dir, "02-fastq-structure.png"), 
       p2, width = 8, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 02-fastq-structure.png\n")

# ============================================================================
# 图 3: Cell Ranger 处理流程
# ============================================================================
cat("Generating Figure 3: Cell Ranger pipeline\n")

pipeline_data <- data.frame(
  stage = factor(c("FASTQ Input", "Alignment", "Barcode ID", 
                   "UMI Counting", "Matrix Output"),
                 levels = c("FASTQ Input", "Alignment", "Barcode ID", 
                           "UMI Counting", "Matrix Output")),
  time_min = c(0, 60, 120, 150, 180),
  reads_processed = c(100, 95, 90, 85, 80)
)

p3 <- ggplot(pipeline_data, aes(x = stage, y = reads_processed, group = 1)) +
  geom_line(color = "#00A087", linewidth = 1.5) +
  geom_point(size = 4, color = "#00A087", fill = "white", shape = 21, stroke = 2) +
  geom_text(aes(label = paste0(reads_processed, "%")), 
            vjust = -1.5, size = 3.5, fontface = "bold") +
  scale_y_continuous(limits = c(0, 110), expand = c(0, 0)) +
  labs(
    title = "Cell Ranger Processing Pipeline",
    x = "Pipeline Stage",
    y = "Reads Retained (%)"
  ) +
  theme_sci() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(file.path(output_dir, "03-pipeline-stages.png"), 
       p3, width = 9, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 03-pipeline-stages.png\n")

# ============================================================================
# 图 4: 质量控制指标分布
# ============================================================================
cat("Generating Figure 4: QC metrics distribution\n")

set.seed(123)
qc_data <- data.frame(
  cell_id = 1:500,
  n_genes = rnorm(500, mean = 2000, sd = 500),
  n_umis = rnorm(500, mean = 5000, sd = 1500),
  mito_percent = abs(rnorm(500, mean = 5, sd = 3))
)

qc_data$n_genes[qc_data$n_genes < 0] <- abs(qc_data$n_genes[qc_data$n_genes < 0])
qc_data$n_umis[qc_data$n_umis < 0] <- abs(qc_data$n_umis[qc_data$n_umis < 0])
qc_data$mito_percent[qc_data$mito_percent > 20] <- 20

p4a <- ggplot(qc_data, aes(x = n_genes)) +
  geom_histogram(bins = 30, fill = "#3C5488", color = "black", linewidth = 0.2) +
  geom_vline(xintercept = 500, linetype = "dashed", color = "red", linewidth = 1) +
  labs(x = "Number of Genes", y = "Number of Cells") +
  theme_sci()

p4b <- ggplot(qc_data, aes(x = n_umis)) +
  geom_histogram(bins = 30, fill = "#00A087", color = "black", linewidth = 0.2) +
  geom_vline(xintercept = 1000, linetype = "dashed", color = "red", linewidth = 1) +
  labs(x = "Number of UMIs", y = "Number of Cells") +
  theme_sci()

p4c <- ggplot(qc_data, aes(x = mito_percent)) +
  geom_histogram(bins = 30, fill = "#E64B35", color = "black", linewidth = 0.2) +
  geom_vline(xintercept = 10, linetype = "dashed", color = "red", linewidth = 1) +
  labs(x = "Mitochondrial %", y = "Number of Cells") +
  theme_sci()

p4 <- (p4a | p4b | p4c) +
  plot_annotation(
    title = "Quality Control Metrics Distribution",
    theme = theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5))
  )

ggsave(file.path(output_dir, "04-qc-metrics.png"), 
       p4, width = 14, height = 4.5, dpi = 300, bg = "white")
cat("  ✓ Saved: 04-qc-metrics.png\n")

# ============================================================================
# 图 5: 测序饱和度曲线
# ============================================================================
cat("Generating Figure 5: Sequencing saturation curve\n")

saturation_data <- data.frame(
  reads_millions = seq(10, 100, by = 10),
  saturation = c(30, 45, 55, 62, 68, 72, 75, 77, 78, 79)
)

p5 <- ggplot(saturation_data, aes(x = reads_millions, y = saturation)) +
  geom_line(color = "#4DBBD5", linewidth = 1.5) +
  geom_point(size = 3, color = "#4DBBD5") +
  geom_hline(yintercept = 50, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  geom_hline(yintercept = 80, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  annotate("text", x = 90, y = 52, label = "Minimum", size = 3.5, color = "gray30") +
  annotate("text", x = 90, y = 82, label = "Optimal", size = 3.5, color = "gray30") +
  scale_x_continuous(breaks = seq(10, 100, by = 10)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
  labs(
    title = "Sequencing Saturation Curve",
    x = "Total Reads (Millions)",
    y = "Sequencing Saturation (%)"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "05-saturation-curve.png"), 
       p5, width = 9, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 05-saturation-curve.png\n")

# ============================================================================
# 图 6: 比对率统计
# ============================================================================
cat("Generating Figure 6: Alignment statistics\n")

alignment_data <- data.frame(
  category = factor(c("Mapped to Genome", "Mapped to Transcriptome", 
                      "Confidently Mapped", "Unmapped"),
                    levels = c("Confidently Mapped", "Mapped to Transcriptome", 
                              "Mapped to Genome", "Unmapped")),
  percentage = c(85, 90, 95, 5),
  reads = c(85000000, 90000000, 95000000, 5000000)
)

p6 <- ggplot(alignment_data, aes(x = "", y = percentage, fill = category)) +
  geom_bar(stat = "identity", width = 1, color = "white", linewidth = 1) +
  coord_polar(theta = "y") +
  scale_fill_manual(values = c("#00A087", "#3C5488", "#4DBBD5", "#E64B35")) +
  geom_text(aes(label = paste0(percentage, "%")), 
            position = position_stack(vjust = 0.5), 
            size = 4, fontface = "bold", color = "white") +
  labs(
    title = "Alignment Statistics",
    fill = "Category"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5, color = "black"),
    legend.text = element_text(size = 10, color = "black"),
    legend.title = element_text(size = 11, face = "bold", color = "black"),
    plot.background = element_rect(fill = "white", color = NA)
  )

ggsave(file.path(output_dir, "06-alignment-stats.png"), 
       p6, width = 8, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 06-alignment-stats.png\n")

# ============================================================================
# 图 7: 细胞数量与基因检测关系
# ============================================================================
cat("Generating Figure 7: Cells vs genes detected\n")

set.seed(456)
cell_gene_data <- data.frame(
  n_cells = seq(500, 5000, by = 500),
  n_genes = c(8000, 12000, 15000, 17000, 18500, 19500, 20000, 20300, 20500, 20600)
)

p7 <- ggplot(cell_gene_data, aes(x = n_cells, y = n_genes)) +
  geom_line(color = "#F39B7F", linewidth = 1.5) +
  geom_point(size = 4, color = "#F39B7F", fill = "white", shape = 21, stroke = 2) +
  scale_x_continuous(breaks = seq(500, 5000, by = 500)) +
  scale_y_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(
    title = "Genes Detected vs Number of Cells",
    x = "Number of Cells",
    y = "Total Genes Detected"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "07-cells-vs-genes.png"), 
       p7, width = 9, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 07-cells-vs-genes.png\n")

# ============================================================================
# 图 8: UMI 计数分布
# ============================================================================
cat("Generating Figure 8: UMI counts distribution\n")

set.seed(789)
umi_data <- data.frame(
  cell_id = 1:1000,
  umi_counts = rnbinom(1000, mu = 5000, size = 10)
)

p8 <- ggplot(umi_data, aes(x = umi_counts)) +
  geom_histogram(aes(y = after_stat(density)), bins = 50, 
                 fill = "#8491B4", color = "black", linewidth = 0.2) +
  geom_density(color = "#E64B35", linewidth = 1.5) +
  geom_vline(xintercept = median(umi_data$umi_counts), 
             linetype = "dashed", color = "blue", linewidth = 1) +
  annotate("text", x = median(umi_data$umi_counts) + 1000, 
           y = max(density(umi_data$umi_counts)$y) * 0.8,
           label = paste0("Median: ", round(median(umi_data$umi_counts))),
           size = 4, color = "blue", fontface = "bold") +
  labs(
    title = "UMI Counts Distribution",
    x = "UMI Counts per Cell",
    y = "Density"
  ) +
  theme_sci()

ggsave(file.path(output_dir, "08-umi-distribution.png"), 
       p8, width = 9, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 08-umi-distribution.png\n")

# ============================================================================
# 图 9: 样本比较（多样本质量对比）
# ============================================================================
cat("Generating Figure 9: Multi-sample comparison\n")

sample_comparison <- data.frame(
  sample = rep(c("Sample A", "Sample B", "Sample C", "Sample D"), each = 3),
  metric = rep(c("Cells", "Genes", "UMIs"), 4),
  value = c(
    3000, 18000, 50000,  # Sample A
    3500, 19000, 55000,  # Sample B
    2800, 17000, 48000,  # Sample C
    4000, 20000, 60000   # Sample D
  ),
  normalized = c(
    100, 100, 100,
    117, 106, 110,
    93, 94, 96,
    133, 111, 120
  )
)

p9 <- ggplot(sample_comparison, aes(x = sample, y = normalized, fill = metric)) +
  geom_bar(stat = "identity", position = "dodge", 
           color = "black", linewidth = 0.3, width = 0.7) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "gray50", linewidth = 0.8) +
  scale_fill_npg() +
  scale_y_continuous(limits = c(0, 150), expand = c(0, 0)) +
  labs(
    title = "Multi-Sample Quality Comparison",
    x = "Sample",
    y = "Normalized Value (Sample A = 100%)",
    fill = "Metric"
  ) +
  theme_sci() +
  theme(legend.position = "top")

ggsave(file.path(output_dir, "09-sample-comparison.png"), 
       p9, width = 10, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 09-sample-comparison.png\n")

# ============================================================================
# 图 10: 综合质量报告仪表盘
# ============================================================================
cat("Generating Figure 10: Quality dashboard\n")

# 创建仪表盘数据
dashboard_metrics <- data.frame(
  metric = c("Cells", "Median Genes", "Median UMIs", "Alignment Rate", "Saturation"),
  value = c(3500, 2000, 5000, 92, 75),
  target = c(3000, 1500, 4000, 80, 60),
  status = c("Good", "Good", "Good", "Excellent", "Good")
)

dashboard_metrics$color <- ifelse(dashboard_metrics$value >= dashboard_metrics$target, 
                                   "#00A087", "#E64B35")

p10a <- ggplot(dashboard_metrics, aes(x = metric, y = value, fill = color)) +
  geom_bar(stat = "identity", color = "black", linewidth = 0.3, width = 0.6) +
  geom_hline(yintercept = 0, color = "black", linewidth = 0.5) +
  scale_fill_identity() +
  labs(x = "", y = "Value") +
  theme_sci() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 创建散点图
p10b <- ggplot(qc_data[1:200, ], aes(x = n_umis, y = n_genes, color = mito_percent)) +
  geom_point(size = 2, alpha = 0.6) +
  scale_color_viridis_c(option = "plasma") +
  labs(x = "UMI Counts", y = "Gene Counts", color = "Mito %") +
  theme_sci()

p10 <- (p10a | p10b) +
  plot_annotation(
    title = "Quality Control Dashboard",
    theme = theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5))
  )

ggsave(file.path(output_dir, "10-quality-dashboard.png"), 
       p10, width = 14, height = 6, dpi = 300, bg = "white")
cat("  ✓ Saved: 10-quality-dashboard.png\n")

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
