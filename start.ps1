param(
    [Parameter(Position = 0)]
    [ValidateSet("start", "upgrade", "help")]
    [string]$Action = "start"
)

switch ($Action) {

    "help" {
        Write-Host "Usage: .\start.ps1 [start|upgrade|help]"
        Write-Host ""
        Write-Host "start   - 构建并启动开发容器（前台运行）"
        Write-Host "upgrade - 提示如何在 Windows 主机上安装 Node.js/npm 并升级 Astro 和依赖"
        Write-Host "help    - 显示此帮助信息"
        break
    }

    "start" {
        Write-Host "=== 构建 Docker 镜像（仅在依赖变动时 rebuild） ==="
        docker-compose build

        Write-Host "=== 启动开发容器（前台运行） ==="
        Write-Host "注意：日志会直接显示在当前终端，按 Ctrl+C 停止容器。"
        docker-compose up
        break
    }

"upgrade" {
    Write-Host "=== 在 Windows 主机上升级 Astro 和依赖 ==="
    Write-Host ""
    Write-Host "1. 确认已安装 Node.js 和 npm:"
    Write-Host "   node -v    # 查看 Node 版本"
    Write-Host "   npm -v     # 查看 npm 版本"
    Write-Host ""
    Write-Host "   如果未安装 Node.js，请访问 https://nodejs.org/ 下载 LTS 版本并安装"
    Write-Host "   安装完成后，重新打开终端以确保 PATH 生效"
    Write-Host ""
    Write-Host "2. 安装或更新 pnpm（全局）:"
    Write-Host "   npm install -g pnpm"
    Write-Host "   pnpm -v    # 检查版本"
    Write-Host ""
    Write-Host "3. 升级 Astro 核心包:"
    Write-Host "   pnpm dlx @astrojs/upgrade"
    Write-Host ""
    Write-Host "4. （可选）升级项目中所有依赖:"
    Write-Host "   pnpm update --latest"
    Write-Host ""
    Write-Host "5. 重新安装依赖，确保 lockfile 生效:"
    Write-Host "   pnpm install"
    Write-Host ""
    Write-Host "注意：在 Docker 容器里升级不会改变镜像，建议在主机上执行以上步骤。"
    break
}
}