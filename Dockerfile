# Stage 1: Build the React app
FROM node:18.13.0 AS build

WORKDIR /app

COPY package*.json ./

RUN npm config set fetch-retry-maxtimeout 60000 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set timeout 600000 && \
    npm install


COPY . .

RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:latest

# Remove default nginx static assets (optional)
RUN rm -rf /usr/share/nginx/html/*

# Copy built React files to Nginx's web directory
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

HEALTHCHECK CMD curl --fail http://localhost || exit 1
