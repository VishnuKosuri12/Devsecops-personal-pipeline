# Base image for building the app
FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies (cached unless package.json changes)
COPY package*.json ./
RUN npm ci

# Bring in the code and run the build
COPY . .
RUN npm run build

# Final image using lightweight Nginx to serve the app
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Remove Nginx's default welcome page
RUN rm -rf ./*

# Copy the compiled output from the build stage
COPY --from=build /app/dist .

EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
