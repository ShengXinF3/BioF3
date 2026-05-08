---
sidebar_position: 1
---

import DownloadButton from '@site/src/components/DownloadButton';

# 模块01：实践数据集与数据获取

BioF3 的教程需要配套真实数据，不能只依赖模拟数据和示意代码。本页整理适合教学复现的公开测试数据集，并给出建议使用场景、下载命令和数据规模。

所有数据都来自公开资源，建议下载到项目外的本地数据目录，例如 `~/biof3-data`，不要直接提交到网站仓库。

```bash
mkdir -p ~/biof3-data
cd ~/biof3-data
```

## 推荐数据集

| 数据集 | 适用模块 | 类型 | 大小 | 用途 |
| --- | --- | --- | --- | --- |
| PBMC 3k | 模块 02-06 | scRNA-seq | 约 7.4 MB | 入门、质控、聚类、注释、差异分析 |
| 5k PBMC CITE-seq | 模块 07 | RNA + ADT | 约 37 MB | 多模态分析、WNN、蛋白标志物 |
| PBMC scATAC 10k | 模块 10 | scATAC-seq | 约 162 MB | 染色质可及性、LSI、peak matrix |
| Visium Breast Cancer | 模块 09 | 空间转录组 | 约 74 MB | 空间表达、组织切片可视化 |

## PBMC 3k

PBMC 3k 是 10x Genomics 公开的外周血单个核细胞数据，也是 Seurat 和 Scanpy 入门教程常用数据。它体积小、下载快，适合本教程前半部分的大多数练习。

<DownloadButton
  fileUrl="https://cf.10xgenomics.com/samples/cell-exp/1.1.0/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz"
  fileName="pbmc3k_filtered_gene_bc_matrices.tar.gz"
  fileSize="7.3 MB"
>
  下载 PBMC 3k 数据
</DownloadButton>

适用模块：

- [模块02：原始数据处理与 Cell Ranger](/docs/modules/module02)
- [模块03：质量控制、聚类与细胞类型注释](/docs/modules/module03)
- [模块05：轨迹推断与拟时序分析](/docs/modules/module05)
- [模块06：细胞-细胞通讯分析](/docs/modules/module06)

上方按钮会直接从 10x Genomics 原始地址下载。也可以使用命令行下载：

```bash
mkdir -p ~/biof3-data/pbmc3k
cd ~/biof3-data/pbmc3k

curl -L -O https://cf.10xgenomics.com/samples/cell-exp/1.1.0/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz
tar -xzf pbmc3k_filtered_gene_bc_matrices.tar.gz
```

Seurat 读取示例：

```r
library(Seurat)

data_dir <- "~/biof3-data/pbmc3k/filtered_gene_bc_matrices/hg19"
counts <- Read10X(data.dir = data_dir)
pbmc <- CreateSeuratObject(counts = counts, project = "PBMC3K")
pbmc
```

## 5k PBMC CITE-seq

5k PBMC CITE-seq 数据同时包含 RNA 表达矩阵和抗体衍生标签（ADT）矩阵，适合讲解多模态单细胞分析。

<DownloadButton
  fileUrl="https://cf.10xgenomics.com/samples/cell-exp/3.1.0/5k_pbmc_protein_v3_nextgem/5k_pbmc_protein_v3_nextgem_filtered_feature_bc_matrix.tar.gz"
  fileName="5k_pbmc_protein_v3_nextgem_filtered_feature_bc_matrix.tar.gz"
  fileSize="37 MB"
>
  下载 5k PBMC CITE-seq 数据
</DownloadButton>

适用模块：

- [模块07：多模态单细胞分析](/docs/modules/module07)

上方按钮会直接从 10x Genomics 原始地址下载。也可以使用命令行下载：

```bash
mkdir -p ~/biof3-data/pbmc5k-citeseq
cd ~/biof3-data/pbmc5k-citeseq

curl -L -O https://cf.10xgenomics.com/samples/cell-exp/3.1.0/5k_pbmc_protein_v3_nextgem/5k_pbmc_protein_v3_nextgem_filtered_feature_bc_matrix.tar.gz
tar -xzf 5k_pbmc_protein_v3_nextgem_filtered_feature_bc_matrix.tar.gz
```

