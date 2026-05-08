---
sidebar_position: 5
---

# 模块05：轨迹推断与拟时序分析

本模块将介绍如何使用轨迹推断方法研究细胞分化、发育和状态转换过程。

## 学习目标

- 理解拟时序分析的原理
- 掌握多种轨迹推断方法
- 识别分化轨迹和分支点
- 分析轨迹相关基因
- 可视化细胞发育过程

## 什么是轨迹推断？

### 概念

**轨迹推断（Trajectory Inference）**：从单细胞数据中重建细胞状态转换的连续过程。

**拟时序（Pseudotime）**：细胞在分化或发育过程中的相对位置，而非真实时间。

### 应用场景

- 🧬 **发育生物学**：胚胎发育、器官形成
- 🔬 **分化研究**：干细胞分化、细胞命运决定
- 🏥 **疾病研究**：肿瘤进展、免疫应答
- 💊 **药物响应**：细胞状态变化

## 轨迹推断方法对比

| 方法 | 工具 | 轨迹类型 | 优点 | 缺点 |
|------|------|---------|------|------|
| **Monocle3** | Monocle3 | 复杂分支 | 功能全面 | 较慢 |
| **Slingshot** | Slingshot | 线性/分支 | 快速简单 | 需要预聚类 |
| **PAGA** | Scanpy | 图结构 | 可扩展 | 抽象 |
| **Velocyto** | scVelo | RNA 速率 | 方向性 | 需要内含子 |
| **CytoTRACE** | CytoTRACE | 分化程度 | 无监督 | 仅排序 |

## 使用 Monocle3

### 安装

```r
# 安装 Monocle3
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats',
                       'limma', 'latchet', 'S4Vectors', 'SingleCellExperiment',
                       'SummarizedExperiment', 'batchelor', 'HDF5Array',
                       'terra', 'ggrastr'))

install.packages("devtools")
devtools::install_github('cole-trapnell-lab/monocle3')
```

### 从 Seurat 转换

```r
library(Seurat)
library(monocle3)
library(SeuratWrappers)

# 假设已有 Seurat 对象
# 转换为 CDS 对象
cds <- as.cell_data_set(seurat_obj)

# 或手动创建
expression_matrix <- seurat_obj@assays$RNA@counts
cell_metadata <- seurat_obj@meta.data
gene_metadata <- data.frame(
  gene_short_name = rownames(expression_matrix),
  row.names = rownames(expression_matrix)
)

cds <- new_cell_data_set(
  expression_matrix,
  cell_metadata = cell_metadata,
  gene_metadata = gene_metadata
)
```

### 预处理

```r
# 预处理
cds <- preprocess_cds(cds, num_dim = 50)

# 降维
cds <- reduce_dimension(cds, reduction_method = "UMAP")

# 可视化
plot_cells(cds, color_cells_by = "cell_type")
```

### 聚类

```r
# 聚类（如果还没有）
cds <- cluster_cells(cds, resolution = 1e-3)

# 可视化聚类
plot_cells(cds, color_cells_by = "cluster")
```

### 学习轨迹

```r
# 学习轨迹图
cds <- learn_graph(cds)

# 可视化轨迹
plot_cells(cds,
           color_cells_by = "cell_type",
           label_groups_by_cluster = FALSE,
           label_leaves = FALSE,
           label_branch_points = FALSE)
```

### 排序细胞（拟时序）

```r
# 选择起始点（根细胞）
# 方法1：交互式选择
cds <- order_cells(cds)

# 方法2：根据细胞类型自动选择
cds <- order_cells(cds, root_cells = colnames(cds)[cds$cell_type == "Stem"])

# 可视化拟时序
plot_cells(cds,
           color_cells_by = "pseudotime",
           label_cell_groups = FALSE,
           label_leaves = FALSE,
           label_branch_points = FALSE)
```

### 识别轨迹相关基因

```r
# 寻找随拟时序变化的基因
track_genes <- graph_test(cds, neighbor_graph = "principal_graph")

# 查看显著基因
track_genes_sig <- track_genes %>%
  filter(q_value < 0.05) %>%
  arrange(q_value)

head(track_genes_sig)

# 可视化基因表达沿轨迹的变化
plot_cells(cds,
           genes = head(track_genes_sig$gene_short_name, 4),
           show_trajectory_graph = FALSE,
           label_cell_groups = FALSE)
```

### 模块分析

