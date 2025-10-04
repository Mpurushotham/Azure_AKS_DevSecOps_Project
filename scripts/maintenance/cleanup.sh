#!/bin/bash
set -e

echo "🧹 Cleanup Script"
echo "================="

RESOURCE_GROUP="rg-ecommerce-prod"
ACR_NAME="acrecommerceprod"
KEEP_IMAGES=10

echo "📦 Cleaning up old ACR images (keeping last $KEEP_IMAGES)..."

# Frontend images
echo "Cleaning frontend images..."
IMAGES_TO_DELETE=$(az acr repository show-tags \
  --name "$ACR_NAME" \
  --repository frontend \
  --orderby time_desc \
  --output tsv | tail -n +$((KEEP_IMAGES + 1)))

for TAG in $IMAGES_TO_DELETE; do
  echo "  Deleting frontend:$TAG"
  az acr repository delete \
    --name "$ACR_NAME" \
    --image frontend:"$TAG" \
    --yes || true
done

# Backend images
echo "Cleaning backend images..."
IMAGES_TO_DELETE=$(az acr repository show-tags \
  --name "$ACR_NAME" \
  --repository backend \
  --orderby time_desc \
  --output tsv | tail -n +$((KEEP_IMAGES + 1)))

for TAG in $IMAGES_TO_DELETE; do
  echo "  Deleting backend:$TAG"
  az acr repository delete \
    --name "$ACR_NAME" \
    --image backend:"$TAG" \
    --yes || true
done

echo "✅ Cleanup completed"
