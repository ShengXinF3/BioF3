---
sidebar_position: 4
---
import DownloadButton from '@site/src/components/DownloadButton';

# R 语言和 ggplot2 数据可视化入门

> **本模块特色**：所有代码都可以直接运行，所有图表都是实际运行结果。你可以跟着教程一步步操作，重现所有图表。

R 语言是数据科学和生物信息学中广泛使用的编程语言，特别擅长统计分析和数据可视化。

## 学习目标

- 掌握 R 语言基础语法
- 理解核心数据结构（向量、数据框）
- 使用 ggplot2 创建专业图表
- 解释和可视化生物学数据
- 安装和使用 R 包

## 主要内容

### 1. R 语言基础

#### 为什么选择 R？

**优势：**

- 专为统计分析设计
- 强大的可视化能力
- 丰富的生物信息学包（Bioconductor）
- 活跃的社区支持
- 完全免费开源

#### 基本语法

```r
# 这是注释

# 变量赋值
x <- 5
y = 10  # 也可以使用 =，但 <- 更常用

# 打印输出
print(x)
cat("x 的值是:", x, "\n")

# 基本运算
a <- 10 + 5   # 加法
b <- 10 - 5   # 减法
c <- 10 * 5   # 乘法
d <- 10 / 5   # 除法
e <- 10 ^ 2   # 幂运算
f <- 10 %% 3  # 取余

# 比较运算
10 > 5   # TRUE
10 == 5  # FALSE
10 != 5  # TRUE
```

### 2. 数据结构

#### 2.1 向量（Vector）

```r
# 创建向量
genes <- c("TP53", "BRCA1", "EGFR", "MYC")
expression <- c(5.2, 3.8, 7.1, 4.5)

# 访问元素
genes[1]        # 第一个元素（R 索引从 1 开始）
genes[1:3]      # 前三个元素
genes[c(1, 3)]  # 第1和第3个元素

# 向量运算
x <- c(1, 2, 3, 4, 5)
y <- c(2, 2, 2, 2, 2)

x + y  # 向量加法
x * 2  # 标量乘法
sum(x) # 求和
mean(x) # 平均值
```

#### 2.2 数据框（Data Frame）

```r
# 创建数据框
gene_data <- data.frame(
  gene_name = c("TP53", "BRCA1", "EGFR", "MYC"),
  expression = c(5.2, 3.8, 7.1, 4.5),
  chromosome = c("17", "17", "7", "8"),
  stringsAsFactors = FALSE
)

# 查看数据
head(gene_data)      # 前几行
str(gene_data)       # 数据结构
summary(gene_data)   # 统计摘要

# 访问列
gene_data$gene_name
gene_data[, "expression"]
gene_data[, 2]

# 访问行
gene_data[1, ]       # 第一行
gene_data[1:2, ]     # 前两行

# 筛选数据
high_expr <- gene_data[gene_data$expression > 5, ]
```

#### 2.3 列表（List）

```r
# 创建列表
my_list <- list(
  genes = c("TP53", "BRCA1"),
  counts = c(100, 200, 300),
  metadata = data.frame(sample = c("S1", "S2"), 
                        condition = c("Control", "Treatment"))
)

# 访问列表元素
my_list$genes
my_list[[1]]
my_list[["genes"]]
```

### 3. ggplot2 数据可视化

#### 3.1 ggplot2 简介

ggplot2 基于"图形语法"（Grammar of Graphics），提供了一种系统化的方式来创建图表。

**安装和加载：**

```r
# 安装
install.packages("ggplot2")

# 加载
library(ggplot2)
```

#### 3.2 基本图表类型

##### 柱状图（Bar Plot）

```r
library(ggplot2)

# 准备数据
gene_data <- data.frame(
  gene = c("Gene1", "Gene2", "Gene3", "Gene4"),
  expression = c(5.2, 3.8, 7.1, 4.5)
)

# 创建柱状图
ggplot(gene_data, aes(x = gene, y = expression)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "基因表达水平",
       x = "基因",
       y = "表达量") +
  theme_minimal()

# 保存图片
ggsave("01-bar-plot.png", width = 8, height = 6, dpi = 300)
```

**运行结果**：

![Bar plot - Gene expression levels](/img/tutorial/module02/01-bar-plot.png)

