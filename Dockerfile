# Dockerfile for School Attendance Backend (Deployable on AbrArvan Cloud PaaS / VPS)
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install build dependencies for native modules
RUN apk add --no-cache python3 make g++

# Install backend dependencies
COPY backend/package*.json ./
RUN npm ci --omit=dev

# Copy backend source/data and the web portal served by the backend
COPY backend ./backend
COPY frontend ./frontend

# Expose the API port
EXPOSE 5000

ENV NODE_ENV=production
ENV PORT=5000

CMD ["node", "backend/server.js"]
