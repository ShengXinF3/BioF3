---
sidebar_position: 2
---

# 编程基础

做组学数据分析，编程是绕不过去的。这不是因为编程很酷，而是因为数据量太大，手工处理根本不现实。

这篇文章会告诉你需要学什么、怎么学，以及如何快速上手。

## 为什么必须学编程

### 数据量的问题

一个单细胞实验可能有 10000 个细胞，20000 个基因。这是 2 亿个数据点。Excel 最多支持 100 万行，根本打不开。

即使能打开，手工操作也不现实。你需要：
- 过滤低质量细胞
- 标准化表达量
- 降维聚类
- 差异分析
- 绘制几十张图

这些操作用代码几分钟就能完成，手工操作可能要几天。

### 可重复性的问题

科学研究要求结果可重复。如果你手工点鼠标做分析，别人无法重复你的操作。

但如果你写成代码，别人拿到你的脚本和数据，就能完全重现你的结果。审稿人要求提供代码，也是这个原因。

### 灵活性的问题

现成的软件功能有限，不一定满足你的需求。会编程就能自己定制分析流程，实现任何想法。

## 学哪种语言

### R 语言

**为什么选 R**

单细胞分析的主流工具都是 R 写的：
- Seurat：最流行的单细胞分析包
- Monocle：轨迹推断
- CellChat：细胞通讯分析
- Bioconductor：上千个生物信息学包

R 的优势在于统计分析和可视化。ggplot2 绘图系统非常强大，几行代码就能画出发表级的图。

**R 的缺点**

语法有点奇怪，和其他语言不太一样。数据处理速度比 Python 慢。但对于大多数分析任务，这不是问题。

**适合场景**
- 单细胞数据分析
- 统计检验
- 数据可视化
- 差异表达分析

### Python

**为什么选 Python**

Python 是通用编程语言，应用范围更广：
- Scanpy：Python 版的 Seurat
- 机器学习（scikit-learn、PyTorch）
- 深度学习
- 数据处理（pandas、numpy）

Python 语法简洁，容易学。如果你以后想做机器学习、深度学习，Python 是必选。

**适合场景**
- 数据预处理
- 机器学习
- 深度学习
- 工具开发

### Bash/Shell

**为什么要学**

很多生物信息学工具只有命令行版本，比如：
- Cell Ranger：10x 数据处理
- STAR：序列比对
- FastQC：质量控制

你需要会用 Linux 命令行来运行这些工具。

**学到什么程度**

不需要精通，会基本操作就行：
- 文件操作（ls、cd、cp、mv）
- 文本处理（cat、grep、awk）
- 流程控制（for 循环、if 判断）
- 任务管理（后台运行、查看进程）

### 建议

**如果你是新手**：先学 R，因为单细胞分析主要用 R。等熟练了再学 Python。

**如果你有编程基础**：R 和 Python 都学，根据任务选择合适的工具。

**如果你只想快速上手**：跟着教程敲代码，先把流程跑通，再慢慢理解原理。

## R 语言快速入门

### 安装

1. 下载安装 R：https://www.r-project.org/
2. 下载安装 RStudio：https://posit.co/download/rstudio-desktop/

RStudio 是 R 的集成开发环境，比原生的 R 界面好用得多。

### 基本语法

```r
# 变量赋值
x <- 10
y <- 20
z <- x + y

# 向量
genes <- c("TP53", "BRCA1", "EGFR")
expression <- c(5.2, 3.8, 7.1)

# 数据框（类似 Excel 表格）
data <- data.frame(
  gene = genes,
  expr = expression
)

# 查看数据
print(data)
head(data)  # 前几行
tail(data)  # 后几行

# 访问列
data$gene
data$expr

# 条件筛选
high_expr <- data[data$expr > 5, ]
```

### 读取数据

```r
# 读取 CSV 文件
data <- read.csv("expression.csv")

# 读取 TSV 文件
data <- read.table("expression.txt", header = TRUE, sep = "\t")

# 读取 RDS 文件（R 专用格式）
seurat_obj <- readRDS("pbmc.rds")
```

### 数据处理