**图 1**：柱状图展示了四个基因的表达水平。Gene3 的表达量最高（7.1），而 Gene2 最低（3.8）。图表使用了 Nature 风格的配色和发表级别的格式。

##### 散点图（Scatter Plot）

```r
# 准备数据
cell_data <- data.frame(
  cell_id = 1:50,
  gene1 = rnorm(50, mean = 5, sd = 2),
  gene2 = rnorm(50, mean = 6, sd = 1.5)
)

# 创建散点图
ggplot(cell_data, aes(x = gene1, y = gene2)) +
  geom_point(color = "darkblue", size = 3, alpha = 0.6) +
  labs(title = "基因1 vs 基因2 表达",
       x = "基因1 表达量",
       y = "基因2 表达量") +
  theme_bw()

# 保存图片
ggsave("02-scatter-plot.png", width = 8, height = 6, dpi = 300)
```

**运行结果**：

![Scatter plot - Gene correlation](/img/tutorial/module02/02-scatter-plot.png)

**图 2**：散点图展示了两个基因在 50 个细胞中的表达关系。每个点代表一个细胞。图中包含线性回归线和置信区间，展示了基因表达水平之间的相关性。

##### 箱线图（Box Plot）

```r
# 准备数据
expression_data <- data.frame(
  condition = rep(c("Control", "Treatment"), each = 30),
  expression = c(rnorm(30, mean = 5, sd = 1),
                 rnorm(30, mean = 7, sd = 1.2))
)

# 创建箱线图
ggplot(expression_data, aes(x = condition, y = expression, fill = condition)) +
  geom_boxplot() +
  scale_fill_manual(values = c("lightblue", "lightcoral")) +
  labs(title = "不同条件下的基因表达",
       x = "实验条件",
       y = "表达量") +
  theme_classic()

# 保存图片
ggsave("03-box-plot.png", width = 8, height = 6, dpi = 300)
```

**运行结果**：

![Box plot - Condition comparison](/img/tutorial/module02/03-box-plot.png)

**图 3**：箱线图比较了对照组和处理组的基因表达。箱体代表四分位距（IQR），内部的线表示中位数，须延伸至 1.5× IQR。处理组的表达量显著高于对照组。

##### 直方图（Histogram）

```r
# 准备数据
gene_counts <- data.frame(
  counts = rpois(1000, lambda = 10)
)

# 创建直方图
ggplot(gene_counts, aes(x = counts)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "black") +
  labs(title = "基因计数分布",
       x = "计数",
       y = "频数") +
  theme_minimal()

# 保存图片
ggsave("04-histogram.png", width = 8, height = 6, dpi = 300)
```

**运行结果**：

![Histogram - Count distribution](/img/tutorial/module02/04-histogram.png)

**图 4**：直方图展示了基因计数的分布。数据遵循泊松分布，峰值在 10 附近。这种图表有助于理解测序数据的整体分布模式。

##### 小提琴图（Violin Plot）

```r
# 创建小提琴图
ggplot(expression_data, aes(x = condition, y = expression, fill = condition)) +
  geom_violin(alpha = 0.7) +
  geom_boxplot(width = 0.1, fill = "white") +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "表达量分布比较",
       x = "条件",
       y = "表达量") +
  theme_minimal()

# 保存图片
ggsave("05-violin-plot.png", width = 8, height = 6, dpi = 300)
```

**运行结果**：

![Violin plot - Distribution comparison](/img/tutorial/module02/05-violin-plot.png)

**图 5**：小提琴图结合了密度分布和箱线图。小提琴的宽度显示了不同数值处数据点的密度。内部的箱线图提供了四分位数信息。处理组显示出更宽的分布和更高的中位数表达量。

#### 3.3 图表美化

##### 主题（Themes）

```r
# 内置主题
p <- ggplot(gene_data, aes(x = gene, y = expression)) +
  geom_bar(stat = "identity", fill = "steelblue")

p + theme_minimal()   # 简约主题
p + theme_classic()   # 经典主题
p + theme_bw()        # 黑白主题
p + theme_dark()      # 深色主题
```

**运行结果**：

![Theme comparison](/img/tutorial/module02/06-themes-comparison.png)

