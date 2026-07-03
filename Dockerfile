# =============================================================
# STAGE 1 — Builder: compila la app React/Vite
# =============================================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copia solo los manifiestos primero para aprovechar el cache de capas
COPY package*.json ./

# npm ci garantiza instalaciones deterministas (usa package-lock.json)
RUN npm ci

# Copia el resto del código fuente
COPY . .

# Genera el bundle de producción en /app/dist
RUN npm run build

# =============================================================
# STAGE 2 — Producción: servidor Nginx seguro (sin root)
# =============================================================
FROM nginx:1.27-alpine

# Elimina la configuración por defecto de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/app.conf

# Copia el bundle compilado desde el stage anterior
COPY --from=builder /app/dist /usr/share/nginx/html

# Crea usuario sin privilegios y ajusta permisos
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /usr/share/nginx/html \
    && chown -R appuser:appgroup /var/cache/nginx \
    && chown -R appuser:appgroup /var/log/nginx \
    && touch /var/run/nginx.pid \
    && chown appuser:appgroup /var/run/nginx.pid

# Cambia al usuario sin privilegios (no root)
USER appuser

# Puerto estándar HTTP de Nginx
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
