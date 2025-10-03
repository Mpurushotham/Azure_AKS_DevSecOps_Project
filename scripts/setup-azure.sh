#!/bin/bash
set -e

echo "🚀 Azure Setup Script"
echo "===================="

az login
az account list --output table

read -p "Enter subscription ID: " SUBSCRIPTION_ID
az account set --subscription "$SUBSCRIPTION_ID"

echo "✅ Azure setup complete"