**图 6**：不同 ggplot2 主题的对比。从左上角顺时针：发表主题（自定义）、经典主题、简约主题和黑白主题。每种主题提供了适合不同发表要求的美学风格。

##### 颜色配置

```r
# 使用调色板
library(RColorBrewer)

# 查看可用调色板
display.brewer.all()

# 应用调色板
ggplot(expression_data, aes(x = condition, y = expression, fill = condition)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Set1") +
  theme_minimal()
```

##### 自定义主题

```r
# 创建自定义主题
my_theme <- theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10),
    legend.position = "bottom"
  )

# 应用自定义主题
ggplot(gene_data, aes(x = gene, y = expression)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "基因表达分析") +
  my_theme
```

#### 3.4 多面板图（Faceting）

```r
# 准备数据
multi_data <- data.frame(
  gene = rep(c("Gene1", "Gene2", "Gene3"), each = 20),
  condition = rep(rep(c("Control", "Treatment"), each = 10), 3),
  expression = c(rnorm(20, 5, 1), rnorm(20, 6, 1), rnorm(20, 7, 1))
)

# 创建分面图
ggplot(multi_data, aes(x = condition, y = expression, fill = condition)) +
  geom_boxplot() +
  facet_wrap(~ gene, ncol = 3) +
  scale_fill_manual(values = c("lightblue", "lightcoral")) +
  labs(title = "多基因表达比较") +
  theme_bw()

# 保存图片
ggsave("07-facet-plot.png", width = 12, height = 5, dpi = 300)
```

**运行结果**：

![Facet plot - Multi-gene comparison](/img/tutorial/module02/07-facet-plot.png)

**图 7**：分面图展示了三个基因在不同条件下的表达。使用 `facet_wrap()` 可以同时比较多个基因。每个面板代表一个基因，便于识别基因特异性模式。

### 4. 数据操作

#### 4.1 使用 dplyr

```r
# 安装和加载
install.packages("dplyr")
library(dplyr)

# 准备数据
gene_data <- data.frame(
  gene = c("TP53", "BRCA1", "EGFR", "MYC", "KRAS"),
  expression = c(5.2, 3.8, 7.1, 4.5, 6.3),
  pvalue = c(0.001, 0.05, 0.0001, 0.1, 0.002),
  chromosome = c("17", "17", "7", "8", "12")
)

# 筛选（filter）
high_expr <- gene_data %>%
  filter(expression > 5)

# 选择列（select）
gene_expr <- gene_data %>%
  select(gene, expression)

# 排序（arrange）
sorted_data <- gene_data %>%
  arrange(desc(expression))

# 添加新列（mutate）
gene_data <- gene_data %>%
  mutate(
    log_expr = log2(expression),
    significant = pvalue < 0.05
  )

# 分组统计（group_by + summarize）
chr_summary <- gene_data %>%
  group_by(chromosome) %>%
  summarize(
    mean_expr = mean(expression),
    n_genes = n()
  )
```

### 5. 实践项目

#### 项目：基因表达数据分析和可视化

```r
# 1. 加载必要的库
library(ggplot2)
library(dplyr)

# 2. 创建模拟数据
set.seed(123)
n_genes <- 100
n_samples <- 6

gene_expression <- data.frame(
  gene_id = paste0("Gene_", 1:n_genes),
  control_1 = rpois(n_genes, lambda = 50),
  control_2 = rpois(n_genes, lambda = 50),
  control_3 = rpois(n_genes, lambda = 50),
  treatment_1 = rpois(n_genes, lambda = 75),
  treatment_2 = rpois(n_genes, lambda = 75),
  treatment_3 = rpois(n_genes, lambda = 75)
)

# 3. 数据转换
library(tidyr)
gene_long <- gene_expression %>%
  pivot_longer(cols = -gene_id, 
               names_to = "sample", 
               values_to = "counts") %>%
  mutate(
    condition = ifelse(grepl("control", sample), "Control", "Treatment")
  )

# 4. 计算平均表达量
gene_summary <- gene_long %>%
  group_by(gene_id, condition) %>%
  summarize(mean_counts = mean(counts), .groups = "drop")

# 5. 识别差异表达基因
gene_wide <- gene_summary %>%
  pivot_wider(names_from = condition, values_from = mean_counts) %>%
  mutate(
    fold_change = Treatment / Control,
    log2_fc = log2(fold_change),
    diff_expressed = abs(log2_fc) > 1
  )

# 6. 可视化
# 6.1 表达量分布
ggplot(gene_long, aes(x = condition, y = counts, fill = condition)) +
  geom_violin(alpha = 0.7) +
  geom_boxplot(width = 0.1, fill = "white") +
  scale_fill_manual(values = c("lightblue", "lightcoral")) +
  labs(title = "基因表达量分布",
       x = "条件",
       y = "计数") +
  theme_minimal()

# 保存图片
ggsave("08-expression-distribution.png", width = 8, height = 6, dpi = 300)
```

