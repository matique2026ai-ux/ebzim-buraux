# Build Stage
FROM node:24-alpine as builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies including devDependencies for build
RUN npm install

# Copy source code
COPY . .

# Build the project
RUN npm run build

# Production Stage
FROM node:24-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Copy build artifacts from builder stage
COPY --from=builder /app/dist ./dist

# Explicitly expose the port (Render will override this, but it's good practice)
EXPOSE 3000

# Set environment to production
ENV NODE_ENV=production

# Start the application
CMD ["node", "dist/main"]
