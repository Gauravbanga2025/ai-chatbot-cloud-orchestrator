# Stage 1: Compile Frontend and Backend
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma/
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: Production Container
FROM node:20-alpine AS runner
WORKDIR /app

RUN apk add --no-cache nginx

# Deploy frontend assets
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/http.d/default.conf

# Deploy backend server
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules/
COPY --from=builder /app/dist-server ./dist-server/
COPY --from=builder /app/server.mjs ./server.mjs
COPY --from=builder /app/prisma ./prisma/

# Run Node backend in background and Nginx in foreground
RUN printf '#!/bin/sh\nnode server.mjs &\nnginx -g "daemon off;"\n' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

EXPOSE 80 5000

CMD ["/entrypoint.sh"]