```r
# 安装 dplyr 包（数据处理神器）
install.packages("dplyr")
library(dplyr)

# 筛选行
filtered <- data %>% filter(expr > 5)

# 选择列
selected <- data %>% select(gene, expr)

# 排序
sorted <- data %>% arrange(desc(expr))

# 添加新列
data <- data %>% mutate(log_expr = log2(expr))

# 分组统计
summary <- data %>%
  group_by(cell_type) %>%
  summarise(mean_expr = mean(expr))
```

### 可视化

```r
# 安装 ggplot2
install.packages("ggplot2")
library(ggplot2)

# 散点图
ggplot(data, aes(x = gene, y = expr)) +
  geom_point() +
  theme_minimal()

# 柱状图
ggplot(data, aes(x = gene, y = expr)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "基因表达量", x = "基因", y = "表达量") +
  theme_minimal()

# 小提琴图
ggplot(data, aes(x = cell_type, y = expr)) +
  geom_violin(fill = "lightblue") +
  geom_jitter(width = 0.1, alpha = 0.5) +
  theme_minimal()
```

## Python 快速入门

### 安装

推荐用 Anaconda，它包含了 Python 和常用的科学计算包。

下载地址：https://www.anaconda.com/download

### 基本语法

```python
# 变量赋值
x = 10
y = 20
z = x + y

# 列表
genes = ["TP53", "BRCA1", "EGFR"]
expression = [5.2, 3.8, 7.1]

# 字典
gene_info = {
    "name": "TP53",
    "chr": "17",
    "length": 20000
}

# 访问元素
print(genes[0])  # 第一个元素
print(gene_info["name"])

# 循环
for gene in genes:
    print(gene)

# 条件判断
if expression[0] > 5:
    print("高表达")
else:
    print("低表达")
```

### 数据处理

```python
# 导入 pandas
import pandas as pd

# 读取 CSV
data = pd.read_csv("expression.csv")

# 查看数据
print(data.head())
print(data.shape)  # 行数和列数

# 筛选
high_expr = data[data['expr'] > 5]

# 排序
sorted_data = data.sort_values('expr', ascending=False)

# 添加新列
data['log_expr'] = np.log2(data['expr'])

# 分组统计
summary = data.groupby('cell_type')['expr'].mean()
```

### 可视化

```python
import matplotlib.pyplot as plt
import seaborn as sns

# 散点图
plt.scatter(data['gene'], data['expr'])
plt.xlabel('Gene')
plt.ylabel('Expression')
plt.show()

# 柱状图
plt.bar(data['gene'], data['expr'])
plt.xticks(rotation=45)
plt.show()

# 热图
sns.heatmap(expression_matrix, cmap='viridis')
plt.show()
```

## Bash 基础

### 常用命令

```bash
# 查看当前目录
pwd

# 列出文件
ls
ls -lh  # 详细信息

# 切换目录
cd /path/to/directory
cd ..  # 上一级目录
cd ~   # 家目录

# 创建目录
mkdir results

# 复制文件
cp file1.txt file2.txt

# 移动/重命名
mv old_name.txt new_name.txt

# 删除文件
rm file.txt
rm -r directory/  # 删除目录

# 查看文件内容
cat file.txt
head file.txt  # 前 10 行
tail file.txt  # 后 10 行
less file.txt  # 分页查看
```

### 文本处理

```bash
# 搜索文件内容
grep "pattern" file.txt
grep -r "pattern" directory/  # 递归搜索

# 统计行数
wc -l file.txt

# 排序
sort file.txt
sort -n numbers.txt  # 数值排序

# 去重
sort file.txt | uniq

# 替换
sed 's/old/new/g' file.txt
```

### 批量处理

```bash
# 循环处理多个文件
for file in *.fastq; do
    echo "Processing $file"
    fastqc $file -o qc_results/
done

# 条件判断
if [ -f "file.txt" ]; then
    echo "文件存在"
else
    echo "文件不存在"
fi
```

## 学习路径

### 第 1 周：基础语法

选择 R 或 Python，学习基本语法：
- 变量和数据类型
- 条件判断和循环
- 函数定义
- 文件读写

**练习**：写一个脚本读取 CSV 文件，计算某一列的平均值。

### 第 2-3 周：数据处理

