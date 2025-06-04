#!/bin/bash
set -e

echo "🚀 Starting Local CI/CD Pipeline"

# Variables
VERSION=$(date +%Y%m%d-%H%M%S)
LOCAL_IP="192.168.1.71"

# Update version
echo "VERSION=$VERSION" > .env

# Build phase
echo "🔨 Building application..."
docker-compose build --no-cache

# Test phase
echo "🧪 Running tests..."
docker-compose up -d app
sleep 5

# Health check
if curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo "✅ Health check passed"
else
    echo "❌ Health check failed"
    docker-compose down
    exit 1
fi

# Deploy phase
echo "🚀 Deploying to local environment..."
docker-compose down
docker-compose up -d

echo "✅ Deployment complete!"
echo "🌐 Application available at: http://$LOCAL_IP"
echo "📊 Version: $VERSION"

# Show running containers
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"