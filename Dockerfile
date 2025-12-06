# 使用官方 Node LTS
FROM node:20-bullseye

# 设置工作目录
WORKDIR /app

# 先复制依赖文件（独立分层，利用缓存）
COPY package.json pnpm-lock.yaml* ./

# 安装 pnpm 和依赖
RUN npm install -g pnpm \
    && pnpm install --frozen-lockfile

# 复制剩余项目源代码
COPY . .

# 设置开发模式环境变量
ENV NODE_ENV=development

# 默认命令启动 Astro dev server
CMD ["npx", "astro", "dev", "--host", "0.0.0.0", "--port", "4321"]
