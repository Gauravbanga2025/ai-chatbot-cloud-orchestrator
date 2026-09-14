FROM node:20-alpine
WORKDIR /app

RUN apk add --no-cache nginx

# Deploy static frontend
RUN rm -rf /usr/share/nginx/html/*
COPY dist /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/http.d/default.conf

# Deploy pre-built backend server
COPY package*.json ./
COPY prisma ./prisma/
COPY dist-server ./dist-server/
COPY server.mjs ./server.mjs

# Install only minimal runtime dependencies without dev dependencies
RUN npm ci --omit=dev && npx prisma generate

# Auto-restarting entrypoint for Node + foreground Nginx
RUN printf '#!/bin/sh\nwhile true; do node server.mjs; sleep 1; done &\nexec nginx -g "daemon off;"\n' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

EXPOSE 80 5000

CMD ["/entrypoint.sh"]
