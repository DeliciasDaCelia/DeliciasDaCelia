# Use the official Node.js image as the base image
FROM node AS build

WORKDIR /app

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy source code
COPY . .

# Build the React app
RUN yarn build

# Production stage
FROM nginx:alpine

# Copy built artifacts
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
