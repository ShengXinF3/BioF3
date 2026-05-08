---
sidebar_position: 6
---

# 模块06：细胞-细胞通讯分析

本模块将介绍如何从单细胞数据中推断细胞间的通讯网络和信号传导。

## 学习目标

- 理解细胞通讯的分子机制
- 掌握多种细胞通讯分析工具
- 识别配体-受体相互作用
- 可视化细胞通讯网络
- 解释通讯分析结果

## 细胞通讯基础

### 什么是细胞通讯？

细胞通过分泌配体（Ligand）与其他细胞表面的受体（Receptor）结合来进行通讯。

### 通讯类型

1. **旁分泌（Paracrine）**: 局部细胞间通讯
2. **自分泌（Autocrine）**: 细胞自我刺激
3. **内分泌（Endocrine）**: 远距离激素信号
4. **细胞接触（Juxtacrine）**: 直接接触通讯

### 为什么重要？

- 🧬 理解组织微环境
- 🏥 疾病机制研究
- 💊 药物靶点发现
- 🔬 发育过程解析

## 细胞通讯分析工具对比

| 工具 | 语言 | 数据库 | 优点 | 缺点 |
|------|------|--------|------|------|
| **CellChat** | R | 自建 | 功能全面 | 较慢 |
| **CellPhoneDB** | Python | 人工整理 | 准确度高 | 需要 Python |
| **NicheNet** | R | 多源整合 | 预测下游 | 复杂 |
| **LIANA** | R/Python | 多数据库 | 整合多工具 | 新工具 |
| **Connectome** | R | CellPhoneDB | 简单快速 | 功能有限 |

## 使用 CellChat

### 安装

```r
# 安装 CellChat
devtools::install_github("sqjin/CellChat")

# 加载包
library(CellChat)
library(patchwork)
library(Seurat)
```

### 准备数据

```r
# 从 Seurat 对象创建 CellChat 对象
cellchat <- createCellChat(object = seurat_obj, 
                           group.by = "cell_type")

# 或从表达矩阵创建
data.input <- GetAssayData(seurat_obj, assay = "RNA", slot = "data")
meta <- seurat_obj@meta.data
cellchat <- createCellChat(object = data.input, meta = meta, group.by = "cell_type")
```

### 加载配体-受体数据库

```r
# 人类数据库
CellChatDB <- CellChatDB.human

# 小鼠数据库
# CellChatDB <- CellChatDB.mouse

# 查看数据库
showDatabaseCategory(CellChatDB)

# 使用全部数据库
cellchat@DB <- CellChatDB

# 或只使用特定类别
# cellchat@DB <- subsetDB(CellChatDB, search = "Secreted Signaling")
```

### 预处理

```r
# 识别过表达的配体和受体
cellchat <- subsetData(cellchat)

# 识别过表达的配体-受体对
cellchat <- identifyOverExpressedGenes(cellchat)
cellchat <- identifyOverExpressedInteractions(cellchat)
```

### 推断细胞通讯网络

```r
# 计算通讯概率
cellchat <- computeCommunProb(cellchat, 
                              type = "triMean",  # 或 "truncatedMean"
                              trim = 0.1)

# 过滤低概率的通讯
cellchat <- filterCommunication(cellchat, min.cells = 10)

# 推断信号通路水平的通讯
cellchat <- computeCommunProbPathway(cellchat)

# 计算聚合的细胞通讯网络
cellchat <- aggregateNet(cellchat)
```

### 可视化

#### 1. 通讯数量和强度

```r
# 通讯数量
groupSize <- as.numeric(table(cellchat@idents))

par(mfrow = c(1,2), xpd=TRUE)

# 通讯数量
netVisual_circle(cellchat@net$count, 
                 vertex.weight = groupSize, 
                 weight.scale = TRUE, 
                 label.edge = FALSE, 
                 title.name = "Number of interactions")

# 通讯强度
netVisual_circle(cellchat@net$weight, 
                 vertex.weight = groupSize, 
                 weight.scale = TRUE, 
                 label.edge = FALSE, 
                 title.name = "Interaction weights/strength")
```

