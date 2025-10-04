# 🚀 Complete Terraform Setup Guide

## Step-by-Step Instructions for Infrastructure Deployment

---

## 📁 Module File Structure

After running the setup script, your Terraform directory should look like this:

```
infrastructure/terraform/
│
├── main.tf                          # Main configuration (from ARTIFACT 1)
├── variables.tf                     # Variable definitions (from ARTIFACT 1)
├── outputs.tf                       # Output definitions (from ARTIFACT 1)
├── providers.tf                     # Provider configuration (from ARTIFACT 1)
├── terraform.tfvars.example         # Example variables file
├── terraform.tfvars                 # YOUR actual variables (create this)
│
└── modules/
    ├── networking/
    │   ├── main.tf                  # VNet, Subnets, NSGs
    │   ├── variables.tf             # Module inputs
    │   └── outputs.tf               # Module outputs
    │
    ├── aks/
    │   ├── main.tf                  # AKS cluster configuration
    │   ├── variables.tf             # Module inputs
    │   └── outputs.tf               # Module outputs
    │
    ├── acr/
    │   ├── main.tf                  # Container Registry
    │   ├── variables.tf             # Module inputs
    │   └── outputs.tf               # Module outputs
    │
    ├── keyvault/
    │   ├── main.tf                  # Key Vault configuration
    │   ├── variables.tf             # Module inputs
    │   └── outputs.tf               # Module outputs
    │
    ├── log_analytics/
    │   ├── main.tf                  # Log Analytics Workspace
    │   ├── variables.tf             # Module inputs
    │   └── outputs.tf               # Module outputs
    │
    ├── application_insights/
    │   ├── main.tf                  # Application Insights
    │   ├── variables.tf             # Module inputs
    │   └── outputs.tf               # Module outputs
    │
    └── postgresql/
        ├── main.tf                  # PostgreSQL Flexible Server
        ├── variables.tf             # Module inputs
        └── outputs.tf               # Module outputs
```

---

## 🎯 Complete Setup Process

### Prerequisites Checklist

Before you begin, ensure you have:

- [ ] Azure CLI installed (`az --version`)
- [ ] Terraform installed (`terraform --version`)
- [ ] Azure subscription with Owner role
- [ ] Git repository cloned locally
- [ ] Terminal/Command Prompt open

---

## 📝 Step 1: Download and Prepare Files

### Option A: Using the Automated Setup Script

1. **Copy the setup script** from the artifact titled **"setup-terraform-modules.sh"**

2. **Save it in your project root:**
```bash
cd azure-devsecops-pipeline
nano setup-terraform-modules.sh
# Paste the script content
# Save (Ctrl+X, Y, Enter)
```

3. **Make it executable and run:**
```bash
chmod +x setup-terraform-modules.sh
bash setup-terraform-modules.sh
```

This will create ALL module files automatically! ✅

### Option B: Manual Creation

If you prefer to create files manually:

1. **Create the main Terraform files** (copy content from ARTIFACT 1: "Complete Terraform Infrastructure Modules"):
   - `infrastructure/terraform/main.tf`
   - `infrastructure/terraform/variables.tf`
   - `infrastructure/terraform/outputs.tf`
   - `infrastructure/terraform/providers.tf`

2. **Create module directories:**
```bash
cd infrastructure/terraform
mkdir -p modules/{networking,aks,acr,keyvault,log_analytics,application_insights,postgresql}
```

3. **Create each module's files** (copy content from ARTIFACT 2: "Terraform Modules - Complete Infrastructure"):
   - For each module, create `main.tf`, `variables.tf`, and `outputs.tf`
   - Copy the content from the artifact for each file

---

## 📋 Step 2: Configure Your Variables

### Create terraform.tfvars File

```bash
cd infrastructure/terraform

# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

### Update These Values:

```hcl
# Resource naming
resource_group_name = "rg-ecommerce-prod"          # Your resource group name
location            = "northeurope"                      # Your Azure region
project_name        = "ecommerce"                   # Your project name
environment         = "prod"                        # Environment name

# PostgreSQL Admin Password
postgres_admin_password = "YourStr0ngP@ssw0rd!"     # CHANGE THIS!

# Optional: Adjust VM sizes based on your budget
system_node_vm_size = "Standard_D2s_v3"             # Smaller for dev/test
user_node_vm_size   = "Standard_D4s_v3"             # Smaller for dev/test

# Optional: Reduce node counts for dev/test
system_node_count = 2                                # Minimum 2 for production
user_node_count   = 2                                # Minimum 2 for production
```

---

## 🔐 Step 3: Azure Setup

### 3.1 Login to Azure

```bash
# Login to your Azure account
az login