学习数据处理库：
- R：dplyr、tidyr
- Python：pandas、numpy

**练习**：读取基因表达矩阵，筛选高表达基因，计算统计量。

### 第 4-5 周：可视化

学习绘图：
- R：ggplot2
- Python：matplotlib、seaborn

**练习**：绘制散点图、柱状图、热图。

### 第 6-8 周：实战项目

跟着教程完整跑一遍单细胞分析流程。不要求理解每个细节，先把流程跑通。

推荐从[单细胞实践模块 01](/docs/modules/module01) 开始。

## 学习资源

### 在线教程

**R 语言**
- R for Data Science：https://r4ds.had.co.nz/
- Swirl（交互式学习）：在 R 中运行 `install.packages("swirl")`

**Python**
- Python 官方教程：https://docs.python.org/zh-cn/3/tutorial/
- Kaggle Learn：https://www.kaggle.com/learn

**Bash**
- Linux 命令行基础：https://www.runoob.com/linux/linux-tutorial.html

### 练习平台

- **Rosalind**：http://rosalind.info/ - 生物信息学编程练习
- **LeetCode**：https://leetcode.cn/ - 算法练习（可选）

### 书籍

- 《R 语言实战》（R in Action）
- 《Python 编程：从入门到实践》
- 《鸟哥的 Linux 私房菜》

## 常见问题

### 我没有编程基础，能学会吗？

能。很多生物学背景的人都是从零开始学的。关键是多练习，不要怕出错。

### 要学到什么程度？

不需要成为程序员。能看懂代码、修改参数、调试错误就够了。

### R 和 Python 必须都学吗？

不是。先学一个，熟练后再学另一个。大多数分析任务用一种语言就能完成。

### 遇到错误怎么办？

1. 仔细看错误信息，通常会告诉你哪里出错了
2. 复制错误信息到 Google 搜索
3. 在 Stack Overflow、Biostars 等网站提问
4. 检查拼写、括号、引号是否匹配

### 代码运行很慢怎么办？

1. 检查是否有死循环
2. 用更高效的函数（比如 R 中用 apply 代替 for 循环）
3. 减少数据量测试
4. 考虑用更快的语言（Python 比 R 快）

## 实用技巧

### 1. 用好 IDE

RStudio 和 Jupyter Notebook 都有代码补全、语法高亮、调试功能。学会用这些功能能提高效率。

### 2. 写注释

```r
# 计算 GC 含量
# 输入：DNA 序列字符串
# 输出：GC 含量（0-1 之间）
calculate_gc <- function(seq) {
  gc_count <- str_count(seq, "[GC]")
  return(gc_count / nchar(seq))
}
```

几个月后你会忘记代码的逻辑，注释能帮你快速回忆。

### 3. 模块化

把代码分成小函数，每个函数做一件事。这样容易调试和重用。

```r
# 不好的写法：一个很长的脚本
data <- read.csv("data.csv")
data <- data[data$expr > 5, ]
data$log_expr <- log2(data$expr)
# ... 100 行代码

# 好的写法：分成多个函数
load_data <- function(file) {
  read.csv(file)
}

filter_high_expr <- function(data, threshold = 5) {
  data[data$expr > threshold, ]
}

add_log_expr <- function(data) {
  data$log_expr <- log2(data$expr)
  return(data)
}

# 主流程
data <- load_data("data.csv")
data <- filter_high_expr(data)
data <- add_log_expr(data)
```

### 4. 版本控制

用 Git 管理代码。即使你不和别人协作，版本控制也能帮你追溯历史、恢复误删的代码。

```bash
# 初始化仓库
git init

# 添加文件
git add analysis.R

# 提交
git commit -m "完成数据预处理"

# 查看历史
git log
```

## 下一步

掌握了编程基础，你就可以开始学习具体的分析方法了：

- [Jupyter Notebooks 和数据库](/docs/basics/jupyter-databases)
- [R 语言和 ggplot2 可视化](/docs/basics/r-ggplot2)
- [单细胞实践模块 01](/docs/modules/module01) - 实践数据集与数据获取

---

编程能力是练出来的，不是看出来的。看完这篇文章，打开 RStudio 或 Jupyter Notebook，开始敲代码吧。
