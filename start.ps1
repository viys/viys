$ServiceName = "astro"
$ContainerName = "astro-dev"

Write-Host "=== 构建 Docker 镜像（仅在依赖变动时 rebuild） ==="
docker-compose build

Write-Host "=== 启动开发容器 ==="
docker-compose up