# List your subscriptions
az account list --output table

# Set the subscription you want to use
az account set --subscription "YOUR-SUBSCRIPTION-ID"

# Verify current subscription
az account show --output table
```

### 3.2 Create Terraform State Storage

This stores your Terraform state file securely in Azure:

```bash
# Set variables
RESOURCE_GROUP_NAME="rg-terraform-state"
STORAGE_ACCOUNT_NAME="sttfstate$(openssl rand -hex 4)"  # Generates unique name
CONTAINER_NAME="tfstate"
LOCATION="northeurope"

# Create resource group
az group create \
  --name $RESOURCE_GROUP_NAME \
  --location $LOCATION

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

# Create blob container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME

# Display the storage account name (you'll need this!)
echo "Your Terraform state storage account: $STORAGE_ACCOUNT_NAME"
```

### 3.3 Update Backend Configuration

Edit `infrastructure/terraform/main.tf` and update the backend configuration:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstate12345678"    # CHANGE THIS to your storage account name
    container_name       = "tfstate"
    key                  = "ecommerce.tfstate"
  }
}
```

---

## 🚀 Step 4: Initialize Terraform

```bash
cd infrastructure/terraform

# Initialize Terraform (downloads providers and sets up backend)
terraform init

# You should see:
# ✅ Terraform has been successfully initialized!
```

**What this does:**
- Downloads Azure provider plugins
- Connects to Azure storage backend
- Prepares working directory

---

## 📊 Step 5: Validate Configuration

```bash
# Check for syntax errors
terraform validate

# Should output: Success! The configuration is valid.

# Format files (optional but recommended)
terraform fmt -recursive
```

---

## 🔍 Step 6: Plan Infrastructure

```bash
# Create execution plan
terraform plan -out=tfplan

# This will show you EVERYTHING that will be created:
# - Resource groups
# - Virtual networks and subnets
# - AKS cluster with node pools
# - Container Registry
# - Key Vault
# - Log Analytics Workspace
# - Application Insights
# - PostgreSQL Flexible Server
```

**Review the output carefully!** You should see approximately 25-30 resources to be created.

### Expected Resources:

| Resource Type | Count |
|---------------|-------|
| Resource Group | 1 |
| Virtual Network | 1 |
| Subnets | 3 |
| Network Security Groups | 1 |
| AKS Cluster | 1 |
| AKS Node Pools | 2 |
| Container Registry | 1 |
| Key Vault | 1 |
| Log Analytics Workspace | 1 |
| Application Insights | 1 |
| PostgreSQL Server | 1 |
| PostgreSQL Database | 1 |
| Firewall Rules | 1 |
| Role Assignments | 1 |
| **Total** | **~20-25 resources** |

---

## 🎬 Step 7: Apply Infrastructure

```bash
# Apply the plan
terraform apply tfplan

# This will take 20-30 minutes!
```

**What happens during apply:**

1. **0-5 min:** Creates resource group, networking
2. **5-15 min:** Creates AKS cluster (longest operation)
3. **15-20 min:** Creates ACR, Key Vault
4. **20-25 min:** Creates PostgreSQL, monitoring
5. **25-30 min:** Configures access policies, role assignments

### ☕ Time for Coffee!

While Terraform is running, you'll see output like:

```
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 2s
module.networking.azurerm_virtual_network.main: Creating...
...
module.aks.azurerm_kubernetes_cluster.main: Still creating... [10m0s elapsed]
...
Apply complete! Resources: 25 added, 0 changed, 0 destroyed.
```

---

## ✅ Step 8: Verify Deployment

### 8.1 Check Terraform Outputs

```bash
# View all outputs
terraform output

# You should see:
# - AKS cluster name
# - ACR login server
# - Key Vault name
# - PostgreSQL FQDN
# - And more...
```

### 8.2 Verify in Azure Portal

1. Go to https://portal.azure.com
2. Navigate to your resource group (e.g., `rg-ecommerce-prod`)
3. You should see all resources created

### 8.3 Test AKS Connection

```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group rg-ecommerce-prod \
  --name aks-ecommerce-prod

# Test connection
kubectl cluster-info

# Should show:
# Kubernetes control plane is running at https://...
# CoreDNS is running at https://...

# Check nodes
kubectl get nodes

# Should show 5 nodes (3 system + 2 user)
```

### 8.4 Test ACR Access

```bash
# Get ACR login server
ACR_NAME=$(terraform output -raw acr_name)

# Login to ACR
az acr login --name $ACR_NAME

# Should show: Login Succeeded
```

### 8.5 Test Key Vault Access

