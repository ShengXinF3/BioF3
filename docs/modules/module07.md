---
sidebar_position: 7
---

# 模块07：多模态数据分析

本模块介绍如何整合和分析多模态单细胞数据，包括 CITE-seq、ASAP-seq 等技术。

## 学习目标

- 理解多模态单细胞技术
- 整合 RNA 和蛋白质数据
- 整合 RNA 和 ATAC 数据
- 多模态数据可视化

## 多模态技术概览

### CITE-seq
- 同时测量 RNA 和表面蛋白
- 使用抗体偶联寡核苷酸标签

### ASAP-seq  
- 同时测量 RNA 和染色质可及性
- 结合 scRNA-seq 和 scATAC-seq

### 10x Multiome
- 官方多组学平台
- RNA + ATAC 同时测量

## 使用 Seurat 分析 CITE-seq

```r
library(Seurat)

# 读取数据
cbmc <- Read10X("filtered_feature_bc_matrix/")

# 创建对象（包含 RNA 和 ADT）
cbmc <- CreateSeuratObject(counts = cbmc$`Gene Expression`)
cbmc[["ADT"]] <- CreateAssayObject(counts = cbmc$`Antibody Capture`)

# RNA 分析
DefaultAssay(cbmc) <- "RNA"
cbmc <- NormalizeData(cbmc)
cbmc <- FindVariableFeatures(cbmc)
cbmc <- ScaleData(cbmc)
cbmc <- RunPCA(cbmc)

# ADT 分析
DefaultAssay(cbmc) <- "ADT"
cbmc <- NormalizeData(cbmc, normalization.method = "CLR", margin = 2)
cbmc <- ScaleData(cbmc)
cbmc <- RunPCA(cbmc, reduction.name = "apca")

# 加权最近邻（WNN）分析
cbmc <- FindMultiModalNeighbors(
  cbmc, 
  reduction.list = list("pca", "apca"),
  dims.list = list(1:30, 1:18)
)

cbmc <- RunUMAP(cbmc, nn.name = "weighted.nn", reduction.name = "wnn.umap")
cbmc <- FindClusters(cbmc, graph.name = "wsnn", resolution = 0.5)

# 可视化
DimPlot(cbmc, reduction = "wnn.umap", label = TRUE)
```

## 参考资源

- [Seurat 多模态教程](https://satijalab.org/seurat/articles/multimodal_vignette.html)
- [CITE-seq 协议](https://cite-seq.com/)
