# --- 第一阶段：构建阶段 ---
FROM node:22-alpine AS build-stage

# 安装 pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# 1. 首先只拷贝依赖定义文件，利用 Docker 缓存层
COPY pnpm-lock.yaml package.json ./

# 2. 安装依赖 (使用 --frozen-lockfile 确保版本一致性)
RUN pnpm install --frozen-lockfile

# 3. 拷贝项目所有源代码
COPY . .

# 4. 执行构建
# RUN pnpm run build
RUN npx vite build

# --- 第二阶段：生产运行阶段 ---
FROM nginx:stable-alpine AS production-stage

# 从构建阶段拷贝打包后的静态文件到 Nginx 目录
# 注意：Vue 默认输出目录通常是 dist，如果是 Vite 也是 dist
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 拷贝自定义的 Nginx 配置（解决 History 模式 404 问题）
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]