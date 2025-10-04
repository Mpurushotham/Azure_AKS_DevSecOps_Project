# ✅ Final Pre-Deployment Checklist

## Complete Project Verification Before Testing

---

## 🎯 Quick Start

### Run These Two Scripts

```bash
# 1. Create Terraform modules
bash setup-terraform-modules.sh

# 2. Create ALL other files
bash create-all-missing-files.sh
```

**That's it!** Everything will be created automatically.

---

## 📋 Complete File Verification

### ✅ Root Level Files

- [ ] README.md
- [ ] CONTRIBUTING.md
- [ ] LICENSE
- [ ] CHANGELOG.md
- [ ] .gitignore
- [ ] docker-compose.dev.yml
- [ ] Makefile
- [ ] sonar-project.properties
- [ ] trivy.yaml
- [ ] .editorconfig
- [ ] .prettierrc
- [ ] .eslintrc.json

---

### 1️⃣ **src/** Directory (Application Code)

#### Frontend (src/frontend/)
- [ ] package.json
- [ ] Dockerfile
- [ ] nginx.conf
- [ ] .env.example
- [ ] src/App.js
- [ ] src/components/Header.js
- [ ] src/components/Footer.js
- [ ] src/pages/Home.js
- [ ] src/pages/Products.js
- [ ] src/tests/App.test.js

#### Backend (src/backend/)
- [ ] package.json
- [ ] Dockerfile
- [ ] .env.example
- [ ] src/server.js
- [ ] src/routes/products.js
- [ ] src/routes/orders.js
- [ ] tests/server.test.js

**Status:** 🟢 Complete after running script

---

### 2️⃣ **scripts/** Directory

#### Root Scripts
- [ ] setup-azure.sh

#### deployment/
- [ ] deploy-staging.sh
- [ ] deploy-production.sh
- [ ] rollback.sh

#### maintenance/
- [ ] backup.sh
- [ ] restore.sh
- [ ] cleanup.sh

#### local-dev/
- [ ] start-dev.sh
- [ ] stop-dev.sh

**All scripts executable:** `chmod +x scripts/**/*.sh`

**Status:** 🟢 Complete after running script

---

### 3️⃣ **k8s/** Directory (Kubernetes Manifests)

#### base/
- [ ] namespace.yaml
- [ ] networkpolicy.yaml

#### frontend/
- [ ] deployment-blue.yaml
- [ ] deployment-green.yaml
- [ ] service.yaml
- [ ] hpa.yaml
- [ ] pdb.yaml

#### backend/
- [ ] deployment-blue.yaml
- [ ] deployment-green.yaml
- [ ] service.yaml
- [ ] hpa.yaml
- [ ] pdb.yaml

#### database/
- [ ] statefulset.yaml
- [ ] service.yaml

#### ingress/
- [ ] ingress-staging.yaml
- [ ] ingress-production.yaml

**Status:** 🟢 Complete after running script

---

### 4️⃣ **opa-policies/** Directory

- [ ] deny-privileged.rego
- [ ] require-resources.rego
- [ ] require-probes.rego
- [ ] approved-registries.rego
- [ ] require-labels.rego
- [ ] ingress-tls.rego
- [ ] readonly-filesystem.rego
- [ ] drop-capabilities.rego

**Total:** 8 policies

**Status:** 🟢 Complete after running script

---

### 5️⃣ **monitoring/** Directory

#### dashboards/
- [ ] application-metrics.json
- [ ] infrastructure.json (optional)
- [ ] security.json (optional)

#### alerts/
- [ ] application-alerts.yaml
- [ ] infrastructure-alerts.yaml (optional)

#### slo/
- [ ] slo-definitions.yaml (optional)

**Status:** 🟢 Complete after running script

---

### 6️⃣ **.azure-pipelines/** Directory

- [ ] azure-pipelines.yml

**Status:** ✅ Already complete

---

### 7️⃣ **database/** Directory

#### migrations/
- [ ] V1.0__initial_schema.sql
- [ ] V1.1__add_products.sql
- [ ] V1.2__add_order_items.sql

**Status:** 🟢 Complete after running script

---

### 8️⃣ **docs/images/** Directory

- [ ] README.md (placeholder)
- [ ] architecture-diagram.png (optional - create later)
- [ ] pipeline-flow.png (optional - create later)
- [ ] security-layers.png (optional - create later)