```bash
# Get Key Vault name
KV_NAME=$(terraform output -raw keyvault_name)

# List secrets (should be empty initially)
az keyvault secret list --vault-name $KV_NAME

# Create a test secret
az keyvault secret set \
  --vault-name $KV_NAME \
  --name "test-secret" \
  --value "Hello from Key Vault"

# Retrieve it
az keyvault secret show \
  --vault-name $KV_NAME \
  --name "test-secret" \
  --query "value" \
  -o tsv
```

### 8.6 Test PostgreSQL Connection

```bash
# Get PostgreSQL details
PSQL_HOST=$(terraform output -raw postgresql_server_fqdn)
PSQL_USER=$(terraform output -raw postgresql_administrator_login)

# Test connection (you'll need psql client installed)
psql "host=$PSQL_HOST port=5432 dbname=ecommerce user=$PSQL_USER sslmode=require"

# Enter password when prompted (from terraform.tfvars)
```

---

## 📝 Step 9: Save Important Information

Create a file to store your deployment information:

```bash
cat > ../deployment-info.txt << EOF
===========================================
AZURE DEVSECOPS INFRASTRUCTURE
Deployed: $(date)
===========================================

RESOURCE GROUP:
- Name: $(terraform output -raw resource_group_name)
- Location: $(terraform output -raw resource_group_location)

AKS CLUSTER:
- Name: $(terraform output -raw aks_cluster_name)
- FQDN: $(terraform output -raw aks_cluster_fqdn)
- Get credentials: $(terraform output -raw aks_get_credentials_command)

CONTAINER REGISTRY:
- Name: $(terraform output -raw acr_name)
- Login Server: $(terraform output -raw acr_login_server)

KEY VAULT:
- Name: $(terraform output -raw keyvault_name)
- URI: $(terraform output -raw keyvault_uri)

LOG ANALYTICS:
- Name: $(terraform output -raw log_analytics_workspace_name)

POSTGRESQL:
- Server: $(terraform output -raw postgresql_server_fqdn)
- Database: $(terraform output -raw postgresql_database_name)
- Admin User: $(terraform output -raw postgresql_administrator_login)

APPLICATION INSIGHTS:
- Name: $(terraform output -raw application_insights_id | cut -d'/' -f9)

===========================================
NEXT STEPS:
1. Configure Kubernetes secrets
2. Deploy applications
3. Set up monitoring alerts
===========================================
EOF

cat ../deployment-info.txt
```

---

## 🎯 Step 10: Configure Kubernetes

### 10.1 Create Namespaces

```bash
# Create production namespace
kubectl create namespace production

# Create staging namespace
kubectl create namespace staging

# Verify
kubectl get namespaces
```

### 10.2 Create Secrets

```bash
# Get PostgreSQL info
PSQL_HOST=$(terraform output -raw postgresql_server_fqdn)
PSQL_USER=$(terraform output -raw postgresql_administrator_login)
PSQL_PASS="YourStr0ngP@ssw0rd!"  # Same as in terraform.tfvars

# Create secrets for production
kubectl create secret generic app-secrets \
  --from-literal=DB_HOST=$PSQL_HOST \
  --from-literal=DB_USERNAME=$PSQL_USER \
  --from-literal=DB_PASSWORD=$PSQL_PASS \
  --from-literal=DB_NAME=ecommerce \
  --from-literal=JWT_SECRET=$(openssl rand -hex 32) \
  -n production

# Create secrets for staging
kubectl create secret generic app-secrets \
  --from-literal=DB_HOST=$PSQL_HOST \
  --from-literal=DB_USERNAME=$PSQL_USER \
  --from-literal=DB_PASSWORD=$PSQL_PASS \
  --from-literal=DB_NAME=ecommerce \
  --from-literal=JWT_SECRET=$(openssl rand -hex 32) \
  -n staging

# Verify secrets created
kubectl get secrets -n production
kubectl get secrets -n staging
```

### 10.3 Apply RBAC

```bash
# Create cluster admin role binding (if needed)
kubectl create clusterrolebinding kubernetes-dashboard \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:kubernetes-dashboard
```

---

## 🎊 Success! What You've Deployed

### ✅ Infrastructure

| Component | Status | Purpose |
|-----------|--------|---------|
| Virtual Network | ✅ | Network isolation |
| 3 Subnets | ✅ | AKS, Database, Services |
| AKS Cluster | ✅ | Container orchestration |
| 2 Node Pools | ✅ | System + User workloads |
| Container Registry | ✅ | Private Docker registry |
| Key Vault | ✅ | Secrets management |
| Log Analytics | ✅ | Centralized logging |
| Application Insights | ✅ | APM and monitoring |
| PostgreSQL | ✅ | Managed database |