#### 2. 特定细胞类型的通讯

```r
# 查看特定细胞类型发送和接收的信号
mat <- cellchat@net$weight

# 发送信号
par(mfrow = c(2,2), xpd=TRUE)
for (i in 1:nrow(mat)) {
  mat2 <- matrix(0, nrow = nrow(mat), ncol = ncol(mat), dimnames = dimnames(mat))
  mat2[i, ] <- mat[i, ]
  netVisual_circle(mat2, vertex.weight = groupSize, 
                   weight.scale = TRUE, edge.weight.max = max(mat), 
                   title.name = rownames(mat)[i])
}
```

#### 3. 信号通路可视化

```r
# 查看所有信号通路
cellchat@netP$pathways

# 可视化特定通路（例如 WNT）
pathways.show <- c("WNT") 

# 层级图
netVisual_aggregate(cellchat, 
                    signaling = pathways.show, 
                    layout = "hierarchy")

# 圆圈图
netVisual_aggregate(cellchat, 
                    signaling = pathways.show, 
                    layout = "circle")

# 和弦图
netVisual_aggregate(cellchat, 
                    signaling = pathways.show, 
                    layout = "chord")

# 热图
netVisual_heatmap(cellchat, 
                  signaling = pathways.show, 
                  color.heatmap = "Reds")
```

#### 4. 配体-受体对

```r
# 查看特定通路的配体-受体对
netAnalysis_contribution(cellchat, signaling = pathways.show)

# 可视化特定配体-受体对
pairLR.WNT <- extractEnrichedLR(cellchat, 
                                signaling = pathways.show, 
                                geneLR.return = FALSE)

# 层级图显示特定配体-受体对
netVisual_individual(cellchat, 
                     signaling = pathways.show, 
                     pairLR.use = "WNT5A_FZD5", 
                     layout = "hierarchy")
```

### 识别信号角色

```r
# 识别信号发送者和接收者
cellchat <- netAnalysis_computeCentrality(cellchat, slot.name = "netP")

# 可视化信号角色
netAnalysis_signalingRole_network(cellchat, 
                                  signaling = pathways.show, 
                                  width = 8, 
                                  height = 2.5, 
                                  font.size = 10)

# 热图显示主导发送者和接收者
ht1 <- netAnalysis_signalingRole_heatmap(cellchat, 
                                         pattern = "outgoing",
                                         width = 8, 
                                         height = 10)
ht2 <- netAnalysis_signalingRole_heatmap(cellchat, 
                                         pattern = "incoming",
                                         width = 8, 
                                         height = 10)
ht1 + ht2
```

### 识别全局通讯模式

```r
# 识别发送信号的模式
cellchat <- identifyCommunicationPatterns(cellchat, 
                                         pattern = "outgoing", 
                                         k = 3)

# 识别接收信号的模式
cellchat <- identifyCommun icationPatterns(cellchat, 
                                         pattern = "incoming", 
                                         k = 3)

# 可视化
netAnalysis_river(cellchat, pattern = "outgoing")
netAnalysis_river(cellchat, pattern = "incoming")

# 点图
netAnalysis_dot(cellchat, pattern = "outgoing")
netAnalysis_dot(cellchat, pattern = "incoming")
```

## 使用 CellPhoneDB

### 安装

```bash
# 创建 conda 环境
conda create -n cellphonedb python=3.8
conda activate cellphonedb

# 安装
pip install cellphonedb
```

### 准备数据

```python
# 需要两个文件：
# 1. counts.txt - 表达矩阵（基因 x 细胞）
# 2. meta.txt - 细胞类型注释

# 从 Seurat 导出
# R 代码
library(Seurat)

# 导出表达矩阵
write.table(as.matrix(seurat_obj@assays$RNA@data), 
            'counts.txt', 
            sep='\t', 
            quote=F)

# 导出元数据
meta_data <- data.frame(
  Cell = rownames(seurat_obj@meta.data),
  cell_type = seurat_obj$cell_type
)
write.table(meta_data, 
            'meta.txt', 
            sep='\t', 
            quote=F, 
            row.names=F)
```

