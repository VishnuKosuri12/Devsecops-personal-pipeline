# ────────────────────────────────
# Build stage: compile the app
# ────────────────────────────────
FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies (cached unless package.json changes)
COPY package*.json ./
RUN npm ci

# Copy source code and build the app
COPY . .
RUN npm run build


# ────────────────────────────────
# Production stage: serve with Nginx
# ────────────────────────────────
FROM nginx:alpine AS prod

WORKDIR /usr/share/nginx/html

# Clean default Nginx content
RUN rm -rf ./*

# Copy compiled build artifacts from the build stage
COPY --from=build /app/dist .

# Expose HTTP port
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

