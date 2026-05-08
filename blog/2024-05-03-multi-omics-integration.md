---
slug: multi-omics-integration
title: 多组学数据整合分析入门
authors: [biof3]
tags: [整合分析, 多组学, 教程]
---

多组学数据整合分析是现代生物学研究的重要方向。本文将介绍如何整合不同组学层面的数据，获得更全面的生物学洞察。

{/* truncate */}

## 什么是多组学整合分析？

多组学整合分析（Multi-omics Integration）是指将来自不同组学层面的数据（如基因组、转录组、蛋白质组、代谢组等）进行联合分析，以获得对生物系统更全面的理解。

### 为什么需要多组学整合？

单一组学数据的局限性：

| 组学类型 | 测量内容 | 局限性 |
|---------|---------|--------|
| **基因组** | DNA 序列变异 | 无法反映基因表达 |
| **转录组** | mRNA 表达水平 | 无法反映蛋白质水平 |
| **蛋白质组** | 蛋白质丰度 | 无法反映代谢状态 |
| **代谢组** | 代谢物浓度 | 无法追溯上游调控 |

**整合分析的优势**：
- 更全面的生物学视角
- 发现跨组学的调控关系
- 提高生物标志物的可靠性
- 揭示复杂的生物学机制

## 常见的多组学整合策略

### 1. 早期整合（Early Integration）

在数据预处理阶段就将不同组学数据合并。

```python
import pandas as pd
import numpy as np

# 合并不同组学数据
rna_data = pd.read_csv('rna_expression.csv', index_col=0)
protein_data = pd.read_csv('protein_abundance.csv', index_col=0)

# 标准化
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()

rna_scaled = scaler.fit_transform(rna_data)
protein_scaled = scaler.fit_transform(protein_data)

# 合并
combined_data = np.hstack([rna_scaled, protein_scaled])
```

**优点**：
- 简单直接
- 可以使用标准的机器学习方法

**缺点**：
- 可能丢失组学特异性信息
- 不同组学的尺度差异大

### 2. 中期整合（Intermediate Integration）

分别分析各组学数据，然后整合分析结果。

```r
library(mixOmics)

# DIABLO 方法
design <- matrix(0.1, ncol = 3, nrow = 3, 
                dimnames = list(c("RNA", "Protein", "Metabolite"),
                               c("RNA", "Protein", "Metabolite")))
diag(design) <- 0

result <- block.splsda(
  X = list(RNA = rna_data, 
           Protein = protein_data, 
           Metabolite = metabolite_data),
  Y = sample_groups,
  design = design,
  ncomp = 3
)

# 可视化
plotDiablo(result)
```

### 3. 晚期整合（Late Integration）

独立分析各组学，最后整合结论。

```python
# 分别进行差异分析
from scipy import stats

# RNA-seq 差异分析
rna_pvalues = []
for gene in rna_data.columns:
    t_stat, p_val = stats.ttest_ind(
        rna_data[gene][group1],
        rna_data[gene][group2]
    )
    rna_pvalues.append(p_val)

# 蛋白质组差异分析
protein_pvalues = []
for protein in protein_data.columns:
    t_stat, p_val = stats.ttest_ind(
        protein_data[protein][group1],
        protein_data[protein][group2]
    )
    protein_pvalues.append(p_val)

# 整合结果
from scipy.stats import combine_pvalues
combined_pval = combine_pvalues([rna_pvalues, protein_pvalues], 
                                method='fisher')
```

## 常用工具和方法

### 1. mixOmics (R)

**推荐指数**: ⭐⭐⭐⭐⭐

```r
library(mixOmics)

# PLS-DA 分析
result <- plsda(X = multi_omics_data, 
                Y = sample_groups, 
                ncomp = 3)

# 可视化
plotIndiv(result, comp = c(1,2), 
          group = sample_groups, 
          legend = TRUE)

# 变量重要性
plotLoadings(result, comp = 1)
```

**适用场景**：
- 多组学数据整合
- 监督和非监督分析
- 特征选择

### 2. MOFA (Multi-Omics Factor Analysis)

**推荐指数**: ⭐⭐⭐⭐⭐