**Status:** 🟡 Placeholders created, actual images optional

---

### 9️⃣ **helm/ecommerce-app/** Directory

#### Root
- [ ] Chart.yaml
- [ ] values.yaml
- [ ] values-staging.yaml (optional)
- [ ] values-production.yaml (optional)

#### templates/
- [ ] deployment.yaml
- [ ] service.yaml (optional)
- [ ] ingress.yaml (optional)
- [ ] _helpers.tpl

**Status:** 🟢 Complete after running script

---

### 🔟 **tests/** Directory

#### integration/
- [ ] api-tests.postman_collection.json
- [ ] staging.postman_environment.json (optional)

#### e2e/
- [ ] playwright.config.ts
- [ ] tests/homepage.spec.ts

#### performance/
- [ ] baseline.js

**Status:** 🟢 Complete after running script

---

### 🏗️ **infrastructure/terraform/** Directory

#### Root Files
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf
- [ ] providers.tf
- [ ] terraform.tfvars.example
- [ ] terraform.tfvars (YOU create this)

#### modules/networking/
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf

#### modules/aks/
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf

#### modules/acr/
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf

#### modules/keyvault/
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf

#### modules/log_analytics/
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf

#### modules/application_insights/
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf

#### modules/postgresql/
- [ ] main.tf
- [ ] variables.tf
- [ ] outputs.tf

**Status:** 🟢 Complete after running setup-terraform-modules.sh

---

## 🔍 Verification Commands

### Verify File Counts

```bash
# Root Terraform files (should be 4-5)
ls infrastructure/terraform/*.tf | wc -l

# Terraform modules (should be 7 directories)
ls -d infrastructure/terraform/modules/*/ | wc -l

# Each module should have 3 files
for module in infrastructure/terraform/modules/*/; do
  echo "$(basename $module): $(ls $module*.tf 2>/dev/null | wc -l) files"
done

# K8s manifests (should be 15+)
find k8s -name "*.yaml" | wc -l

# OPA policies (should be 8)
ls opa-policies/*.rego | wc -l

# Scripts (should be 8+)
find scripts -name "*.sh" | wc -l
```

### Verify Directory Structure

```bash
# Should show complete structure
tree -L 3 -I 'node_modules|.git'
```

### Verify Scripts are Executable

```bash
# Check all scripts
find scripts -name "*.sh" -exec ls -l {} \; | grep -v "x"

# If any shown, make them executable:
chmod +x scripts/**/*.sh
chmod +x setup-terraform-modules.sh
chmod +x create-all-missing-files.sh
```

---

## 🚀 Pre-Deployment Steps

### 1. Install Dependencies

```bash
# Frontend
cd src/frontend
npm install
cd ../..

# Backend
cd src/backend
npm install
cd ../..
```

### 2. Configure Environment

```bash
# Create terraform.tfvars
cd infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# REQUIRED: Update postgres_admin_password
# OPTIONAL: Adjust VM sizes and node counts
```

### 3. Azure Setup

```bash
# Login
az login

# Set subscription
az account set --subscription "YOUR-SUBSCRIPTION-ID"

# Verify
az account show
```

### 4. Create Terraform State Storage

```bash
# Create storage
STORAGE_NAME="sttfstate$(openssl rand -hex 4)"

az group create --name rg-terraform-state --location eastus

az storage account create \
  --name $STORAGE_NAME \
  --resource-group rg-terraform-state \
  --sku Standard_LRS

az storage container create \
  --name tfstate \
  --account-name $STORAGE_NAME

# Update main.tf with storage account name
echo "Update main.tf with: storage_account_name = \"$STORAGE_NAME\""
```

### 5. Initialize Terraform

```bash
cd infrastructure/terraform

# Initialize
terraform init

# Validate
terraform validate

# Should show: Success! The configuration is valid.
```

---

## ✅ Final Checklist Before Deployment

### Prerequisites
- [ ] Azure CLI installed and logged in
- [ ] Terraform installed (v1.6+)
- [ ] kubectl installed
- [ ] Docker Desktop installed and running
- [ ] Node.js 18 LTS installed
- [ ] All scripts run successfully

