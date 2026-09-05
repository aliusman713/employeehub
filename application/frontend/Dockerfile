# ============================================
# Stage 1: Build React application
# ============================================
FROM node:22-alpine AS build

WORKDIR /app

# Copy dependency files first
# This improves Docker layer caching
COPY package*.json ./

# Install exact dependencies
RUN npm ci

# Copy application source
COPY . .

# Build React/Vite application
RUN npm run build


# ============================================
# Stage 2: NGINX production image
# ============================================
FROM nginx:alpine

# Remove default NGINX website
RUN rm -rf /usr/share/nginx/html/*

# Copy React production build
COPY --from=build /app/dist /usr/share/nginx/html

# Copy our custom NGINX configuration
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# NGINX listens on port 80
EXPOSE 80

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
