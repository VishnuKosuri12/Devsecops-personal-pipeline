# -----------------------------------------------------------------------------------
# Build Stage: Compile the React/Vue/Angular application
# -----------------------------------------------------------------------------------
# Use a lean Node.js image for building the application.
# `node:20-alpine` is a good choice as it's small and contains Node.js and npm.
FROM node:20-alpine AS build

# Set the working directory inside the container.
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker's layer caching.
# This ensures that `npm ci` only runs if the dependencies have changed.
COPY package*.json ./

# Install project dependencies. `npm ci` is preferred over `npm install`
# in CI/CD environments as it uses the lock file and is faster and more reliable.
RUN npm ci

# Copy the rest of the application source code.
# This is a separate step from installing dependencies to further optimize caching.
COPY . .

# Run the build command as defined in package.json.
# This command typically compiles the source code into static files.
RUN npm run build


# -----------------------------------------------------------------------------------
# Production Stage: Serve the static files with Nginx
# -----------------------------------------------------------------------------------
# Use a very lightweight Nginx image. `nginx:alpine` is ideal for a small final image.
FROM nginx:alpine AS prod

# Set the working directory to Nginx's default web root.
WORKDIR /usr/share/nginx/html

# Remove the default Nginx index.html and other files to avoid conflicts.
# The `rm -rf` command ensures a clean slate before copying the app files.
RUN rm -rf ./*

# Copy the compiled static files from the 'build' stage into the Nginx web root.
# This is the key to a multi-stage build, keeping the final image small and clean.
# The `/app
