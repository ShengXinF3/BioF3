---
sidebar_position: 3
---

import DownloadButton from '@site/src/components/DownloadButton';

# Jupyter Notebooks 和数据库入门

Jupyter Notebooks 和 Google Colaboratory 提供了交互式环境，将代码和说明文本结合在一起，支持可重复的分析。

## 学习目标

通过本模块，你将学会：

- 理解 Jupyter Notebooks 的结构和功能
- 使用 Google Colaboratory 进行在线分析
- 熟悉单细胞数据的主要公共数据库
- 访问、探索和分析生物学数据库
- 掌握基本的数据操作技能

## 主要内容

### 1. Jupyter Notebooks 基础

#### 什么是 Jupyter Notebook？

Jupyter Notebook 是一个开源的 Web 应用程序，允许你创建和共享包含代码、方程式、可视化和文本的文档。

**主要特点：**
- 支持多种编程语言（Python、R、Julia 等）
- 交互式执行代码
- 内联显示图表和结果
- Markdown 格式的文档说明
- 易于分享和协作

#### Notebook 结构

**代码单元格（Code Cell）：**
```python
# 这是一个代码单元格
print("Hello, Bioinformatics!")

# 计算基因数量
gene_count = 20000
print(f"人类基因组约有 {gene_count} 个基因")
```

**文本单元格（Markdown Cell）：**
使用 Markdown 语法编写说明文档：
```markdown
# 一级标题
## 二级标题
**粗体文字**
*斜体文字*
- 列表项
```

#### 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| Shift + Enter | 运行当前单元格并移到下一个 |
| Ctrl + Enter | 运行当前单元格 |
| Alt + Enter | 运行当前单元格并在下方插入新单元格 |
| A | 在上方插入单元格 |
| B | 在下方插入单元格 |
| DD | 删除当前单元格 |
| M | 将单元格转换为 Markdown |
| Y | 将单元格转换为代码 |

### 2. 单细胞数据公共数据库

![数据库对比图](/img/tutorial/module01/06-database-comparison.png)

**图 1**：主要单细胞数据库对比。展示了 GEO、SCEA、HCA、CellxGene 和 SRA 五个数据库的数据集数量对比。

![数据分析工作流程](/img/tutorial/module01/07-workflow.png)

**图 2**：单细胞数据分析工作流程。从数据获取、质量控制、数据处理到下游分析的完整流程图。

#### 2.1 Gene Expression Omnibus (GEO)

**简介：**
GEO 是 NCBI 维护的基因表达数据库，包含微阵列和测序数据。

**网址：** https://www.ncbi.nlm.nih.gov/geo/

**主要功能：**
- 搜索和浏览数据集
- 下载原始数据和处理后的数据
- 在线可视化工具
- 查看实验元数据

**如何使用：**

1. 搜索数据集
```
在搜索框输入：single cell RNA-seq human
```

2. 下载数据
```python
# 使用 GEOparse 库
import GEOparse

# 下载 GEO 数据集
gse = GEOparse.get_GEO(geo="GSE12345", destdir="./data")
```

3. 查看元数据
```python
# 查看样本信息
print(gse.metadata)
print(gse.phenotype_data)
```

#### 2.2 Single Cell Expression Atlas (SCEA)

**简介：**
SCEA 是 EMBL-EBI 维护的单细胞表达数据库，提供精选的单细胞数据集。

**网址：** https://www.ebi.ac.uk/gxa/sc/home

**特点：**
- 经过质量控制的数据
- 标准化的细胞类型注释
- 多物种数据
- 交互式可视化

**使用示例：**

1. 浏览数据集
   - 按物种筛选
   - 按组织类型筛选
   - 按实验技术筛选

2. 下载数据
   - 表达矩阵
   - 细胞元数据
   - 基因注释

#### 2.3 Human Cell Atlas (HCA)

**简介：**
人类细胞图谱项目旨在创建所有人类细胞类型的参考图谱。

**网址：** https://www.humancellatlas.org/

**数据门户：** https://data.humancellatlas.org/

**特点：**
- 全球协作项目
- 标准化数据格式
- 多组学数据
- 组织和器官图谱

**访问数据：**

```python
# 使用 HCA Data Portal API
import requests

# 搜索数据集
url = "https://service.azul.data.humancellatlas.org/index/projects"
response = requests.get(url)
projects = response.json()
```

#### 2.4 CellxGene

**简介：**
CellxGene 是 Chan Zuckerberg Initiative 开发的单细胞数据探索工具。

**网址：** https://cellxgene.cziscience.com/

**特点：**
- 交互式可视化
- 快速数据探索
- UMAP/t-SNE 投影
- 细胞类型注释

#### 2.5 Sequence Read Archive (SRA)

**简介：**
SRA 存储原始测序数据。

**网址：** https://www.ncbi.nlm.nih.gov/sra

**下载数据：**

```bash
# 使用 SRA Toolkit
# 安装
conda install -c bioconda sra-tools

# 下载数据
prefetch SRR1234567
fastq-dump --split-files SRR1234567
```

### 3. 实践练习

:::tip AI 时代的学习方式
Vibe coding 带来极大的便利，能否用好工具需要思想的指引。如果想复现这些分析，建议下载完整脚本学习。
:::

<DownloadButton
  fileUrl="/scripts/module01_complete_sci.R"
  fileName="module01_complete_sci.R"
  fileSize="13 KB"
>
  下载 module01_complete_sci.R
</DownloadButton>

#### 练习 1：创建你的第一个 Notebook

