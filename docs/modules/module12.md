---
sidebar_position: 12
---

# 模块12：FAIR 原则与数据共享

本模块介绍如何遵循 FAIR 原则（Findable, Accessible, Interoperable, Reusable）共享单细胞数据。

## 学习目标

- 理解 FAIR 原则
- 学习数据标准化
- 掌握数据提交流程
- 了解数据共享最佳实践

## FAIR 原则

### Findable（可发现）
- 使用持久标识符（DOI）
- 丰富的元数据
- 在数据库中注册

### Accessible（可访问）
- 标准化的访问协议
- 元数据即使数据不可用也应保留
- 明确的访问条件

### Interoperable（可互操作）
- 使用标准化格式
- 使用受控词汇
- 包含其他数据的引用

### Reusable（可重用）
- 详细的使用许可
- 准确的来源信息
- 符合社区标准

## 数据标准化

### 文件格式

推荐格式：
- **H5AD**: Scanpy/AnnData 格式
- **RDS**: Seurat 格式
- **Loom**: 通用格式
- **MEX**: 10x 稀疏矩阵格式

### 元数据标准

```r
# 必需的元数据
metadata <- data.frame(
  cell_id = colnames(seurat_obj),
  cell_type = seurat_obj$cell_type,
  sample_id = seurat_obj$orig.ident,
  tissue = "PBMC",
  disease = "healthy",
  age = 30,
  sex = "male",
  technology = "10x Chromium",
  chemistry = "v3"
)
```

## 公共数据库

### Gene Expression Omnibus (GEO)

```bash
# 准备提交文件
# 1. 原始数据（FASTQ）
# 2. 处理后的数据（表达矩阵）
# 3. 元数据表格
# 4. README 文件
```

提交步骤：
1. 访问 https://www.ncbi.nlm.nih.gov/geo/
2. 创建账号
3. 上传数据
4. 填写元数据
5. 提交审核

### Single Cell Portal

```r
# 导出为 Single Cell Portal 格式
library(Seurat)

# 导出表达矩阵
write.table(
  as.matrix(seurat_obj@assays$RNA@counts),
  file = "expression_matrix.txt",
  sep = "\t",
  quote = FALSE
)

# 导出元数据
write.table(
  seurat_obj@meta.data,
  file = "metadata.txt",
  sep = "\t",
  quote = FALSE
)

# 导出聚类坐标
write.table(
  Embeddings(seurat_obj, "umap"),
  file = "umap_coordinates.txt",
  sep = "\t",
  quote = FALSE
)
```

### CELLxGENE

在线浏览和共享单细胞数据：
- https://cellxgene.cziscience.com/

### Human Cell Atlas

贡献数据到人类细胞图谱：
- https://www.humancellatlas.org/

## 数据提交清单

### 原始数据
- [ ] FASTQ 文件
- [ ] 测序质量报告
- [ ] 实验协议

### 处理后数据
- [ ] 表达矩阵
- [ ] 细胞元数据
- [ ] 基因注释
- [ ] 降维坐标（UMAP/t-SNE）
- [ ] 聚类信息

### 分析代码
- [ ] 数据处理脚本
- [ ] 分析代码
- [ ] 可视化代码
- [ ] 软件版本信息

### 文档
- [ ] README 文件
- [ ] 方法描述
- [ ] 数据字典
- [ ] 许可证信息

## 最佳实践

### 1. 使用版本控制

```bash
# 使用 Git 管理代码
git init
git add analysis_script.R
git commit -m "Initial analysis script"
git push origin main
```

### 2. 容器化环境

```dockerfile
# Dockerfile
FROM rocker/r-ver:4.2.0

RUN R -e "install.packages('Seurat')"
RUN R -e "install.packages('dplyr')"

COPY analysis.R /home/
```

### 3. 文档化

```r
# 在代码中添加详细注释
# 创建 README.md

# README.md 内容：
# - 项目描述
# - 数据来源
# - 分析流程
# - 软件要求
# - 使用说明
# - 引用信息
```

### 4. 许可证

推荐许可证：
- **数据**: CC0, CC-BY
- **代码**: MIT, Apache 2.0
- **文档**: CC-BY

## 数据引用

### 如何引用数据

```
作者. (年份). 数据集标题. 数据库名称. DOI或URL.

示例：
Smith, J. et al. (2024). Single-cell RNA-seq of human PBMC. 
Gene Expression Omnibus. https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE123456
```

### 在论文中引用

- 在方法部分说明数据来源
- 提供数据访问号（如 GEO accession）
- 在数据可用性声明中说明

## 示例：完整的数据共享流程

### 1. 准备数据

```r
# 导出 Seurat 对象
saveRDS(seurat_obj, "pbmc_analyzed.rds")

# 导出 H5AD 格式（用于 Python）
library(SeuratDisk)
SaveH5Seurat(seurat_obj, "pbmc_analyzed.h5seurat")
Convert("pbmc_analyzed.h5seurat", "h5ad")
```

### 2. 创建元数据文件

```r
# metadata.txt
write.table(
  data.frame(
    sample_id = "PBMC_001",
    tissue = "Peripheral Blood",
    disease = "Healthy",
    age = 30,
    sex = "Male",
    technology = "10x Chromium",
    chemistry = "v3",
    sequencing_platform = "Illumina NovaSeq",
    read_length = "150bp paired-end",
    cell_count = ncol(seurat_obj),
    median_genes = median(seurat_obj$nFeature_RNA)
  ),
  "metadata.txt",
  sep = "\t",
  row.names = FALSE
)
```

### 3. 创建 README

```markdown
# PBMC Single-cell RNA-seq Dataset

## Description
Single-cell RNA sequencing of peripheral blood mononuclear cells (PBMC) 
from a healthy donor.

## Data Processing
- Quality control: nFeature > 200, nFeature < 2500, percent.mt < 5
- Normalization: LogNormalize
- Clustering: Louvain algorithm, resolution = 0.5
- Cell type annotation: Based on canonical markers

## Files
- pbmc_analyzed.rds: Seurat object
- pbmc_analyzed.h5ad: AnnData object
- expression_matrix.txt: Raw counts matrix
- metadata.txt: Cell metadata
- analysis_script.R: Analysis code

## Citation
If you use this data, please cite:
[Your paper citation]

## License
CC-BY 4.0

## Contact
[Your email]
```

### 4. 提交到 GEO

1. 压缩文件
2. 上传到 GEO
3. 填写在线表格
4. 等待审核
5. 获得 GSE 编号

## 参考资源

- [FAIR 原则](https://www.go-fair.org/fair-principles/)
- [GEO 提交指南](https://www.ncbi.nlm.nih.gov/geo/info/submission.html)
- [Single Cell Portal](https://singlecell.broadinstitute.org/single_cell)
- [数据共享最佳实践](https://www.nature.com/articles/s41597-020-0524-5)

---

## 完成课程

你已经完成了 BioF3 单细胞实践教程的全部 12 个模块！

### 下一步建议

1. **实践项目**: 使用真实数据集进行完整分析
2. **深入学习**: 选择感兴趣的主题深入研究
3. **参与社区**: 加入生物信息学社区，分享经验
4. **持续更新**: 关注新方法和新工具

### 继续学习

- [课程总览](/docs/intro)
- [基础入门](/docs/basics/overview)
- [多组学整合分析](/blog/multi-omics-integration)
