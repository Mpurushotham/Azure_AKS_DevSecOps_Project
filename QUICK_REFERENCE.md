# Quick Reference

## Common Commands

### Local Development
```bash
# Start
bash scripts/local-dev/start-dev.sh

# Stop
docker-compose -f docker-compose.dev.yml down

# View logs
docker-compose -f docker-compose.dev.yml logs -f
```

### Deployment
```bash
# Staging
bash scripts/deployment/deploy-staging.sh

# Production
bash scripts/deployment/deploy-production.sh

# Rollback
bash scripts/deployment/rollback.sh green
```

### Kubernetes
```bash
# Get pods
kubectl get pods -n production

# View logs
kubectl logs -f <pod-name> -n production

# Execute command in pod
kubectl exec -it <pod-name> -n production -- /bin/sh
```

### Terraform
```bash
# Init
terraform init

# Plan
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy
```

## Useful Links

- Azure Portal: https://portal.azure.com
- Azure DevOps: https://dev.azure.com
- Kubernetes Dashboard: `kubectl proxy`

## Support

- Email: devops@company.com
- GitHub Issues: https://github.com/YOUR-ORG/azure-devsecops-pipeline/issues
