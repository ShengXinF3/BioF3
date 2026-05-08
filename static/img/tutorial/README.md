# 教程图片目录

本目录存放 BioF3 教程中使用的所有图片。

## 目录结构

```
tutorial/
├── module01/          # 模块 01：Jupyter Notebooks 和数据库
├── module02/          # 模块 02：R 语言和 ggplot2
├── module03/          # 模块 03：原始数据处理
├── module04/          # 模块 04：质量控制和聚类
├── module05/          # 模块 05：数据整合
├── module06/          # 模块 06：轨迹推断
├── module07/          # 模块 07：细胞通讯
├── module08/          # 模块 08：多模态分析
├── module09/          # 模块 09：TCR/BCR 测序
├── module10/          # 模块 10：空间转录组
├── module11/          # 模块 11：scATAC-seq
├── module12/          # 模块 12：选择性多聚腺苷酸化
└── module13/          # 模块 13：数据共享
```

## 图片命名规范

- 使用小写字母和连字符
- 使用描述性名称
- 避免空格和特殊字符

**示例**：
- ✅ `jupyter-notebook-interface.png`
- ✅ `umap-clustering-result.png`
- ✅ `cellranger-workflow.png`
- ❌ `图片1.png`
- ❌ `Screenshot 2024-05-06.png`

## 图片格式建议

- **PNG**：截图、示意图（支持透明背景）
- **JPG**：照片、复杂图像（文件更小）
- **SVG**：矢量图、图标（可缩放）

## 图片大小建议

- 宽度：800-1200px
- 文件大小：< 500KB（压缩后）

## 如何添加图片

### 1. 将图片放到对应模块目录

```bash
cp your-image.png static/img/tutorial/module01/
```

### 2. 在 Markdown 中引用

```markdown
![图片描述](/img/tutorial/module01/your-image.png)
```

### 3. 查看效果

访问 http://localhost:3000 查看效果。

## 图片压缩

使用 TinyPNG 压缩图片：https://tinypng.com/

或使用命令行：

```bash
# 安装 ImageMagick
brew install imagemagick

# 压缩图片
convert input.png -quality 85 -resize 1200x output.png
```

## 注意事项

- 图片文件名不要包含中文
- 图片路径区分大小写
- 提交前检查图片是否正确显示
- 大图片（> 1MB）建议压缩后再提交

更多内容维护规则见项目根目录的 `CONTENT_MAINTENANCE.md`。
