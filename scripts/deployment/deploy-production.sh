#!/bin/bash
set -e

echo "🚀 Deploying to Production (Blue-Green)"

kubectl apply -f k8s/frontend/deployment-blue.yaml -n production
kubectl apply -f k8s/backend/deployment-blue.yaml -n production

echo "✅ Production deployment complete"
