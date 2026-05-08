---
sidebar_position: 9
---

# 模块09：空间转录组学

本模块介绍空间转录组技术和数据分析方法。

## 学习目标

- 理解空间转录组技术
- 分析 10x Visium 数据
- 空间聚类和可视化
- 整合空间和单细胞数据

## 空间转录组技术

### 10x Visium
- 基于芯片的空间转录组
- 55μm spot 大小
- 每个 spot 包含多个细胞

### 其他技术
- Slide-seq
- MERFISH
- seqFISH+
- Stereo-seq

## 使用 Seurat 分析 Visium

```r
library(Seurat)
library(SeuratData)

# 读取 Visium 数据
brain <- Load10X_Spatial(
  data.dir = "filtered_feature_bc_matrix/",
  filename = "filtered_feature_bc_matrix.h5",
  assay = "Spatial",
  slice = "slice1",
  filter.matrix = TRUE,
  to.upper = FALSE,
  image = NULL
)

# 质量控制
plot1 <- VlnPlot(brain, features = "nCount_Spatial", pt.size = 0.1) + NoLegend()
plot2 <- SpatialFeaturePlot(brain, features = "nCount_Spatial") + 
  theme(legend.position = "right")
plot1 + plot2

# 标准化
brain <- SCTransform(brain, assay = "Spatial", verbose = FALSE)

# 降维和聚类
brain <- RunPCA(brain, assay = "SCT", verbose = FALSE)
brain <- FindNeighbors(brain, reduction = "pca", dims = 1:30)
brain <- FindClusters(brain, verbose = FALSE)
brain <- RunUMAP(brain, reduction = "pca", dims = 1:30)

# 空间可视化
SpatialDimPlot(brain, label = TRUE, label.size = 3)

# 基因表达空间分布
SpatialFeaturePlot(brain, features = c("Hpca", "Ttr"))
```

## 空间变异基因

```r
# 识别空间变异基因
brain <- FindSpatiallyVariableFeatures(
  brain,
  assay = "SCT",
  features = VariableFeatures(brain)[1:1000],
  selection.method = "moransi"
)

# 可视化
top_features <- head(SpatiallyVariableFeatures(brain, selection.method = "moransi"), 6)
SpatialFeaturePlot(brain, features = top_features, ncol = 3, alpha = c(0.1, 1))
```

## 细胞类型反卷积

```r
# 使用单细胞参考数据进行反卷积
library(SPOTlight)

# 假设有单细胞参考数据
sc_ref <- readRDS("sc_reference.rds")

# 运行 SPOTlight
spotlight_res <- SPOTlight(
  x = sc_ref,
  y = brain,
  groups = sc_ref$cell_type,
  mgs = marker_genes
)

# 可视化细胞类型分布
plotSpatialScatterpie(
  x = brain,
  y = spotlight_res,
  cell_types = unique(sc_ref$cell_type),
  img = FALSE
)
```

## 使用 Scanpy 分析

```python
import scanpy as sc
import squidpy as sq

# 读取 Visium 数据
adata = sc.read_visium("filtered_feature_bc_matrix/")

# 质量控制
sc.pp.calculate_qc_metrics(adata, inplace=True)
sc.pl.spatial(adata, color="total_counts")

# 标准化
sc.pp.normalize_total(adata, inplace=True)
sc.pp.log1p(adata)
sc.pp.highly_variable_genes(adata, flavor="seurat", n_top_genes=2000)

# 降维和聚类
sc.pp.pca(adata)
sc.pp.neighbors(adata)
sc.tl.umap(adata)
sc.tl.leiden(adata)

# 空间可视化
sc.pl.spatial(adata, color="leiden")

# 空间邻域分析
sq.gr.spatial_neighbors(adata)
sq.gr.nhood_enrichment(adata, cluster_key="leiden")
sq.pl.nhood_enrichment(adata, cluster_key="leiden")
```

## 参考资源

- [10x Visium](https://www.10xgenomics.com/products/spatial-gene-expression)
- [Seurat 空间教程](https://satijalab.org/seurat/articles/spatial_vignette.html)
- [Squidpy](https://squidpy.readthedocs.io/)
