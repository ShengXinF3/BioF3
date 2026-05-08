---
sidebar_position: 11
---

# 模块11：选择性多聚腺苷酸化分析

本模块介绍选择性多聚腺苷酸化（Alternative Polyadenylation, APA）在单细胞水平的分析。

## 学习目标

- 理解 APA 的生物学意义
- 识别 APA 位点
- 分析 APA 的细胞类型特异性
- 关联 APA 与基因表达

## APA 基础

### 什么是 APA？

选择性多聚腺苷酸化是指同一基因使用不同的 poly(A) 位点，产生不同长度的 3' UTR。

### 生物学意义

- 调控基因表达
- 影响 mRNA 稳定性
- 调控蛋白质定位
- miRNA 结合位点变化

## 分析工具

### scAPA
- 专门用于单细胞 APA 分析
- 识别差异 APA 事件

### Sierra
- 基于 peak calling
- 识别 APA 位点

## 使用 scAPA

```r
# 安装
devtools::install_github("BMILAB/scAPA")

library(scAPA)

# 准备数据
# 需要 BAM 文件和 GTF 注释

# 识别 APA 位点
apa_sites <- identifyAPAsites(
  bam_file = "possorted_genome_bam.bam",
  gtf_file = "genes.gtf",
  output_dir = "apa_output"
)

# 量化 APA 使用
apa_matrix <- quantifyAPA(
  apa_sites = apa_sites,
  bam_file = "possorted_genome_bam.bam"
)

# 差异 APA 分析
diff_apa <- testDifferentialAPA(
  apa_matrix = apa_matrix,
  cell_types = cell_type_labels
)
```

## 可视化

```r
# 可视化 APA 位点
plotAPAsites(
  gene = "CD44",
  apa_sites = apa_sites,
  cell_types = cell_type_labels
)

# 3' UTR 长度分布
plotUTRlength(
  apa_matrix = apa_matrix,
  cell_types = cell_type_labels
)
```

## 参考资源

- [scAPA](https://github.com/BMILAB/scAPA)
- [APA 综述](https://www.nature.com/articles/nrg.2017.27)
