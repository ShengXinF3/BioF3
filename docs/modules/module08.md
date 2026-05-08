---
sidebar_position: 8
---

# 模块08：TCR/BCR 测序分析

本模块介绍 T 细胞受体（TCR）和 B 细胞受体（BCR）的单细胞测序分析。

## 学习目标

- 理解 TCR/BCR 测序原理
- 分析克隆扩增
- 识别克隆型
- 整合 TCR 和转录组数据

## TCR/BCR 基础

### TCR 结构
- α链和β链
- CDR3 区域：高度可变
- V(D)J 重组

### 应用场景
- 免疫应答研究
- 肿瘤免疫治疗
- 自身免疫疾病

## 使用 Cell Ranger VDJ

```bash
# 运行 VDJ 分析
cellranger vdj \
  --id=sample_tcr \
  --reference=refdata-cellranger-vdj-GRCh38-alts-ensembl-7.0.0 \
  --fastqs=/path/to/fastqs \
  --sample=sample_name
```

## 使用 Seurat 整合

```r
library(Seurat)

# 读取 GEX 数据
gex <- Read10X("filtered_feature_bc_matrix/")
seurat_obj <- CreateSeuratObject(gex)

# 读取 TCR 数据
tcr <- read.csv("filtered_contig_annotations.csv")

# 提取克隆信息
clonotypes <- tcr %>%
  group_by(barcode) %>%
  summarise(
    clonotype_id = first(raw_clonotype_id),
    cdr3 = paste(cdr3, collapse = ";")
  )

# 添加到 Seurat 对象
seurat_obj <- AddMetaData(seurat_obj, clonotypes)

# 可视化克隆扩增
DimPlot(seurat_obj, group.by = "clonotype_id")
```

## 使用 scRepertoire

```r
library(scRepertoire)

# 读取 TCR 数据
tcr_list <- list(
  sample1 = read.csv("sample1/filtered_contig_annotations.csv"),
  sample2 = read.csv("sample2/filtered_contig_annotations.csv")
)

# 合并克隆型
combined <- combineTCR(tcr_list, 
                       samples = c("S1", "S2"),
                       ID = c("P1", "P1"))

# 可视化克隆多样性
clonalDiversity(combined, cloneCall = "gene")

# 克隆扩增分析
clonalHomeostasis(combined, cloneCall = "gene")

# 整合到 Seurat
seurat_obj <- combineExpression(combined, seurat_obj)
```

## 参考资源

- [Cell Ranger VDJ](https://support.10xgenomics.com/single-cell-vdj)
- [scRepertoire](https://github.com/ncborcherding/scRepertoire)