```python
from mofapy2.run.entry_point import entry_point

# 准备数据
data = {
    'RNA': rna_matrix,
    'Protein': protein_matrix,
    'Metabolite': metabolite_matrix
}

# 运行 MOFA
ent = entry_point()
ent.set_data_options(scale_groups=False, scale_views=True)
ent.set_data_matrix(data)
ent.set_model_options(factors=10)
ent.build()
ent.run()

# 可视化因子
ent.plot_variance_explained()
ent.plot_factor_cor()
```

**特点**：
- 无监督方法
- 识别跨组学的潜在因子
- 处理缺失数据

### 3. SNF (Similarity Network Fusion)

**推荐指数**: ⭐⭐⭐⭐

```r
library(SNFtool)

# 构建相似性网络
W1 <- affinityMatrix(dist(rna_data))
W2 <- affinityMatrix(dist(protein_data))

# 融合网络
W <- SNF(list(W1, W2), K = 20, t = 20)

# 聚类
groups <- spectralClustering(W, K = 3)
```

**适用场景**：
- 患者分层
- 亚型识别
- 网络分析

### 4. WGCNA (加权基因共表达网络分析)

**推荐指数**: ⭐⭐⭐⭐

```r
library(WGCNA)

# 构建网络
net <- blockwiseModules(
  datExpr,
  power = 6,
  TOMType = "unsigned",
  minModuleSize = 30,
  reassignThreshold = 0,
  mergeCutHeight = 0.25
)

# 模块与表型关联
moduleTraitCor <- cor(net$MEs, clinical_traits, use = "p")
moduleTraitPvalue <- corPvalueStudent(moduleTraitCor, nSamples)
```

## 实战案例：癌症多组学分析

### 数据准备

```python
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler

# 加载数据
rna_seq = pd.read_csv('tcga_rna_seq.csv', index_col=0)
cnv = pd.read_csv('tcga_cnv.csv', index_col=0)
methylation = pd.read_csv('tcga_methylation.csv', index_col=0)
clinical = pd.read_csv('tcga_clinical.csv', index_col=0)

# 确保样本一致
common_samples = list(set(rna_seq.columns) & 
                     set(cnv.columns) & 
                     set(methylation.columns))

rna_seq = rna_seq[common_samples]
cnv = cnv[common_samples]
methylation = methylation[common_samples]
```

### 使用 MOFA 进行整合

```python
from mofapy2.run.entry_point import entry_point

# 准备数据
data_dict = {
    'RNA': rna_seq.T.values,
    'CNV': cnv.T.values,
    'Methylation': methylation.T.values
}

# 初始化 MOFA
ent = entry_point()
ent.set_data_options(
    scale_groups=False,
    scale_views=True
)
ent.set_data_matrix(data_dict, likelihoods=['gaussian']*3)

# 设置模型参数
ent.set_model_options(
    factors=15,
    spikeslab_weights=True,
    ard_factors=True
)

# 训练模型
ent.build()
ent.run()

# 保存模型
ent.save('mofa_model.hdf5')
```

### 结果解读

```python
# 加载模型
from mofapy2.run.entry_point import entry_point
model = entry_point()
model.load('mofa_model.hdf5')

# 查看方差解释
model.plot_variance_explained(
    plot_total=True,
    x='view',
    y='factor'
)

# 提取因子值
factors = model.get_factors()

# 与临床特征关联
import scipy.stats as stats
for i in range(factors.shape[1]):
    corr, pval = stats.spearmanr(
        factors[:, i],
        clinical['survival_time']
    )
    print(f"Factor {i+1}: r={corr:.3f}, p={pval:.3e}")
```

## 机器学习在多组学中的应用

### 1. 随机森林

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score

# 合并特征
X = np.hstack([rna_scaled, protein_scaled, metabolite_scaled])
y = sample_labels

# 训练模型
rf = RandomForestClassifier(n_estimators=100, random_state=42)
scores = cross_val_score(rf, X, y, cv=5)

print(f"准确率: {scores.mean():.3f} (+/- {scores.std():.3f})")

# 特征重要性
rf.fit(X, y)
feature_importance = rf.feature_importances_
```

### 2. 深度学习

```python
import torch
import torch.nn as nn