```r
# 识别共表达模块
gene_module_df <- find_gene_modules(cds[track_genes_sig$gene_short_name,],
                                    resolution = 1e-2)

# 可视化模块
plot_cells(cds,
           genes = gene_module_df,
           label_cell_groups = FALSE,
           show_trajectory_graph = FALSE)
```

## 使用 Slingshot

### 安装和准备

```r
# 安装
BiocManager::install("slingshot")

library(slingshot)
library(SingleCellExperiment)

# 从 Seurat 转换
sce <- as.SingleCellExperiment(seurat_obj)
```

### 运行 Slingshot

```r
# 运行 Slingshot
sce <- slingshot(sce, 
                 clusterLabels = 'seurat_clusters',
                 reducedDim = 'UMAP',
                 start.clus = "0")  # 起始簇

# 查看结果
summary(sce@metadata$slingshot)

# 提取拟时序
pseudotime <- slingPseudotime(sce)
head(pseudotime)
```

### 可视化

```r
library(RColorBrewer)

# 准备颜色
colors <- colorRampPalette(brewer.pal(11, 'Spectral')[-6])(100)

# 绘制轨迹
plot(reducedDims(sce)$UMAP, 
     col = colors[cut(pseudotime[,1], breaks = 100)],
     pch = 16, asp = 1)
lines(SlingshotDataSet(sce), lwd = 2, col = 'black')
```

### 识别轨迹相关基因

```r
library(tradeSeq)

# 拟合 GAM 模型
sce <- fitGAM(sce)

# 寻找随拟时序变化的基因
assocRes <- associationTest(sce)

# 显著基因
sig_genes <- rownames(assocRes)[assocRes$pvalue < 0.05]
```

## 使用 PAGA (Scanpy)

### Python 实现

```python
import scanpy as sc
import numpy as np

# 假设已有 AnnData 对象
# 计算 PAGA
sc.tl.paga(adata, groups='leiden')

# 可视化 PAGA 图
sc.pl.paga(adata, color=['leiden', 'CST3'])

# 在 UMAP 上显示 PAGA 路径
sc.tl.draw_graph(adata, init_pos='paga')
sc.pl.draw_graph(adata, color='leiden', legend_loc='on data')

# 计算拟时序
adata.uns['iroot'] = np.flatnonzero(adata.obs['leiden'] == '0')[0]
sc.tl.dpt(adata)

# 可视化拟时序
sc.pl.umap(adata, color=['dpt_pseudotime'], color_map='viridis')
```

### 基因表达趋势

```python
# 选择基因
genes = ['CD34', 'CD38', 'CD14', 'CD3D']

# 沿拟时序可视化
sc.pl.umap(adata, color=genes + ['dpt_pseudotime'])
```

## 使用 RNA Velocity (scVelo)

### 原理

RNA velocity 通过比较未剪接（nascent）和已剪接（mature）mRNA 的比例来推断细胞状态的变化方向。

### 准备数据

```bash
# 使用 velocyto 处理 BAM 文件
velocyto run10x -m repeat_msk.gtf mypath/sample01 genes.gtf
```

### Python 分析

```python
import scvelo as scv
import scanpy as sc

# 读取 loom 文件
adata = scv.read('sample01.loom', cache=True)

# 合并已有的分析结果
adata_seurat = sc.read_h5ad('analyzed.h5ad')
adata = scv.utils.merge(adata, adata_seurat)

# 预处理
scv.pp.filter_and_normalize(adata, min_shared_counts=20, n_top_genes=2000)
scv.pp.moments(adata, n_pcs=30, n_neighbors=30)

# 计算 velocity
scv.tl.velocity(adata)
scv.tl.velocity_graph(adata)

# 可视化
scv.pl.velocity_embedding_stream(adata, basis='umap', color='cell_type')
scv.pl.velocity_embedding(adata, basis='umap', arrow_length=3, arrow_size=2)
```

### 动态模型

```python
# 使用动态模型（更准确）
scv.tl.recover_dynamics(adata)
scv.tl.velocity(adata, mode='dynamical')
scv.tl.velocity_graph(adata)

# 可视化
scv.pl.velocity_embedding_stream(adata, basis='umap', color='cell_type')

# 拟时序
scv.tl.velocity_pseudotime(adata)
scv.pl.scatter(adata, color='velocity_pseudotime', cmap='gnuplot')
```

## 使用 CytoTRACE

### R 实现