### 运行分析

```bash
# 统计分析
cellphonedb method statistical_analysis \
    meta.txt \
    counts.txt \
    --counts-data=gene_name \
    --threads=4

# 结果在 out/ 目录
```

### 可视化

```bash
# 点图
cellphonedb plot dot_plot

# 热图
cellphonedb plot heatmap_plot meta.txt
```

### Python 可视化

```python
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# 读取结果
pvalues = pd.read_csv('out/pvalues.txt', sep='\t')
means = pd.read_csv('out/means.txt', sep='\t')

# 过滤显著的相互作用
pvalues_filtered = pvalues[pvalues < 0.05]

# 热图
plt.figure(figsize=(15, 10))
sns.heatmap(means, cmap='viridis', cbar_kws={'label': 'Mean expression'})
plt.title('Cell-Cell Communication')
plt.tight_layout()
plt.show()
```

## 使用 NicheNet

### 安装

```r
# 安装
devtools::install_github("saeyslab/nichenetr")

library(nichenetr)
library(tidyverse)
```

### 准备数据

```r
# 加载 NicheNet 网络
ligand_target_matrix <- readRDS(url("https://zenodo.org/record/3260758/files/ligand_target_matrix.rds"))
lr_network <- readRDS(url("https://zenodo.org/record/3260758/files/lr_network.rds"))
weighted_networks <- readRDS(url("https://zenodo.org/record/3260758/files/weighted_networks.rds"))

# 定义发送细胞和接收细胞
sender_celltypes <- c("CD4 T", "CD8 T")
receiver <- "B"

# 提取表达数据
expressed_genes_receiver <- get_expressed_genes(receiver, seurat_obj, pct = 0.10)
expressed_genes_sender <- get_expressed_genes(sender_celltypes, seurat_obj, pct = 0.10)

# 定义基因集
background_expressed_genes <- expressed_genes_receiver %>% 
  union(expressed_genes_sender)
```

### 识别潜在配体

```r
# 定义感兴趣的基因（例如差异表达基因）
geneset_oi <- c("CD69", "CD44", "IL2RA")  # 示例基因

# 识别潜在配体
ligands <- lr_network %>% 
  pull(from) %>% 
  unique()

expressed_ligands <- intersect(ligands, expressed_genes_sender)

# 预测配体活性
ligand_activities <- predict_ligand_activities(
  geneset = geneset_oi,
  background_expressed_genes = background_expressed_genes,
  ligand_target_matrix = ligand_target_matrix,
  potential_ligands = expressed_ligands
)

# 查看最佳配体
best_upstream_ligands <- ligand_activities %>% 
  top_n(20, pearson) %>% 
  arrange(-pearson) %>% 
  pull(test_ligand)

print(best_upstream_ligands)
```

### 可视化

```r
# 配体-靶基因热图
active_ligand_target_links_df <- best_upstream_ligands %>% 
  lapply(get_weighted_ligand_target_links, 
         geneset = geneset_oi, 
         ligand_target_matrix = ligand_target_matrix, 
         n = 250) %>% 
  bind_rows()

# 绘制热图
p_ligand_target_network <- active_ligand_target_links_df %>% 
  make_heatmap_ggplot("ligand", "target", "weight", 
                      color = "purple", 
                      legend_title = "Regulatory potential") + 
  scale_fill_gradient2(low = "whitesmoke", high = "purple")

print(p_ligand_target_network)
```

## 比较不同条件的细胞通讯

### CellChat 比较分析

