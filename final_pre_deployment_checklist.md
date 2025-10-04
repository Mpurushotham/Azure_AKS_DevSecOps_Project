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

### output 

###. If you found the any vulerabilities due to older version of NPM module run the audit force commands.. see the example output below..

```bash
@Purushotham-MacBook-Air:~/Documents/GitHub/Azure_AKS_DevSecOps_Project/src/frontend\👨‍💻 $npm install
npm warn deprecated sourcemap-codec@1.4.8: Please use @jridgewell/sourcemap-codec instead
npm warn deprecated workbox-cacheable-response@6.6.0: workbox-background-sync@6.6.0
npm warn deprecated rollup-plugin-terser@7.0.2: This package has been deprecated and is no longer maintained. Please use @rollup/plugin-terser
npm warn deprecated workbox-google-analytics@6.6.0: It is not compatible with newer versions of GA starting with v4, as long as you are using GAv3 it should be ok, but the package is not longer being maintained
npm warn deprecated q@1.5.1: You or someone you depend on is using Q, the JavaScript Promise library that gave JavaScript developers strong feelings about promises. They can almost certainly migrate to the native JavaScript promise now. Thank you literally everyone for joining me in this bet against the odds. Be excellent to each other.
npm warn deprecated
npm warn deprecated (For a CapTP with native promises, see @endo/eventual-send and @endo/captp)
npm warn deprecated stable@0.1.8: Modern JS already guarantees Array#sort() is a stable sort, so this library is deprecated. See the compatibility table on MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort#browser_compatibility
npm warn deprecated w3c-hr-time@1.0.2: Use your platform's native performance.now() and performance.timeOrigin.
npm warn deprecated domexception@2.0.1: Use your platform's native DOMException instead
npm warn deprecated abab@2.0.6: Use your platform's native atob() and btoa() methods instead
npm warn deprecated inflight@1.0.6: This module is not supported, and leaks memory. Do not use it. Check out lru-cache if you want a good and tested way to coalesce async requests by a key value, which is much more comprehensive and powerful.
npm warn deprecated glob@7.2.3: Glob versions prior to v9 are no longer supported
npm warn deprecated rimraf@3.0.2: Rimraf versions prior to v4 are no longer supported
npm warn deprecated @humanwhocodes/object-schema@2.0.3: Use @eslint/object-schema instead
npm warn deprecated @humanwhocodes/config-array@0.13.0: Use @eslint/config-array instead
npm warn deprecated @babel/plugin-proposal-private-methods@7.18.6: This proposal has been merged to the ECMAScript standard and thus this plugin is no longer maintained. Please use @babel/plugin-transform-private-methods instead.
npm warn deprecated @babel/plugin-proposal-optional-chaining@7.21.0: This proposal has been merged to the ECMAScript standard and thus this plugin is no longer maintained. Please use @babel/plugin-transform-optional-chaining instead.
npm warn deprecated @babel/plugin-proposal-nullish-coalescing-operator@7.18.6: This proposal has been merged to the ECMAScript standard and thus this plugin is no longer maintained. Please use @babel/plugin-transform-nullish-coalescing-operator instead.
npm warn deprecated @babel/plugin-proposal-numeric-separator@7.18.6: This proposal has been merged to the ECMAScript standard and thus this plugin is no longer maintained. Please use @babel/plugin-transform-numeric-separator instead.
npm warn deprecated @babel/plugin-proposal-class-properties@7.18.6: This proposal has been merged to the ECMAScript standard and thus this plugin is no longer maintained. Please use @babel/plugin-transform-class-properties instead.
npm warn deprecated svgo@1.3.2: This SVGO version is no longer supported. Upgrade to v2.x.x.
npm warn deprecated eslint@8.57.1: This version is no longer supported. Please see https://eslint.org/version-support for other options.
npm warn deprecated source-map@0.8.0-beta.0: The work that was done in this beta branch won't be included in future versions
npm warn deprecated @babel/plugin-proposal-private-property-in-object@7.21.11: This proposal has been merged to the ECMAScript standard and thus this plugin is no longer maintained. Please use @babel/plugin-transform-private-property-in-object instead.

added 1344 packages, and audited 1345 packages in 50s

274 packages are looking for funding
  run `npm fund` for details

9 vulnerabilities (3 moderate, 6 high)

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
@Purushotham-MacBook-Air:~/Documents/GitHub/Azure_AKS_DevSecOps_Project/src/frontend\👨‍💻 $ npm audit fix --force
npm warn using --force Recommended protections disabled.
npm warn audit Updating react-scripts to 0.0.0, which is a SemVer major change.

removed 1242 packages, changed 1 package, and audited 103 packages in 3s

48 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
````

# Backend
cd src/backend
npm install
cd ../..
```

### output
    @Purushotham-MacBook-Air:~/Documents/GitHub/Azure_AKS_DevSecOps_Project/src/backend\👨‍💻 $npm install
    npm warn deprecated inflight@1.0.6: This module is not supported, and leaks memory. Do not use it. Check out lru-cache if you want a good and tested way to coalesce async requests by a key value, which is much more comprehensive and powerful.
    npm warn deprecated glob@7.2.3: Glob versions prior to v9 are no longer supported
    added 388 packages, and audited 389 packages in 6s
    49 packages are looking for funding
      run `npm fund` for details
    found 0 vulnerabilities



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

az group create --name rg-terraform-state --location northeurope

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