```r
# 安装
devtools::install_github("digitalcytometry/cytotrace")

library(CytoTRACE)

# 准备表达矩阵
expr_matrix <- as.matrix(seurat_obj@assays$RNA@counts)

# 运行 CytoTRACE
results <- CytoTRACE(expr_matrix)

# 添加到 Seurat 对象
seurat_obj$CytoTRACE <- results$CytoTRACE

# 可视化
FeaturePlot(seurat_obj, features = "CytoTRACE")
```

## 轨迹分析最佳实践

### 1. 选择合适的方法

```r
# 决策树
if (有明确的起始细胞类型) {
  if (轨迹简单) {
    使用 Slingshot
  } else {
    使用 Monocle3
  }
} else {
  if (有 BAM 文件) {
    使用 RNA Velocity
  } else {
    使用 PAGA 或 CytoTRACE
  }
}
```

### 2. 验证轨迹

- 检查已知标志基因的表达模式
- 与文献报道的分化过程对比
- 使用多种方法交叉验证

### 3. 生物学解释

```r
# 识别关键转换点的基因
# 分支点分析
branch_point_genes <- find_branch_genes(cds)

# 功能富集
library(clusterProfiler)
ego <- enrichGO(gene = branch_point_genes,
                OrgDb = org.Hs.eg.db,
                ont = "BP")
```

## 可视化技巧

### 1. 热图展示基因表达趋势

```r
# Monocle3
plot_genes_in_pseudotime(cds[track_genes_sig$gene_short_name[1:50],],
                         color_cells_by = "cell_type",
                         min_expr = 0.5)
```

### 2. 分支分析

```r
# 比较不同分支的基因表达
branch_genes <- branch_point_test(cds, 
                                  branch_point = 1,
                                  neighbor_graph = "principal_graph")
```

### 3. 3D 轨迹可视化

```r
# 使用 plotly 进行 3D 可视化
library(plotly)

# 提取坐标和拟时序
coords <- reducedDims(sce)$UMAP
pt <- pseudotime[,1]

plot_ly(x = coords[,1], 
        y = coords[,2], 
        z = pt,
        type = "scatter3d",
        mode = "markers",
        color = pt)
```

## 实际案例：造血干细胞分化

### 数据准备

```r
# 加载造血数据
library(Seurat)
hsc <- readRDS("hematopoiesis_data.rds")

# 查看细胞类型
table(hsc$cell_type)
```

### Monocle3 分析

```r
# 转换并分析
cds <- as.cell_data_set(hsc)
cds <- preprocess_cds(cds, num_dim = 50)
cds <- reduce_dimension(cds)
cds <- cluster_cells(cds)
cds <- learn_graph(cds)

# 从 HSC 开始排序
cds <- order_cells(cds, root_cells = colnames(cds)[cds$cell_type == "HSC"])

# 可视化
plot_cells(cds,
           color_cells_by = "pseudotime",
           label_cell_groups = FALSE,
           label_branch_points = TRUE,
           graph_label_size = 3)

# 按细胞类型着色
plot_cells(cds,
           color_cells_by = "cell_type",
           label_groups_by_cluster = FALSE)
```

### 识别谱系特异性基因

```r
# 髓系 vs 淋巴系
lineage_genes <- graph_test(cds, neighbor_graph = "principal_graph")

# 可视化关键基因
key_genes <- c("MPO", "CD3D", "CD79A", "CD14")
plot_cells(cds,
           genes = key_genes,
           show_trajectory_graph = TRUE,
           label_cell_groups = FALSE)
```

## 常见问题

### 问题 1: 轨迹不连续

**原因**:
- 细胞数量不足
- 缺少中间状态细胞
- 参数设置不当

**解决方案**:
- 增加细胞数量
- 调整降维参数
- 尝试不同的方法

### 问题 2: 多条轨迹混淆

**原因**:
- 存在多个独立的分化过程
- 细胞类型注释不准确

**解决方案**:
- 分别分析不同的细胞谱系
- 改进细胞类型注释
- 使用更复杂的模型

### 问题 3: 拟时序与真实时间不符

**说明**:
- 拟时序是相对顺序，不是真实时间
- 需要结合实验时间点数据验证

## 下一步

- [模块06：细胞通讯分析](/docs/modules/module06)
- [模块07：多模态数据分析](/docs/modules/module07)

## 参考资源

- [Monocle3 文档](https://cole-trapnell-lab.github.io/monocle3/)
- [Slingshot 教程](https://bioconductor.org/packages/release/bioc/vignettes/slingshot/inst/doc/vignette.html)
- [scVelo 文档](https://scvelo.readthedocs.io/)
- [轨迹推断综述](https://www.nature.com/articles/s41576-019-0093-7)
