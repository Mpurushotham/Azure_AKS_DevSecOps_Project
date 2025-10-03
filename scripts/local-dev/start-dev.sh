#!/bin/bash
set -e

echo "🚀 Starting Local Development"

docker-compose -f docker-compose.dev.yml up -d

echo "✅ Development environment started"
echo "Frontend: http://localhost:3001"
echo "Backend:  http://localhost:3000"