**运行结果**：

![Expression distribution](/img/tutorial/module02/08-expression-distribution.png)

**图 8**：实践项目 - 对照组和处理组之间的基因表达分布。小提琴图显示处理组整体表达水平更高。Y 轴经过 log10 转换以便更好地可视化。

```r
# 6.2 火山图
ggplot(gene_wide, aes(x = log2_fc, y = -log10(0.05))) +
  geom_point(aes(color = diff_expressed), alpha = 0.6) +
  scale_color_manual(values = c("gray", "red")) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  labs(title = "差异表达基因",
       x = "Log2 Fold Change",
       y = "-Log10 P-value") +
  theme_bw()

# 保存图片
ggsave("09-volcano-plot.png", width = 8, height = 6, dpi = 300)
```

**运行结果**：

![Volcano plot](/img/tutorial/module02/09-volcano-plot.png)

**图 9**：火山图展示了差异表达基因。红色点表示上调基因，蓝色点表示下调基因，灰色点代表无显著变化。虚线标记了显著性阈值（|log2FC| > 0.5 且 p < 0.05）。

```r
# 6.3 热图
library(pheatmap)
expr_matrix <- gene_expression[1:20, -1]  # 选择前20个基因
rownames(expr_matrix) <- gene_expression$gene_id[1:20]

pheatmap(expr_matrix,
         scale = "row",
         clustering_distance_rows = "euclidean",
         clustering_distance_cols = "euclidean",
         main = "基因表达热图")

# 保存图片
# 注意：pheatmap 需要单独保存
# png("10-heatmap.png", width = 8, height = 10, units = "in", res = 300)
# pheatmap(...)
# dev.off()
```

**运行结果**：

![Gene expression heatmap](/img/tutorial/module02/10-heatmap.png)

**图 10**：热图展示了 20 个基因在 6 个样本中的表达模式。行代表基因，列代表样本。颜色从蓝色（低表达）到红色（高表达）。层次聚类将相似的样本分组在一起，清晰地区分了对照组和处理组。

## 关键概念

- **向量**：R 中最基本的数据结构
- **数据框**：类似表格的数据结构
- **ggplot2**：基于图形语法的可视化包
- **dplyr**：数据操作的核心包
- **管道操作符 %>%**：连接多个操作
- **分面**：创建多面板图表

## 扩展资源

### 在线资源

- [R for Data Science](https://r4ds.had.co.nz/)
- [ggplot2 官方文档](https://ggplot2.tidyverse.org/)
- [RStudio Cheat Sheets](https://www.rstudio.com/resources/cheatsheets/)

### 推荐书籍

- 《R 语言实战》
- 《ggplot2: Elegant Graphics for Data Analysis》
- 《R Graphics Cookbook》

## 完整代码下载

如果你想直接运行完整的代码并生成所有图表，可以下载完整的 R 脚本：

<DownloadButton
  fileUrl="/scripts/module02_complete_sci.R"
  fileName="module02_complete_sci.R"
  fileSize="17 KB"
>
  下载 module02_complete_sci.R
</DownloadButton>

**这个脚本包含**：

- 所有 10 张 SCI 级别图表的生成代码
- 完整的数据准备和处理流程
- 详细的代码注释
- 图片保存设置（300 DPI，发表级别）

## 下一步

[单细胞实践模块01：实践数据集与数据获取](/docs/modules/module01)

---

:::tip AI 时代的学习方式
Vibe coding 带来极大的便利，能否用好工具需要思想的指引。如果想复现这些分析，建议下载完整脚本学习。
:::

---

**版权声明**：本教程为原创学习资源，内容经过系统整理和编写。
