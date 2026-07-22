# musicdl-web

这是一个基于 [musicdl](https://github.com/CharlesPikachu/musicdl) 的个人学习项目，用于研究 Python 音乐检索工具、Web 播放界面、Docker 部署和本地化配置流程。

本仓库保留 musicdl 的核心能力，并在示例 Web 播放器上做了一些适合自用部署的改造：

- 修复 Web 示例的流式搜索调用兼容问题。
- 增加右上角设置入口，可在本地保存各音乐源的 Cookie 配置。
- 增加 Dockerfile 和 GHCR 自动构建 workflow，方便部署到 NAS 或其他自有环境。
- 将下载目录、Cookie 配置目录与运行输出目录从镜像中排除，便于使用 volume 持久化。

## 使用说明

本项目仅供学习、研究和个人实验使用。请遵守相关服务条款和所在地法律法规，不要将本项目用于商业用途或任何未授权用途。

## Web 播放器

本仓库主要使用示例：

```text
examples/claudeai-modern-web-music-player
```

本地运行：

```bash
cd examples/claudeai-modern-web-music-player
pip install -r requirements.txt
python app.py
```

浏览器打开：

```text
http://127.0.0.1:5000
```

## Docker

镜像会由 GitHub Actions 自动发布到 GHCR：

```text
ghcr.io/a3318375/musicdl-web:latest
```

运行示例：

```bash
docker run -d --name musicdl-web -p 5000:5000 \
  -v /path/to/downloads:/app/examples/claudeai-modern-web-music-player/downloads \
  -v /path/to/config:/app/examples/claudeai-modern-web-music-player/config \
  ghcr.io/a3318375/musicdl-web:latest
```

## Cookie 配置

Web 界面右上角的设置按钮可保存 Cookie。配置会写入本地挂载目录中的文本文件，例如：

```text
config/<MusicClient>.cookie
```

这些文件只用于本地运行环境，已经被 `.gitignore` 和 `.dockerignore` 排除，不应提交到仓库。

## 上游项目

核心能力来自原项目：

```text
https://github.com/CharlesPikachu/musicdl
```

后续同步上游更新时，建议保留本仓库的个人部署改造，并谨慎处理冲突。