### 💰 Estimated Monthly Cost

| Service | Cost (USD/month) |
|---------|------------------|
| AKS (5 nodes) | ~$400-500 |
| PostgreSQL | ~$250-300 |
| Container Registry | ~$20 |
| Log Analytics | ~$50 |
| Application Insights | ~$50 |
| Key Vault | ~$5 |
| Storage & Networking | ~$25 |
| **Total** | **~$800-1,150/month** |

**Cost Optimization Tips:**
- Use smaller VM sizes for dev/test
- Enable auto-scaling to scale down during off-hours
- Use Azure Reserved Instances (save 30-50%)
- Clean up unused resources regularly

---

## 🔄 Next Steps

### 1. Deploy Applications

```bash
# Navigate back to project root
cd ../../

# Deploy to staging
bash scripts/deployment/deploy-staging.sh
```

### 2. Configure Azure DevOps

- Create service connections
- Set up variable groups
- Import pipeline
- Run first deployment

### 3. Set Up Monitoring

- Configure alert rules
- Create dashboards
- Set up notifications
- Test alerting

### 4. Security Hardening

- Review Key Vault access policies
- Enable Azure Policy
- Configure network security rules
- Enable Azure Defender

---

## 🔧 Troubleshooting

### Issue: Terraform Init Fails

**Error:** "Backend configuration changed"

**Solution:**
```bash
rm -rf .terraform
terraform init -reconfigure
```

### Issue: Insufficient Quota

**Error:** "Quota exceeded for resource type"

**Solution:**
```bash
# Check your quota
az vm list-usage --location northeurope --output table

# Request quota increase in Azure Portal:
# Support + troubleshooting → New support request → Service and subscription limits (quotas)
```

### Issue: AKS Creation Fails

**Error:** "ServicePrincipalProfile must be specified"

**Solution:**
The configuration uses managed identity. If this fails:
```bash
# Check Azure AD permissions
az ad signed-in-user show

# Ensure you have permission to create service principals
```

### Issue: PostgreSQL Connection Fails

**Error:** "Connection timeout"

**Solution:**
```bash
# Check firewall rules
az postgres flexible-server firewall-rule list \
  --resource-group rg-ecommerce-prod \
  --name psql-ecommerce-prod

# Add your IP if needed
az postgres flexible-server firewall-rule create \
  --resource-group rg-ecommerce-prod \
  --name psql-ecommerce-prod \
  --rule-name allow-my-ip \
  --start-ip-address YOUR_IP \
  --end-ip-address YOUR_IP
```

### Issue: Module Not Found

**Error:** "Module not found: networking"

**Solution:**
```bash
# Ensure you've created all module files
ls -la modules/*/

# Re-run the setup script
bash ../../setup-terraform-modules.sh
```

---

## 🗑️ Cleanup (Optional)

If you need to destroy all resources:

```bash
# Review what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy

# Type 'yes' when prompted
```

⚠️ **Warning:** This will delete everything! Make sure you have backups of any important data.

---

## 📚 Additional Resources

### Terraform Documentation
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Modules](https://www.terraform.io/docs/language/modules/index.html)
- [Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

### Azure Documentation
- [AKS Best Practices](https://docs.microsoft.com/azure/aks/best-practices)
- [Azure Security](https://docs.microsoft.com/azure/security/)
- [Cost Management](https://docs.microsoft.com/azure/cost-management-billing/)

---

## ✅ Verification Checklist

Mark off each item as you complete it:

- [ ] Terraform modules created
- [ ] terraform.tfvars configured
- [ ] Azure CLI logged in
- [ ] Terraform state storage created
- [ ] Terraform initialized
- [ ] Configuration validated
- [ ] Plan reviewed
- [ ] Infrastructure applied successfully
- [ ] All resources visible in Azure Portal
- [ ] AKS connection tested
- [ ] ACR login successful
- [ ] Key Vault accessible
- [ ] PostgreSQL connection tested
- [ ] Kubernetes namespaces created
- [ ] Secrets created in Kubernetes
- [ ] Deployment info saved
- [ ] Ready for application deployment

---

**🎉 Congratulations! Your Azure infrastructure is now fully deployed and ready!**

You now have a production-ready, enterprise-grade infrastructure that includes:
✅ Kubernetes cluster with auto-scaling
✅ Private container registry
✅ Secure secrets management
✅ Managed PostgreSQL database
✅ Comprehensive monitoring
✅ All configured with security best practices

**Next:** Deploy your applications using the CI/CD pipeline!