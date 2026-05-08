#!/usr/bin/env python3
"""
BioF3 博客 API 客户端

通过 GitHub API 发布、更新和管理博客文章
"""

import requests
import base64
from datetime import datetime
from typing import List, Optional
import json


class BioF3BlogAPI:
    """BioF3 博客 API 客户端"""
    
    def __init__(self, github_token: str, repo_owner: str = "ShengXinF3", 
                 repo_name: str = "BioF3", branch: str = "main"):
        """
        初始化 API 客户端
        
        Args:
            github_token: GitHub Personal Access Token
            repo_owner: 仓库所有者
            repo_name: 仓库名称
            branch: 分支名称
        """
        self.token = github_token
        self.owner = repo_owner
        self.repo = repo_name
        self.branch = branch
        self.base_url = f"https://api.github.com/repos/{repo_owner}/{repo_name}"
        self.headers = {
            "Authorization": f"token {github_token}",
            "Accept": "application/vnd.github.v3+json"
        }
    
    def create_blog_post(self, 
                        title: str, 
                        content: str, 
                        author: str, 
                        tags: List[str],
                        slug: Optional[str] = None,
                        date: Optional[str] = None) -> dict:
        """
        创建新的博客文章
        
        Args:
            title: 文章标题
            content: 文章内容（Markdown 格式）
            author: 作者 ID (ddd, lll, zzz, biof3)
            tags: 标签列表
            slug: URL slug（可选，默认从标题生成）
            date: 发布日期（可选，默认今天）
        
        Returns:
            GitHub API 响应
        """
        # 生成文件名
        if not date:
            date = datetime.now().strftime("%Y-%m-%d")
        
        if not slug:
            # 从标题生成 slug（简单处理）
            slug = title.lower().replace(" ", "-").replace("：", "-")
            # 移除特殊字符
            slug = ''.join(c for c in slug if c.isalnum() or c == '-')
        
        filename = f"blog/{date}-{slug}.md"
        
        # 构建 Markdown 内容
        tags_str = ', '.join(tags)
        front_matter = f"""---
slug: {slug}
title: {title}
authors: [{author}]
tags: [{tags_str}]
---

{content}
"""
        
        # Base64 编码
        content_encoded = base64.b64encode(front_matter.encode()).decode()
        
        # 提交到 GitHub
        url = f"{self.base_url}/contents/{filename}"
        data = {
            "message": f"Add blog post: {title}",
            "content": content_encoded,
            "branch": self.branch
        }
        
        response = requests.put(url, headers=self.headers, json=data)
        
        if response.status_code == 201:
            print(f"✅ 文章创建成功: {filename}")
            print(f"📝 URL: /blog/{slug}")
        else:
            print(f"❌ 创建失败: {response.json()}")
        
        return response.json()
    
    def update_blog_post(self, 
                        filename: str, 
                        content: str, 
                        commit_message: Optional[str] = None) -> dict:
        """
        更新现有博客文章
        
        Args:
            filename: 文件名（如 blog/2024-05-06-welcome.md）
            content: 新的文章内容
            commit_message: 提交信息（可选）
        
        Returns:
            GitHub API 响应
        """
        # 获取文件的 SHA（必需）
        url = f"{self.base_url}/contents/{filename}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code != 200:
            print(f"❌ 文件不存在: {filename}")
            return response.json()
        
        file_sha = response.json()['sha']
        
        # Base64 编码新内容
        content_encoded = base64.b64encode(content.encode()).decode()
        
        # 更新文件
        if not commit_message:
            commit_message = f"Update blog post: {filename}"
        
        data = {
            "message": commit_message,
            "content": content_encoded,
            "sha": file_sha,
            "branch": self.branch
        }
        
        response = requests.put(url, headers=self.headers, json=data)
        
        if response.status_code == 200:
            print(f"✅ 文章更新成功: {filename}")
        else:
            print(f"❌ 更新失败: {response.json()}")
        
        return response.json()
    
    def delete_blog_post(self, filename: str) -> dict:
        """
        删除博客文章
        
        Args:
            filename: 文件名（如 blog/2024-05-06-welcome.md）
        
        Returns:
            GitHub API 响应
        """
        # 获取文件的 SHA
        url = f"{self.base_url}/contents/{filename}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code != 200:
            print(f"❌ 文件不存在: {filename}")
            return response.json()
        
        file_sha = response.json()['sha']
        
        # 删除文件
        data = {
            "message": f"Delete blog post: {filename}",
            "sha": file_sha,
            "branch": self.branch
        }
        
        response = requests.delete(url, headers=self.headers, json=data)
        
        if response.status_code == 200:
            print(f"✅ 文章删除成功: {filename}")
        else:
            print(f"❌ 删除失败: {response.json()}")
        
        return response.json()
    
    def list_blog_posts(self) -> List[dict]:
        """
        获取所有博客文章列表
        
        Returns:
            博客文章列表
        """
        url = f"{self.base_url}/contents/blog"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            files = response.json()
            md_files = [f for f in files if f['name'].endswith('.md')]
            print(f"📚 找到 {len(md_files)} 篇博客文章")
            return md_files
        else:
            print(f"❌ 获取列表失败: {response.json()}")
            return []
    
    def get_blog_content(self, filename: str) -> str:
        """
        获取博客文章内容
        
        Args:
            filename: 文件名
        
        Returns:
            文章内容（Markdown）
        """
        url = f"{self.base_url}/contents/{filename}"
        response = requests.get(url, headers=self.headers)
        
        if response.status_code == 200:
            content_encoded = response.json()['content']
            content = base64.b64decode(content_encoded).decode()
            return content
        else:
            print(f"❌ 获取内容失败: {response.json()}")
            return ""


