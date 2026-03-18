# 使用 Node 22 LTS slim 镜像
FROM node:22-slim

# 安装 sharp 依赖（如果项目用到）
RUN apt-get update && apt-get install -y --no-install-recommends \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 pnpm（如果项目用它）
RUN npm install -g pnpm

# 设置工作目录
WORKDIR /app

# 复制 package 文件
COPY package.json pnpm-lock.yaml* ./

# 安装依赖
RUN pnpm install

# 复制项目
COPY . .

# 构建 Astro
RUN pnpm astro build

# 启动预览
CMD ["pnpm", "astro", "preview"]