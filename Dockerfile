# ---------------------------------
# Stage 1: Build Environment
# ---------------------------------
# Use an official Node.js 20 image on a minimal Alpine Linux base.
# This stage, aliased as 'build', compiles the application assets.
FROM node:20-alpine AS build

# Set the working directory inside the container.
WORKDIR /app

# Copy dependency manifests. Separating this from the source code copy
# leverages Docker's layer caching, speeding up future builds if
# dependencies haven't changed.
COPY package*.json ./

# Install dependencies using 'npm ci' for a fast, reliable, and
# reproducible build from the lockfile.
RUN npm ci

# Copy the rest of the application source code.
COPY . .

# Execute the build script to compile the application into static files.
RUN npm run build


# ---------------------------------
# Stage 2: Production Environment
# ---------------------------------
# Use a lightweight Nginx image to serve the static content.
FROM nginx:alpine

# Copy the compiled static assets from the 'build' stage to the Nginx
# default public directory. Note: The source directory '/app/dist' may
# vary depending on your framework (e.g., '/app/build' for Create React App).
COPY --from=build /app/dist /usr/share/nginx/html

# (Optional) To use a custom Nginx configuration, uncomment the following line.
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to allow incoming HTTP traffic.
EXPOSE 80

# The Nginx base image automatically starts the server, so no explicit CMD is needed.
