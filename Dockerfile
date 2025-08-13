# -----------------------------------------------------------------------------------
# Stage 1: Build the Application
# -----------------------------------------------------------------------------------
# Use a Node.js image with version 20 on a slim Alpine base.
# Alpine images are very small and efficient.
FROM node:20-alpine AS build

# Set the working directory for the application inside the container.
WORKDIR /app

# Copy the dependency manifest files first.
# This allows Docker to cache the 'npm ci' step, speeding up subsequent builds
# if the dependencies haven't changed.
COPY package*.json ./

# Install project dependencies. 'npm ci' is used for clean, reproducible builds.
RUN npm ci

# Copy the rest of the application source code.
COPY . .

# Run the build script defined in package.json.
# This compiles the application into static files (e.g., HTML, CSS, JS).
RUN npm run build


# -----------------------------------------------------------------------------------
# Stage 2: Serve the Production Files with Nginx
# -----------------------------------------------------------------------------------
# Start with a clean, lightweight Nginx image.
FROM nginx:alpine AS prod

# Copy the compiled application files from the 'build' stage.
# The `--from=build` instruction is the key to multi-stage builds. It tells
# Docker to copy files from a previously defined stage (named 'build' here).
# The compiled files are located at `/app/dist` or `/app/build` (depending on the framework).
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: Copy a custom Nginx configuration file if needed.
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to the host machine.
EXPOSE 80

# The default command for the nginx:alpine image starts the Nginx server,
# so no CMD instruction is needed.