### Files
- [ ] All root config files present
- [ ] src/ complete with application code
- [ ] scripts/ all scripts executable
- [ ] k8s/ all manifests present (15+ files)
- [ ] opa-policies/ all 8 policies present
- [ ] monitoring/ setup complete
- [ ] database/ migrations present
- [ ] helm/ chart complete
- [ ] tests/ test files present
- [ ] infrastructure/terraform/ modules complete (26 files)

### Configuration
- [ ] terraform.tfvars created and configured
- [ ] PostgreSQL password set (STRONG!)
- [ ] Resource names reviewed
- [ ] VM sizes appropriate
- [ ] Node counts set correctly

### Backend
- [ ] Terraform state storage created
- [ ] Backend configuration updated in main.tf
- [ ] terraform init successful
- [ ] terraform validate successful

### Ready to Deploy
- [ ] terraform plan reviewed
- [ ] Cost estimate acceptable
- [ ] 30 minutes available for deployment
- [ ] Monitoring ready

---

## 🎯 Deployment Sequence

Once all checks pass:

### 1. Deploy Infrastructure (20-30 min)

```bash
cd infrastructure/terraform
terraform plan -out=tfplan
terraform apply tfplan
```

### 2. Configure Kubernetes (5 min)

```bash
# Get credentials
az aks get-credentials \
  --resource-group rg-ecommerce-prod \
  --name aks-ecommerce-prod

# Create secrets
kubectl create secret generic app-secrets \
  --from-literal=DB_PASSWORD=YourPassword \
  -n production

kubectl create secret generic app-secrets \
  --from-literal=DB_PASSWORD=YourPassword \
  -n staging
```

### 3. Deploy Applications (10 min)

```bash
cd ../../
bash scripts/deployment/deploy-staging.sh
```

### 4. Verify (5 min)

```bash
kubectl get pods -n staging
kubectl get svc -n staging
kubectl get ingress -n staging
```

---

## 📊 Expected Results

After successful deployment:

### Infrastructure
✅ 25+ Azure resources created  
✅ AKS cluster with 5 nodes running  
✅ ACR with login access  
✅ Key Vault accessible  
✅ PostgreSQL server running  
✅ Monitoring configured  

### Applications
✅ Frontend pods running (3 replicas)  
✅ Backend pods running (3 replicas)  
✅ Database pod running  
✅ All health checks passing  
✅ Ingress configured  
✅ Auto-scaling enabled  

### Security
✅ All security policies enforced  
✅ Network policies active  
✅ Secrets in Key Vault  
✅ RBAC configured  
✅ TLS enabled  

---

## 🆘 If Something is Missing

### Run the master script again

```bash
bash create-all-missing-files.sh
```

### Or create specific files manually

Refer to the individual sections above for file contents.

---

## 🎊 Success Criteria

You're ready to deploy when:

✅ Both scripts (setup-terraform-modules.sh and create-all-missing-files.sh) run successfully  
✅ All file counts match expected numbers  
✅ terraform validate shows success  
✅ No errors in any verification command  
✅ All scripts are executable  
✅ terraform.tfvars configured  
✅ Azure subscription set correctly  
✅ Terraform state storage created  

---

## 📞 Need Help?

- **Files missing?** Run the scripts again
- **Terraform errors?** Check COMPLETE_TERRAFORM_SETUP_GUIDE.md
- **Configuration issues?** Review terraform.tfvars
- **Deployment fails?** Check logs with `kubectl logs`

---

**🚀 Ready to deploy your enterprise-grade DevSecOps platform!**



# 3 Master Scripts:

1. setup-terraform-modules.sh (Already provided)
    * Creates all Terraform infrastructure modules
    * 26 files for Azure resources


2. create-all-missing-files.sh (NEW - ARTIFACT Above)
    * Creates ALL remaining files
    * Complete application code
    * All K8s manifests
    * All OPA policies
    * Monitoring setup
    * Helm charts
    * Test files
    * Enhanced scripts


3. FINAL_PRE_DEPLOYMENT_CHECKLIST.md (NEW - ARTIFACT Above)
    * Complete verification checklist
    * Step-by-step validation
    * Pre-deployment steps

# ⚡ FASTEST PATH TO SUCCESS:

# From project root directory:
```bash
# Step 1: Create Terraform modules (10 seconds)
bash setup-terraform-modules.sh

# Step 2: Create ALL other files (30 seconds)
bash create-all-missing-files.sh

# Step 3: Configure
cd infrastructure/terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Update postgres_admin_password

# Step 4: Deploy!
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```


