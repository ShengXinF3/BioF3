# BioF3 远程服务器发布流程

本文档说明 BioF3 从本地开发到同步远程服务器的标准流程。

## 当前结论

BioF3 是一个 Docusaurus 静态站点。开发完成后可以先在本地构建出 `build/` 目录，再通过 `ssh + rsync` 同步到远程服务器。

项目中已经有同步脚本：

```bash
scripts/deploy-biof3.sh
```

该脚本会自动执行构建，并把构建产物同步到远程服务器。

## 本地开发

进入项目目录：

```bash
cd /Users/zhangdiandian/Documents/1.WorkDir/BioinfoTools/BioF3
```

安装依赖：

```bash
npm install
```

启动开发服务器：

```bash
npm start
```

默认访问：

```text
http://localhost:3000
```

## 构建验证

发布前先执行：

```bash
npm run build
```

构建成功后会生成：

```text
build/
```

可以本地预览构建结果：

```bash
npm run serve
```

## 远程服务器准备

脚本默认配置如下：

```bash
SSH_TARGET=aliyun
REMOTE_ROOT=/opt/biof3-tutorial
SITE_URL=https://biof3.com
BASE_URL=/
```

需要保证本机可以免密或可交互登录远程服务器：

```bash
ssh aliyun
```

如果服务器别名还没有配置，可以在本机 `~/.ssh/config` 中添加类似配置：

```sshconfig
Host aliyun
  HostName your.server.ip
  User root
  Port 22
  IdentityFile ~/.ssh/id_ed25519
```

服务器上需要有目标目录的写入权限。默认目录是：

```text
/opt/biof3-tutorial
```

## 一键发布

使用默认配置发布：

```bash
bash scripts/deploy-biof3.sh
```

使用自定义服务器或目录发布：

```bash
SITE_URL=https://biof3.com \
BASE_URL=/ \
SSH_TARGET=aliyun \
REMOTE_ROOT=/opt/biof3-tutorial \
bash scripts/deploy-biof3.sh
```

脚本会在远程服务器创建类似结构：

```text
/opt/biof3-tutorial/
├── releases/
│   └── biof3-YYYYMMDD-HHMMSS/
├── current -> releases/biof3-YYYYMMDD-HHMMSS
└── current-site/
```

建议 Web 服务直接指向：

```text
/opt/biof3-tutorial/current-site
```

## Nginx 示例

如果远程服务器使用 Nginx，可以参考：

```nginx
server {
    listen 80;
    server_name biof3.com www.biof3.com;

    root /opt/biof3-tutorial/current-site;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

修改后检查并重载：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## 发布检查清单

- 本地 `npm run build` 成功
- `ssh aliyun` 可以登录
- 远程 `REMOTE_ROOT` 有写入权限
- Nginx root 指向 `current-site`
- `SITE_URL` 和实际域名一致
- 如果部署到域名根路径，`BASE_URL=/`
- 如果部署到子路径，例如 `/BioF3/`，则设置 `BASE_URL=/BioF3/`

## 当前项目状态

我已验证当前项目可以成功执行：

```bash
npm run build
```

因此项目本身已经具备发布条件。剩下主要是确认远程服务器 SSH 配置、Nginx 指向和域名解析。
