# Stage 1: Build the React + Vite Frontend
FROM node:20-alpine AS builder
WORKDIR /app

# Copy dependency manifests & prisma schema
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies including Prisma dev tools
RUN npm ci

# Copy remaining source code
COPY . .

# Compile Prisma client + TypeScript + Vite static build
RUN npm run build

# Stage 2: Hardened Alpine Nginx Server (<30MB)
FROM nginx:alpine AS runner
WORKDIR /usr/share/nginx/html

RUN rm -rf ./*
COPY --from=builder /app/dist .
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