class MultiOmicsNet(nn.Module):
    def __init__(self, rna_dim, protein_dim, metabolite_dim, n_classes):
        super().__init__()
        
        # 各组学的编码器
        self.rna_encoder = nn.Sequential(
            nn.Linear(rna_dim, 256),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(256, 64)
        )
        
        self.protein_encoder = nn.Sequential(
            nn.Linear(protein_dim, 128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128, 64)
        )
        
        self.metabolite_encoder = nn.Sequential(
            nn.Linear(metabolite_dim, 64),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(64, 64)
        )
        
        # 整合层
        self.fusion = nn.Sequential(
            nn.Linear(64*3, 128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128, n_classes)
        )
    
    def forward(self, rna, protein, metabolite):
        rna_feat = self.rna_encoder(rna)
        protein_feat = self.protein_encoder(protein)
        metabolite_feat = self.metabolite_encoder(metabolite)
        
        # 拼接特征
        combined = torch.cat([rna_feat, protein_feat, metabolite_feat], dim=1)
        output = self.fusion(combined)
        return output

# 训练模型
model = MultiOmicsNet(rna_dim=5000, protein_dim=1000, 
                     metabolite_dim=200, n_classes=3)
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
```

## 数据可视化

### 1. 热图

```python
import seaborn as sns
import matplotlib.pyplot as plt

# 相关性热图
fig, axes = plt.subplots(1, 3, figsize=(18, 5))

sns.heatmap(rna_data.corr(), ax=axes[0], cmap='RdBu_r', center=0)
axes[0].set_title('RNA-seq 相关性')

sns.heatmap(protein_data.corr(), ax=axes[1], cmap='RdBu_r', center=0)
axes[1].set_title('蛋白质组相关性')

sns.heatmap(metabolite_data.corr(), ax=axes[2], cmap='RdBu_r', center=0)
axes[2].set_title('代谢组相关性')

plt.tight_layout()
plt.show()
```

### 2. 网络图

```python
import networkx as nx

# 构建跨组学网络
G = nx.Graph()

# 添加节点
for gene in top_genes:
    G.add_node(gene, type='RNA')
for protein in top_proteins:
    G.add_node(protein, type='Protein')

# 添加边（基于相关性）
for gene in top_genes:
    for protein in top_proteins:
        corr = np.corrcoef(rna_data[gene], protein_data[protein])[0,1]
        if abs(corr) > 0.7:
            G.add_edge(gene, protein, weight=abs(corr))

# 可视化
pos = nx.spring_layout(G)
nx.draw(G, pos, node_color=['red' if G.nodes[n]['type']=='RNA' else 'blue' 
                            for n in G.nodes()],
        with_labels=True, node_size=500)
plt.show()
```

## 最佳实践

### 1. 数据预处理

- **标准化**：不同组学数据尺度差异大，需要标准化
- **批次效应**：使用 ComBat 等方法校正
- **缺失值处理**：插补或删除

### 2. 特征选择

- 减少维度，提高计算效率
- 选择生物学相关的特征
- 避免过拟合

### 3. 验证

- 交叉验证
- 独立数据集验证
- 生物学验证

### 4. 解释性

- 不仅要预测准确，还要有生物学意义
- 结合通路分析
- 文献验证

## 常见挑战

### 1. 数据异质性

**问题**：不同组学数据的特性差异大

**解决方案**：
- 使用适合各组学的预处理方法
- 考虑组学特异性的权重

### 2. 样本量不匹配

**问题**：不同组学的样本数可能不同

**解决方案**：
- 只使用共同样本
- 使用能处理缺失数据的方法（如 MOFA）

### 3. 计算复杂度

**问题**：多组学数据量大，计算耗时

**解决方案**：
- 特征选择
- 使用高性能计算资源
- 并行计算

## 学习资源

### 在线课程
- Coursera: Multi-omics Data Analysis
- edX: Systems Biology

### 书籍
- "Multi-Omics Data Integration" by Olivier Elemento
- "Computational Methods for Integrative Analysis of Genomics Data"

### 工具文档
- [mixOmics](http://mixomics.org/)
- [MOFA](https://biofam.github.io/MOFA2/)
- [SNFtool](https://cran.r-project.org/web/packages/SNFtool/)

## 总结

多组学整合分析是一个快速发展的领域，关键要点：

1. **选择合适的整合策略**：早期、中期或晚期整合
2. **使用专业工具**：mixOmics、MOFA、SNF 等
3. **注重数据质量**：预处理和标准化
4. **生物学解释**：结果要有生物学意义
5. **持续学习**：关注新方法和工具

---

想了解更多？查看我们的其他教程：
- [单细胞转录组分析](/blog/single-cell-analysis-intro)
- [生物信息学工具推荐](/blog/bioinformatics-tools-2024)
