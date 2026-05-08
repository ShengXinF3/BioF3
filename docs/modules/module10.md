---
sidebar_position: 10
---

# 模块10：scATAC-seq 分析

本模块介绍单细胞染色质可及性测序（scATAC-seq）的分析方法。

## 学习目标

- 理解 scATAC-seq 原理
- 处理 scATAC-seq 数据
- Peak calling 和注释
- 转录因子分析
- 整合 RNA 和 ATAC 数据

## scATAC-seq 基础

### 技术原理
- ATAC-seq：Assay for Transposase-Accessible Chromatin
- 检测开放染色质区域
- 识别调控元件

### 应用
- 表观遗传学研究
- 转录因子结合位点
- 增强子识别
- 细胞状态转换

## 使用 ArchR

```r
# 安装 ArchR
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
devtools::install_github("GreenleafLab/ArchR", ref="master", repos = BiocManager::repositories())

library(ArchR)

# 设置线程数
addArchRThreads(threads = 8)

# 创建 Arrow 文件
ArrowFiles <- createArrowFiles(
  inputFiles = "fragments.tsv.gz",
  sampleNames = "sample1",
  minTSS = 4,
  minFrags = 1000,
  addTileMat = TRUE,
  addGeneScoreMat = TRUE
)

# 创建 ArchR 项目
proj <- ArchRProject(
  ArrowFiles = ArrowFiles,
  outputDirectory = "ArchROutput",
  copyArrows = TRUE
)

# 质量控制
proj <- filterDoublets(proj)

# 降维
proj <- addIterativeLSI(proj, useMatrix = "TileMatrix", name = "IterativeLSI")
proj <- addUMAP(proj, reducedDims = "IterativeLSI")

# 聚类
proj <- addClusters(proj, reducedDims = "IterativeLSI")

# 可视化
p1 <- plotEmbedding(proj, colorBy = "cellColData", name = "Clusters")
p1
```

## Peak Calling

```r
# 添加 group coverage
proj <- addGroupCoverages(proj, groupBy = "Clusters")

# Call peaks
proj <- addReproduciblePeakSet(proj, groupBy = "Clusters")

# 添加 peak matrix
proj <- addPeakMatrix(proj)

# 识别标志 peaks
markerPeaks <- getMarkerFeatures(
  ArchRProj = proj,
  useMatrix = "PeakMatrix",
  groupBy = "Clusters"
)

# 可视化
heatmapPeaks <- plotMarkerHeatmap(
  seMarker = markerPeaks,
  cutOff = "FDR <= 0.01 & Log2FC >= 1"
)
```

## 转录因子分析

```r
# 添加 motif 注释
proj <- addMotifAnnotations(proj, motifSet = "cisbp", name = "Motif")

# Motif 富集分析
enrichMotifs <- peakAnnoEnrichment(
  seMarker = markerPeaks,
  ArchRProj = proj,
  peakAnnotation = "Motif",
  cutOff = "FDR <= 0.1 & Log2FC >= 0.5"
)

# 可视化
heatmapEM <- plotEnrichHeatmap(enrichMotifs, n = 7, transpose = TRUE)
```

## 整合 RNA 和 ATAC

```r
# 假设有配对的 RNA 数据
library(Seurat)

# 读取 RNA 数据
rna <- readRDS("rna_seurat.rds")

# 添加 gene scores
proj <- addGeneScoreMatrix(proj)

# 整合
proj <- addGeneIntegrationMatrix(
  ArchRProj = proj,
  useMatrix = "GeneScoreMatrix",
  matrixName = "GeneIntegrationMatrix",
  reducedDims = "IterativeLSI",
  seRNA = rna,
  addToArrow = TRUE,
  groupRNA = "cell_type",
  nameCell = "predictedCell",
  nameGroup = "predictedGroup",
  nameScore = "predictedScore"
)

# 可视化
p1 <- plotEmbedding(proj, colorBy = "cellColData", name = "predictedGroup")
p1
```

## 使用 Signac (Seurat)

```r
library(Signac)
library(Seurat)

# 读取数据
counts <- Read10X_h5("atac_v1_pbmc_10k_filtered_peak_bc_matrix.h5")
metadata <- read.csv("atac_v1_pbmc_10k_singlecell.csv", row.names = 1)
chrom_assay <- CreateChromatinAssay(
  counts = counts,
  sep = c(":", "-"),
  genome = 'hg38',
  fragments = 'atac_v1_pbmc_10k_fragments.tsv.gz',
  min.cells = 10,
  min.features = 200
)

pbmc <- CreateSeuratObject(
  counts = chrom_assay,
  assay = "peaks",
  meta.data = metadata
)

# 质量控制
pbmc <- NucleosomeSignal(object = pbmc)
pbmc <- TSSEnrichment(object = pbmc, fast = FALSE)

# 标准化和降维
pbmc <- RunTFIDF(pbmc)
pbmc <- FindTopFeatures(pbmc, min.cutoff = 'q0')
pbmc <- RunSVD(pbmc)
pbmc <- RunUMAP(pbmc, reduction = 'lsi', dims = 2:30)
pbmc <- FindNeighbors(pbmc, reduction = 'lsi', dims = 2:30)
pbmc <- FindClusters(pbmc, verbose = FALSE, algorithm = 3)

# 可视化
DimPlot(pbmc, label = TRUE) + NoLegend()
```

## 参考资源

- [ArchR](https://www.archrproject.com/)
- [Signac](https://stuartlab.org/signac/)
- [scATAC-seq 最佳实践](https://www.nature.com/articles/s41576-020-0205-x)
