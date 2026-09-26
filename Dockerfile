# Dockerfile for School Attendance Backend (Deployable on AbrArvan Cloud PaaS / VPS)
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install build dependencies for sqlite3
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Copy application source
COPY . .

# Expose port
EXPOSE 5000

# Set environment
ENV NODE_ENV=production
ENV PORT=5000

# Start server
CMD ["node", "src/server.js"]
