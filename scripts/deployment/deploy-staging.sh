#!/bin/bash
set -e

echo "🚀 Deploying to Staging"

kubectl apply -f k8s/base/ -n staging
kubectl apply -f k8s/frontend/ -n staging
kubectl apply -f k8s/backend/ -n staging

echo "✅ Staging deployment complete"