Seurat 读取示例：

```r
library(Seurat)

data_dir <- "~/biof3-data/pbmc5k-citeseq/filtered_feature_bc_matrix"
counts <- Read10X(data.dir = data_dir)

pbmc <- CreateSeuratObject(counts = counts$`Gene Expression`, project = "PBMC5K_CITE")
pbmc[["ADT"]] <- CreateAssayObject(counts = counts$`Antibody Capture`)
pbmc
```

## Visium Breast Cancer

Visium Breast Cancer 是 10x Genomics 的空间转录组数据，适合练习组织切片上的空间表达可视化和空间邻域分析。

<DownloadButton
  fileUrl="https://cf.10xgenomics.com/samples/spatial-exp/1.1.0/V1_Breast_Cancer_Block_A_Section_1/V1_Breast_Cancer_Block_A_Section_1_filtered_feature_bc_matrix.tar.gz"
  fileName="V1_Breast_Cancer_Block_A_Section_1_filtered_feature_bc_matrix.tar.gz"
  fileSize="74 MB"
>
  下载 Visium Breast Cancer 表达矩阵
</DownloadButton>

适用模块：

- [模块09：空间转录组学](/docs/modules/module09)

该数据体积较大，当前不放入网站仓库。上方按钮会直接从 10x Genomics 原始地址下载。也可以使用命令行下载：

```bash
mkdir -p ~/biof3-data/visium-breast-cancer
cd ~/biof3-data/visium-breast-cancer

curl -L -O https://cf.10xgenomics.com/samples/spatial-exp/1.1.0/V1_Breast_Cancer_Block_A_Section_1/V1_Breast_Cancer_Block_A_Section_1_filtered_feature_bc_matrix.tar.gz
tar -xzf V1_Breast_Cancer_Block_A_Section_1_filtered_feature_bc_matrix.tar.gz
```

:::note
完整空间分析通常还需要组织切片图片和 `spatial/` 坐标文件。后续补强模块 10 时，会把矩阵、图片、坐标和 Seurat/Scanpy 读取流程整理成完整示例。
:::

## PBMC scATAC 10k

PBMC scATAC 10k 是 10x Genomics 的单细胞 ATAC-seq 数据，适合练习 peak matrix、TF-IDF、SVD/LSI 和染色质可及性分析。

<DownloadButton
  fileUrl="https://cf.10xgenomics.com/samples/cell-atac/2.1.0/10k_pbmc_ATACv2_nextgem_Chromium_Controller/10k_pbmc_ATACv2_nextgem_Chromium_Controller_filtered_peak_bc_matrix.h5"
  fileName="10k_pbmc_ATACv2_nextgem_Chromium_Controller_filtered_peak_bc_matrix.h5"
  fileSize="162 MB"
>
  下载 PBMC scATAC 10k 数据
</DownloadButton>

适用模块：

- [模块10：scATAC-seq](/docs/modules/module10)

该数据体积较大，当前不放入网站仓库。上方按钮会直接从 10x Genomics 原始地址下载。也可以使用命令行下载：

```bash
mkdir -p ~/biof3-data/pbmc10k-scatac
cd ~/biof3-data/pbmc10k-scatac

curl -L -O https://cf.10xgenomics.com/samples/cell-atac/2.1.0/10k_pbmc_ATACv2_nextgem_Chromium_Controller/10k_pbmc_ATACv2_nextgem_Chromium_Controller_filtered_peak_bc_matrix.h5
```

## 使用建议

1. 初学者先下载 PBMC 3k，优先完成模块 01-03。
2. 做多模态分析时再下载 5k PBMC CITE-seq。
3. 空间转录组和 scATAC 数据体积更大，建议在理解标准 scRNA-seq 流程后再使用。
4. 网站仓库只保存教程、脚本和小型示例，不保存大型原始数据。

## 数据来源

- [10x Genomics Datasets](https://www.10xgenomics.com/datasets)
- [Seurat PBMC 3k Guided Tutorial](https://satijalab.org/seurat/articles/pbmc3k_tutorial)
- [Scanpy PBMC 3k Preprocessing Tutorial](https://scanpy.readthedocs.io/en/stable/tutorials/basics/clustering-2017.html)