```python
# 1. 导入库
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# 2. 创建示例数据
genes = ['Gene1', 'Gene2', 'Gene3', 'Gene4', 'Gene5']
expression = [5.2, 3.8, 7.1, 2.4, 6.5]

# 3. 创建 DataFrame
df = pd.DataFrame({
    'Gene': genes,
    'Expression': expression
})

# 4. 可视化
plt.figure(figsize=(10, 6))
plt.bar(df['Gene'], df['Expression'], color='steelblue')
plt.xlabel('基因')
plt.ylabel('表达量')
plt.title('基因表达水平')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# 5. 统计分析
print(f"平均表达量: {df['Expression'].mean():.2f}")
print(f"最大表达量: {df['Expression'].max():.2f}")
print(f"最小表达量: {df['Expression'].min():.2f}")
```

![基因表达柱状图](/img/tutorial/module01/01-gene-expression-bar.png)

**图 3**：基因表达水平柱状图。展示了 5 个基因的表达量，使用 Nature 风格配色。

#### 练习 2：从 GEO 搜索数据

```python
# 搜索单细胞数据集
import requests
from bs4 import BeautifulSoup

# GEO 搜索 URL
search_term = "single cell RNA-seq"
url = f"https://www.ncbi.nlm.nih.gov/geo/browse/?view=series&search={search_term}"

print(f"搜索链接: {url}")
print("请访问上述链接浏览数据集")
```

#### 练习 3：数据下载和基本分析

```python
# 模拟单细胞数据
import numpy as np
import pandas as pd

# 创建模拟表达矩阵
n_genes = 100
n_cells = 50

# 随机生成表达数据
expression_matrix = np.random.poisson(lam=5, size=(n_genes, n_cells))

# 创建基因名称
gene_names = [f"Gene_{i+1}" for i in range(n_genes)]

# 创建细胞名称
cell_names = [f"Cell_{i+1}" for i in range(n_cells)]

# 创建 DataFrame
df = pd.DataFrame(expression_matrix, 
                  index=gene_names, 
                  columns=cell_names)

# 基本统计
print("数据维度:", df.shape)
print("\n前5个基因的表达:")
print(df.head())

# 计算每个细胞的总表达量
total_counts = df.sum(axis=0)
print(f"\n平均每个细胞的总表达量: {total_counts.mean():.2f}")

# 可视化
plt.figure(figsize=(12, 5))

plt.subplot(1, 2, 1)
plt.hist(total_counts, bins=20, color='skyblue', edgecolor='black')
plt.xlabel('总表达量')
plt.ylabel('细胞数')
plt.title('细胞总表达量分布')

plt.subplot(1, 2, 2)
gene_means = df.mean(axis=1)
plt.hist(gene_means, bins=20, color='lightcoral', edgecolor='black')
plt.xlabel('平均表达量')
plt.ylabel('基因数')
plt.title('基因平均表达量分布')

plt.tight_layout()
plt.show()
```

![细胞总表达量分布](/img/tutorial/module01/02-cell-counts-distribution.png)

**图 4**：细胞总表达量分布图。展示了 50 个细胞的总表达量分布情况，使用核密度估计曲线显示数据的平滑分布。

![基因平均表达量分布](/img/tutorial/module01/03-gene-mean-distribution.png)

**图 5**：基因平均表达量分布图。展示了 100 个基因的平均表达量分布，帮助识别高表达和低表达基因。

![表达矩阵热图](/img/tutorial/module01/04-expression-matrix-heatmap.png)

**图 6**：表达矩阵热图。展示了基因（行）和细胞（列）的表达模式，颜色深浅代表表达量高低。

![质量控制散点图](/img/tutorial/module01/05-qc-scatter.png)

**图 7**：质量控制散点图。展示了细胞总表达量与检测到的基因数之间的关系，用于识别低质量细胞。

![组合质量控制指标](/img/tutorial/module01/08-qc-combined.png)

**图 8**：组合质量控制指标图。包含细胞总表达量分布、检测基因数分布、表达量与基因数关系以及表达矩阵热图的综合展示。

## 关键概念

- **Jupyter Notebook**：交互式计算环境
- **Google Colab**：云端 Jupyter 环境
- **GEO**：基因表达数据库
- **SCEA**：单细胞表达图谱
- **HCA**：人类细胞图谱
- **元数据**：描述数据的数据
- **表达矩阵**：基因×细胞的数据矩阵

## 扩展资源

### 官方文档
- [Jupyter 文档](https://jupyter.org/documentation)
- [Google Colab 指南](https://colab.research.google.com/notebooks/intro.ipynb)
- [GEO 帮助](https://www.ncbi.nlm.nih.gov/geo/info/overview.html)

### 教程视频
- Jupyter Notebook 入门教程
- Google Colab 使用指南
- 生物数据库使用技巧

### 相关工具
- **JupyterLab**：下一代 Jupyter 界面
- **Binder**：在线运行 Jupyter Notebooks
- **Kaggle Kernels**：数据科学竞赛平台

## 检查清单

完成本模块后，你应该能够：

- [ ] 创建和运行 Jupyter Notebook
- [ ] 使用 Google Colab 进行在线分析
- [ ] 在 GEO 中搜索和下载数据
- [ ] 访问 SCEA 和 HCA 数据库
- [ ] 理解单细胞数据的基本结构
- [ ] 进行简单的数据可视化

## 下一步

完成本模块后，继续学习：

[R 语言和数据可视化入门](/docs/basics/r-ggplot2)

## 参考资源

本教程内容参考了以下开源项目和资源：
- scNotebooks 开源项目（CC BY 4.0 许可，仅作为内容组织和知识点参考）
- Jupyter 官方文档
- NCBI GEO 数据库文档
- Human Cell Atlas 项目

---

**版权声明**：本教程为 BioF3 原创学习资源，部分内容组织参考了 scNotebooks 开源项目，并进行了重新编写、本地化和扩展。