```r
# 创建两个 CellChat 对象（例如对照组和处理组）
cellchat_control <- createCellChat(seurat_control, group.by = "cell_type")
cellchat_treated <- createCellChat(seurat_treated, group.by = "cell_type")

# 分别分析
# ... (运行上述分析流程)

# 合并对象
cellchat_list <- list(Control = cellchat_control, Treated = cellchat_treated)
cellchat_merged <- mergeCellChat(cellchat_list, add.names = names(cellchat_list))

# 比较通讯数量和强度
gg1 <- compareInteractions(cellchat_merged, 
                          show.legend = FALSE, 
                          group = c(1,2))
gg2 <- compareInteractions(cellchat_merged, 
                          show.legend = FALSE, 
                          group = c(1,2), 
                          measure = "weight")
gg1 + gg2

# 比较特定信号通路
netVisual_diffInteraction(cellchat_merged, 
                         weight.scale = TRUE)

# 识别差异信号通路
gg1 <- rankNet(cellchat_merged, 
              mode = "comparison", 
              stacked = TRUE, 
              do.stat = TRUE)
gg2 <- rankNet(cellchat_merged, 
              mode = "comparison", 
              stacked = FALSE, 
              do.stat = TRUE)
gg1 + gg2
```

## 实际案例：肿瘤微环境

### 分析肿瘤-免疫细胞通讯

```r
# 假设有肿瘤单细胞数据
tumor_data <- readRDS("tumor_scRNA.rds")

# 创建 CellChat 对象
cellchat <- createCellChat(tumor_data, group.by = "cell_type")

# 标准分析流程
cellchat@DB <- CellChatDB.human
cellchat <- subsetData(cellchat)
cellchat <- identifyOverExpressedGenes(cellchat)
cellchat <- identifyOverExpressedInteractions(cellchat)
cellchat <- computeCommunProb(cellchat)
cellchat <- computeCommunProbPathway(cellchat)
cellchat <- aggregateNet(cellchat)

# 关注免疫检查点信号
immune_checkpoint <- c("PD-L1", "PD-L2", "CD80", "CD86")

# 可视化肿瘤细胞与 T 细胞的通讯
netVisual_bubble(cellchat, 
                sources.use = "Tumor", 
                targets.use = c("CD4 T", "CD8 T"), 
                remove.isolate = FALSE)

# 识别免疫抑制信号
netVisual_aggregate(cellchat, 
                   signaling = "PD-L1", 
                   layout = "hierarchy")
```

## 最佳实践

### 1. 数据质量

- 确保细胞类型注释准确
- 过滤低质量细胞
- 使用足够数量的细胞

### 2. 参数选择

```r
# CellChat 参数建议
computeCommunProb(
  type = "triMean",      # 推荐用于大多数情况
  trim = 0.1,            # 修剪极值
  population.size = TRUE # 考虑细胞群大小
)
```

### 3. 结果验证

- 查阅文献验证关键相互作用
- 使用多种工具交叉验证
- 实验验证重要发现

### 4. 生物学解释

- 结合组织学背景
- 考虑空间位置信息
- 关注功能相关的通路

## 常见问题

### 问题 1: 检测到的相互作用太多

**解决方案**:
- 提高过滤阈值
- 关注特定信号通路
- 使用更严格的统计检验

### 问题 2: 不同工具结果不一致

**原因**:
- 数据库不同
- 算法不同
- 参数设置不同

**建议**:
- 关注多个工具共同识别的相互作用
- 实验验证关键发现

### 问题 3: 如何选择工具？

**建议**:
- **CellChat**: 功能全面，适合深入分析
- **CellPhoneDB**: 数据库准确，适合快速分析
- **NicheNet**: 预测下游效应，适合机制研究

## 下一步

- [模块07：多模态数据分析](/docs/modules/module07)
- [模块09：空间转录组学](/docs/modules/module09)

## 参考资源

- [CellChat 文档](https://github.com/sqjin/CellChat)
- [CellPhoneDB 文档](https://www.cellphonedb.org/)
- [NicheNet 教程](https://github.com/saeyslab/nichenetr)
- [细胞通讯综述](https://www.nature.com/articles/s41576-020-00292-x)
