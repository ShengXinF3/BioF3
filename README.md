# BioF3 - 组学数据分析实践教程

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Built with Docusaurus](https://img.shields.io/badge/Built%20with-Docusaurus-blue)](https://docusaurus.io/)

## 关于 BioF3

BioF3 是一个专注于生物组学数据分析的中文学习平台。我们提供系统化、实践导向的教程，涵盖基因组学、转录组学、蛋白质组学、表观组学等多个领域。

**BioF3 = Bio + F3**
- **Bio**: 生物信息学 (Bioinformatics)
- **F3**: 代表我们的团队标识

## 项目定位

本仓库的主项目是 `BioF3` 网站本身。开发、构建、部署和内容维护均以当前 Docusaurus 项目为准。

工作区中可能临时保留 `scNotebooks` 等开源资料目录，它们仅作为课程内容设计和知识点组织的参考来源，不是 BioF3 的运行依赖，也不是项目主导结构。后续整理仓库时可以删除这些参考资料目录。

## 特色

- **全面覆盖**：多个组学领域的完整教程
- **实践导向**：丰富的代码示例和真实案例
- **中文友好**：完整的中文教程和详细注释
- **持续更新**：紧跟领域最新发展

## 教程内容

### 基因组学
- 全基因组测序分析
- 变异检测和注释
- 群体遗传学

### 转录组学
- **单细胞转录组**（13个核心模块）
- bulk RNA-seq 分析
- 空间转录组学

### 表观组学
- ChIP-seq 分析
- ATAC-seq 分析
- DNA 甲基化

### 蛋白质组学
- 质谱数据分析
- 蛋白质定量

### 整合分析
- 多组学整合
- 网络分析
- 机器学习应用

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/ShengXinF3/BioF3.git
cd BioF3

# 安装依赖
npm install

# 启动开发服务器
npm start
```

访问 http://localhost:3000

## 技术栈

- **框架**: Docusaurus v3
- **语言**: TypeScript, Markdown
- **部署**: Vercel / Netlify / 自建远程服务器（SSH + rsync）

## 部署

### Vercel（推荐）

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/ShengXinF3/BioF3)

### Netlify

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/ShengXinF3/BioF3)

### 远程服务器同步

项目已提供静态站点同步脚本：[`scripts/deploy-biof3.sh`](./scripts/deploy-biof3.sh)

```bash
bash scripts/deploy-biof3.sh
```

默认会：

- 先执行 `npm run build`
- 通过 `ssh` 创建远程目录
- 使用 `rsync` 同步 `build/`
- 切换远程站点指向最新发布版本

可通过环境变量覆盖默认值：

```bash
SITE_URL=https://biof3.com \
BASE_URL=/ \
SSH_TARGET=aliyun \
REMOTE_ROOT=/opt/biof3-tutorial \
bash scripts/deploy-biof3.sh
```

## 贡献

新增教程、博客、图片和脚本资源时，请参考 [CONTENT_MAINTENANCE.md](./CONTENT_MAINTENANCE.md)。

## 许可证

[MIT License](LICENSE) © 2026 ShengXinF3

## 联系

- **GitHub**: [@ShengXinF3](https://github.com/ShengXinF3)
- **Issues**: [提交问题](https://github.com/ShengXinF3/BioF3/issues)
- **Discussions**: [参与讨论](https://github.com/ShengXinF3/BioF3/discussions)

---

Built by BioF3 Team.