# 使用示例
if __name__ == "__main__":
    # 配置（请替换为你的 GitHub Token）
    GITHUB_TOKEN = "your_github_personal_access_token_here"
    
    # 初始化 API 客户端
    api = BioF3BlogAPI(github_token=GITHUB_TOKEN)
    
    # 示例 1: 创建新文章
    print("\n=== 创建新文章 ===")
    api.create_blog_post(
        title="Python 在生物信息学中的应用",
        content="""Python 是生物信息学中最流行的编程语言之一。

## 为什么选择 Python？

1. **简单易学**: 语法清晰，适合初学者
2. **丰富的库**: Biopython, Pandas, NumPy 等
3. **强大的社区**: 大量的教程和资源

## 常用库

### Biopython

```python
from Bio import SeqIO

# 读取 FASTA 文件
for record in SeqIO.parse("sequence.fasta", "fasta"):
    print(record.id, len(record.seq))
```

### Pandas

```python
import pandas as pd

# 读取表达矩阵
expr = pd.read_csv("expression.csv", index_col=0)
print(expr.head())
```

## 总结

Python 是生物信息学分析的首选语言！
""",
        author="ddd",
        tags=["Python", "教程", "编程"],
        slug="python-in-bioinformatics"
    )
    
    # 示例 2: 列出所有文章
    print("\n=== 博客文章列表 ===")
    posts = api.list_blog_posts()
    for post in posts:
        print(f"  - {post['name']}")
    
    # 示例 3: 获取文章内容
    if posts:
        print(f"\n=== 读取文章内容 ===")
        content = api.get_blog_content(f"blog/{posts[0]['name']}")
        print(content[:200] + "...")
    
    # 示例 4: 更新文章
    # api.update_blog_post(
    #     filename="blog/2024-05-06-welcome-to-biof3.md",
    #     content="更新后的内容...",
    #     commit_message="Update welcome post"
    # )
    
    # 示例 5: 删除文章
    # api.delete_blog_post("blog/2024-05-10-test.md")
