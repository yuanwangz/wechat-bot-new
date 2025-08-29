# wechat-bot

运行在docker中的微信机器人支持批量部署代理设置。
文件发送与接收图片解析多语言sdk，http接口方便对接。

![Build Status](https://github.com/用户名/wechat-bot-new/actions/workflows/build-docker-image.yml/badge.svg)

## 🚀 自动化构建

本项目配置了 GitHub Actions 自动化 CI/CD 流水线：

- **自动构建**：推送代码到 `main` 分支时自动构建 Docker 镜像
- **版本发布**：推送 `v*.*.*` 格式标签时自动构建发布版本
- **多架构支持**：同时构建 `linux/amd64` 和 `linux/arm64`
- **镜像仓库**：自动推送到 GitHub 容器注册表 (ghcr.io)

### 使用预构建镜像

```bash
# 拉取最新版本
docker pull ghcr.io/用户名/wechat-bot-new:latest

# 拉取指定版本
docker pull ghcr.io/用户名/wechat-bot-new:v1.0.0
```

# docker-compose
```yaml
version: "2.4"
services:
  wechat-bot:
    # 使用 GitHub 容器注册表的镜像（推荐）
    image: ghcr.io/用户名/wechat-bot-new:latest
    # 或者使用原镜像：
    # image: danbai225/wechat-bot:latest
    container_name: wechat-bot
    restart: always
    ports:
      - "8080:8080"
      - "5555:5555"
      - "5556:5556"
      - "5900:5900"
    extra_hosts:
      - "dldir1.qq.com:127.0.0.1"
    volumes:
      - "./data:/home/app/data"
      - "./wxFiles:/home/app/WeChat Files"
    environment:
      #- PROXY_IP=1.1.1.115 #如果设置则使用代理
      - PROXY_PORT=7777
      - PROXY_USER=user
      - PROXY_PASS=pass
```

# use

```go
package main

import (
	logs "github.com/danbai225/go-logs"
	wechatbot "github.com/danbai225/wechat-bot"
)

func main() {
	client, err := wechatbot.NewClient("ws://serverIP:5555", "http://serverIP:5556")
	if err != nil {
		logs.Err(err)
		return
	}
	client.SetOnWXmsg(func(msg []byte, Type int, reply *wechatbot.Reply) {
		if Type == 1 {
			logs.Info(string(msg))
		}
	})
	select {}
}

```