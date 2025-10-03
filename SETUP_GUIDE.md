# 🚀 Complete Setup Guide

## Prerequisites Checklist

- [ ] Azure subscription with Owner role
- [ ] Azure CLI installed and configured
- [ ] kubectl installed
- [ ] Terraform installed (1.6+)
- [ ] Docker Desktop installed and running
- [ ] Node.js 18 LTS installed
- [ ] Git installed
- [ ] Azure DevOps organization created

## Step-by-Step Setup

### 1. Azure Setup (15 minutes)

```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "your-subscription-id"

# Run setup script
bash scripts/setup-azure.sh

# Follow the prompts to create:
# - Resource groups
# - Storage account for Terraform state
# - Service principal for pipeline
```

### 2. Infrastructure Deployment (20-30 minutes)

```bash
# Navigate to Terraform directory
cd infrastructure/terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan -out=tfplan

# Apply infrastructure
terraform apply tfplan

# Save outputs
terraform output -json > ../../azure-outputs.json
```

This creates:
- Azure Kubernetes Service (AKS) cluster
- Azure Container Registry (ACR)
- Azure Key Vault
- Virtual Network with subnets
- Log Analytics Workspace
- Application Insights

### 3. Azure DevOps Configuration (10 minutes)

#### A. Create Service Connections

1. Go to Azure DevOps → Project Settings → Service connections
2. Create "Azure Resource Manager" connection
   - Name: `Azure-Service-Connection`
   - Use the service principal from setup script
3. Create Kubernetes connections for staging and production

#### B. Create Variable Groups

1. Go to Pipelines → Library → Variable groups
2. Create group: `ecommerce-prod-secrets`
3. Add variables:
   ```
   AZURE_CLIENT_ID: <from setup script>
   AZURE_CLIENT_SECRET: <from setup script> (mark as secret)
   AZURE_TENANT_ID: <from setup script>
   AZURE_SUBSCRIPTION_ID: <your subscription id>
   DB_PASSWORD: <strong password> (mark as secret)
   JWT_SECRET: <random string> (mark as secret)
   ```

#### C. Create Pipeline

1. Go to Pipelines → New Pipeline
2. Select "Azure Repos Git" or "GitHub"
3. Select your repository
4. Choose "Existing Azure Pipelines YAML file"
5. Select: `.azure-pipelines/azure-pipelines.yml`
6. Save (don't run yet)

### 4. Configure Kubernetes (10 minutes)

```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group rg-ecommerce-prod \
  --name aks-ecommerce-prod

# Verify connection
kubectl cluster-info
kubectl get nodes

# Create namespaces
kubectl apply -f k8s/base/namespace.yaml

# Create secrets (replace with actual values)
kubectl create secret generic app-secrets \
  --from-literal=DB_USERNAME=dbadmin \
  --from-literal=DB_PASSWORD=YourStrongPassword123! \
  --from-literal=DB_HOST=postgres.production.svc.cluster.local \
  --from-literal=DB_NAME=ecommerce \
  --from-literal=JWT_SECRET=your-jwt-secret \
  -n production

kubectl create secret generic app-secrets \
  --from-literal=DB_USERNAME=dbadmin \
  --from-literal=DB_PASSWORD=YourStrongPassword123! \
  --from-literal=DB_HOST=postgres.staging.svc.cluster.local \
  --from-literal=DB_NAME=ecommerce \
  --from-literal=JWT_SECRET=your-jwt-secret \
  -n staging
```

### 5. First Deployment (5 minutes)

```bash
# Create a feature branch
git checkout -b feature/initial-setup

# Push to trigger pipeline
git push origin feature/initial-setup

# Go to Azure DevOps and watch the pipeline run
```

### 6. Verify Deployment

```bash
# Check pods are running
kubectl get pods -n staging

# Get service URLs
kubectl get ingress -n staging

# Test health endpoints
curl http://<ingress-ip>/health
curl http://<ingress-ip>/api/health
```

## Local Development Setup

```bash
# Start local environment
bash scripts/local-dev/start-dev.sh

# Access services
# Frontend: http://localhost:3001
# Backend:  http://localhost:3000
# Database: localhost:5432

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop environment
docker-compose -f docker-compose.dev.yml down
```

## Troubleshooting

### Pipeline fails at security scan
- Review security scan reports in Azure DevOps
- Fix identified issues in code
- Re-run pipeline

### Kubernetes pods not starting
```bash
# Check pod status
kubectl get pods -n staging
kubectl describe pod <pod-name> -n staging
kubectl logs <pod-name> -n staging
```

### Cannot connect to AKS
```bash
# Re-fetch credentials
az aks get-credentials \
  --resource-group rg-ecommerce-prod \
  --name aks-ecommerce-prod \
  --overwrite-existing
```

### Terraform errors
```bash
# Check state
terraform show

# Refresh state
terraform refresh

# If needed, import existing resources
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/rg-name
```

## Next Steps

1. **Customize** - Modify the application code for your needs
2. **Configure Monitoring** - Set up alerts in Azure Monitor
3. **Add Tests** - Write more comprehensive tests
4. **Documentation** - Update docs with your specifics
5. **Security** - Review and adjust security policies
6. **Scale** - Configure auto-scaling parameters

## Support

- Check documentation in `docs/` directory
- Open issues on GitHub
- Contact: devops@company.com

## Success Criteria

✅ Infrastructure deployed to Azure
✅ Pipeline runs successfully
✅ Application accessible in staging
✅ All health checks passing
✅ Monitoring dashboards visible
✅ Can deploy to production

**You're ready to go! 🎉**
