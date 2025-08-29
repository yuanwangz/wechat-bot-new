# GitHub Actions Docker 镜像构建说明

本项目配置了 GitHub Actions 自动化工作流，用于构建和推送 Docker 镜像到 GitHub 容器注册表 (GHCR)。

## 功能特性

- ✅ 自动触发：推送到 `main` 或 `master` 分支时自动构建
- ✅ 标签构建：推送 `v*.*.*` 格式的标签时自动构建发布版本
- ✅ 多架构支持：同时构建 `linux/amd64` 和 `linux/arm64` 架构
- ✅ 智能标签：根据分支和标签自动生成 Docker 镜像标签
- ✅ 缓存优化：使用 GitHub Actions 缓存加速构建
- ✅ 安全认证：使用 GitHub Token 进行身份验证

## 触发条件

### 自动触发
1. **推送到主分支**：推送代码到 `main` 或 `master` 分支
2. **创建版本标签**：推送符合 `v*.*.*` 格式的标签（如 `v1.0.0`、`v2.1.3`）
3. **Pull Request**：创建 PR 时会构建但不推送镜像

### 手动触发
可以在 GitHub Actions 页面手动触发工作流

## 生成的镜像标签

根据不同的触发条件，会生成以下标签格式：

- **主分支推送**：`ghcr.io/用户名/仓库名:main`、`ghcr.io/用户名/仓库名:latest`
- **版本标签**：`ghcr.io/用户名/仓库名:v1.0.0`、`ghcr.io/用户名/仓库名:1.0`、`ghcr.io/用户名/仓库名:1`
- **Pull Request**：`ghcr.io/用户名/仓库名:pr-123`

## 使用构建的镜像

### 1. 拉取镜像
```bash
# 拉取最新版本
docker pull ghcr.io/用户名/wechat-bot-new:latest

# 拉取指定版本
docker pull ghcr.io/用户名/wechat-bot-new:v1.0.0
```

### 2. 更新 docker-compose.yml
```yaml
version: "2.4"
services:
  wechat-bot:
    image: ghcr.io/用户名/wechat-bot-new:latest  # 替换为您的镜像
    # ... 其他配置保持不变
```

### 3. 运行服务
```bash
docker-compose up -d
```

## 权限配置

GitHub Actions 需要以下权限（已在工作流中配置）：
- `contents: read` - 读取仓库内容
- `packages: write` - 推送到 GitHub 容器注册表

## 本地构建对比

### 原有的本地构建方式
```bash
cd build
chmod +x build-docker-image.sh
./build-docker-image.sh
```

### 新的 CI/CD 方式
只需推送代码到 GitHub：
```bash
git add .
git commit -m "feat: update wechat bot"
git push origin main  # 自动触发构建

# 或创建版本标签
git tag v1.0.0
git push origin v1.0.0  # 构建发布版本
```

## 监控构建状态

1. 访问 GitHub 仓库的 "Actions" 页面
2. 查看 "Build and Push Docker Image" 工作流
3. 点击具体的构建任务查看详细日志

## 故障排除

### 常见问题

1. **权限错误**：确保仓库启用了 GitHub Actions 和包权限
2. **文件缺失**：检查 `build/funtool/` 目录下是否包含必要的二进制文件
3. **构建失败**：查看 Actions 日志，检查 Dockerfile 和依赖项

### 调试建议

1. 查看 Actions 运行日志中的 "Prepare build context" 步骤
2. 检查文件复制是否成功
3. 验证 Docker 构建上下文结构

## 安全注意事项

- 镜像推送使用 `GITHUB_TOKEN`，无需额外配置密钥
- 镜像存储在 GitHub 容器注册表中，支持私有仓库
- 建议定期更新基础镜像以获取安全补丁