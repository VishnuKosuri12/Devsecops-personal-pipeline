# Containerfile (Podman/Buildah equivalent of a Dockerfile)

# ---------------------------------
# Stage 1: Build Environment
# ---------------------------------
# Use an official Node.js 20 image on a minimal Alpine Linux base for building.
# This stage is aliased as 'builder'.
FROM node:20-alpine AS builder

# Set the working directory inside the container.
WORKDIR /app

# Copy dependency manifests.
COPY package.json package-lock.json ./

# Define a persistent location for the npm cache within the container,
# which can improve cache hits if this stage is reused, and we will clean it up later.
ENV NPM_CONFIG_CACHE=/tmp/.npm-cache

# Install dependencies using 'npm ci' for a fast, reliable, and reproducible build.
RUN npm ci

# Copy the rest of the application source code.
COPY . .

# Execute the build script to compile static assets.
RUN npm run build \
    # Clean up the build stage to minimize the resulting image size.
    # This removes the npm cache, which is not needed for the runtime image.
    && rm -rf /tmp/.npm-cache /root/.npm

# ---------------------------------
# Stage 2: Production Environment (Runtime)
# ---------------------------------
# Use a highly lightweight Nginx image to serve the static content.
FROM nginx:alpine

# Metadata: Define the port Nginx will use.
EXPOSE 80

# Set a label to identify the application within the registry/Podman/Docker system.
LABEL name="static-web-app" \
      maintainer="your-name-or-team"

# Copy the compiled static assets from the 'builder' stage to the Nginx public directory.
# Be explicit about the build output directory (using 'dist' as a common example).
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy a custom Nginx configuration if one is present (uncomment and ensure file exists).
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# The base Nginx image uses a robust CMD to start the server in the foreground,
# so no explicit instruction is typically needed here.

# Healthcheck definition (optional but recommended for production):
# HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD wget -q -O /dev/null http://localhost/ || exit 1
