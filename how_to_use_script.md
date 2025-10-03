# 🎯 How to Use the Automated Setup Script

## 📥 Step 1: Download the Script

You have the complete setup script in the artifact titled **"create-azure-devsecops-project.sh"**.

### Option A: Copy from Claude

1. Scroll up to find the artifact: **"create-azure-devsecops-project.sh - Automated Project Setup"**
2. Click the copy button (📋) in the top-right corner of the artifact
3. Save it to a file on your computer

### Option B: Manual Creation

```bash
# Create a new file
nano create-azure-devsecops-project.sh

# Paste the entire script content
# Save and exit (Ctrl+X, Y, Enter)

# Make it executable
chmod +x create-azure-devsecops-project.sh
```

---

## 🚀 Step 2: Run the Script

### Basic Usage

```bash
# Run with default project name
bash create-azure-devsecops-project.sh

# Or with custom project name
bash create-azure-devsecops-project.sh my-awesome-project
```

### What Happens

The script will:
1. ✅ Create complete directory structure (50+ directories)
2. ✅ Generate all configuration files
3. ✅ Create the CI/CD pipeline YAML
4. ✅ Generate Kubernetes manifests
5. ✅ Create OPA security policies
6. ✅ Set up Terraform infrastructure code
7. ✅ Generate frontend application (React)
8. ✅ Generate backend API (Node.js)
9. ✅ Create database migrations
10. ✅ Generate automation scripts
11. ✅ Create comprehensive documentation
12. ✅ Initialize git repository
13. ✅ Create first commit

### Expected Output

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║        Azure DevSecOps CI/CD Pipeline Generator                ║
║        Enterprise-Grade Production-Ready Setup                 ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

📦 Creating project: azure-devsecops-pipeline

🏗️  Creating directory structure...
✅ Directory structure created

📝 Creating Azure Pipeline...
✅ Azure Pipeline created

📝 Creating Kubernetes manifests...
✅ Kubernetes manifests created

... (continues for all components)

═══════════════════════════════════════════════════════════════
✅ PROJECT CREATED SUCCESSFULLY!
═══════════════════════════════════════════════════════════════
```

---

## 📁 Step 3: Verify the Created Project

```bash
# Navigate to project directory
cd azure-devsecops-pipeline  # or your custom name

# Check structure
ls -la

# You should see:
# .azure-pipelines/
# src/
# infrastructure/
# k8s/
# opa-policies/
# database/
# tests/
# scripts/
# docs/
# README.md
# SETUP_GUIDE.md
# ... and many more files
```

---

## 🌐 Step 4: Push to GitHub

### Create GitHub Repository

1. Go to https://github.com
2. Click "New Repository"
3. Name it: `azure-devsecops-pipeline` (or your project name)
4. Don't initialize with README (we already have one)
5. Create repository

### Push Your Code

```bash
# Add remote origin (replace with your URL)
git remote add origin https://github.com/YOUR-USERNAME/azure-devsecops-pipeline.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Your Repository is Now Live! 🎉

Visit: `https://github.com/YOUR-USERNAME/azure-devsecops-pipeline`

---

## 🔧 Step 5: Set Up Azure

### Prerequisites

Make sure you have:
- [ ] Azure CLI installed
- [ ] Azure subscription
- [ ] Terraform installed
- [ ] kubectl installed
- [ ] Docker Desktop

### Run Azure Setup

```bash
# Make sure you're in the project directory
cd azure-devsecops-pipeline

# Run setup script
bash scripts/setup-azure.sh

# Follow the prompts:
# - It will login to Azure
# - List subscriptions
# - Create resources for Terraform state
# - Create service principal
# - Generate configuration files
```

### Deploy Infrastructure

```bash
# Navigate to Terraform directory
cd infrastructure/terraform

# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Create Azure resources (takes 15-20 minutes)
terraform apply

# Say 'yes' when prompted
```

This creates:
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Key Vault
- Virtual Network
- Subnets and NSGs
- Log Analytics Workspace
- Application Insights

---

## 🔑 Step 6: Configure Azure DevOps

### 6.1 Import Repository

1. Go to https://dev.azure.com
2. Create new project or use existing
3. Go to Repos → Files
4. Import repository from GitHub

### 6.2 Create Service Connections

1. Project Settings → Service connections
2. **Create Azure Resource Manager connection:**
   - Name: `Azure-Service-Connection`
   - Subscription: Your Azure subscription
   - Use the service principal created by setup script
   
3. **Create Kubernetes connections:**
   - Name: `AKS-Staging-Connection`
   - Server URL: Get from `az aks show`
   - Namespace: `staging`
   
   - Name: `AKS-Production-Connection`
   - Server URL: Same as above
   - Namespace: `production`

### 6.3 Create Variable Groups

1. Pipelines → Library → + Variable group
2. Name: `ecommerce-prod-secrets`
3. Add variables:

```
AZURE_CLIENT_ID = <from azure-credentials.json>
AZURE_CLIENT_SECRET = <from azure-credentials.json> (Mark as secret ✓)
AZURE_TENANT_ID = <from azure-credentials.json>
AZURE_SUBSCRIPTION_ID = <your subscription ID>
DB_PASSWORD = <create strong password> (Mark as secret ✓)
JWT_SECRET = <random 64-char string> (Mark as secret ✓)
```

**Generate JWT Secret:**
```bash
# On Linux/Mac
openssl rand -hex 32

# Or use online generator
# https://www.grc.com/passwords.htm
```

### 6.4 Create Pipeline

1. Pipelines → New Pipeline
2. Select "Azure Repos Git" (or GitHub if you prefer)
3. Select your repository
4. Select "Existing Azure Pipelines YAML file"
5. Path: `.azure-pipelines/azure-pipelines.yml`
6. Click "Save" (don't run yet)

---

## 🐳 Step 7: Local Development (Optional but Recommended)

Test everything locally before deploying to Azure:

```bash
# Make sure Docker Desktop is running

# Start local environment
bash scripts/local-dev/start-dev.sh

# Wait for services to start (30 seconds)

# Access services:
# Frontend: http://localhost:3001
# Backend:  http://localhost:3000
# PostgreSQL: localhost:5432

# Test health endpoints
curl http://localhost:3000/health
# Should return: {"status":"ok"}

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# When done, stop services
docker-compose -f docker-compose.dev.yml down
```

---

## ☸️ Step 8: Deploy to Kubernetes

### 8.1 Connect to AKS

```bash
# Get credentials
az aks get-credentials \
  --resource-group rg-ecommerce-prod \
  --name aks-ecommerce-prod

# Verify connection
kubectl cluster-info
kubectl get nodes

# Should show 3 nodes (or your configured count)
```

### 8.2 Create Kubernetes Secrets

```bash
# Production secrets
kubectl create secret generic app-secrets \
  --from-literal=DB_USERNAME=dbadmin \
  --from-literal=DB_PASSWORD=<your-db-password> \
  --from-literal=DB_HOST=postgres.production.svc.cluster.local \
  --from-literal=DB_NAME=ecommerce \
  --from-literal=JWT_SECRET=<your-jwt-secret> \
  -n production

# Staging secrets
kubectl create secret generic app-secrets \
  --from-literal=DB_USERNAME=dbadmin \
  --from-literal=DB_PASSWORD=<your-db-password> \
  --from-literal=DB_HOST=postgres.staging.svc.cluster.local \
  --from-literal=DB_NAME=ecommerce \
  --from-literal=JWT_SECRET=<your-jwt-secret> \
  -n staging

# Verify secrets created
kubectl get secrets -n production
kubectl get secrets -n staging
```

### 8.3 Deploy to Staging

```bash
# Deploy using script
bash scripts/deployment/deploy-staging.sh

# Or manually
kubectl apply -f k8s/base/ -n staging
kubectl apply -f k8s/frontend/ -n staging
kubectl apply -f k8s/backend/ -n staging
kubectl apply -f k8s/database/ -n staging

# Wait for pods to be ready
kubectl get pods -n staging -w

# Check deployment status
kubectl get all -n staging

# Get service URLs
kubectl get ingress -n staging
```

---

## 🚀 Step 9: Run the Pipeline

### 9.1 First Pipeline Run

```bash
# Create feature branch
git checkout -b feature/first-deployment

# Make a small change (optional)
echo "# First Deployment" >> README.md
git add README.md
git commit -m "feat: first deployment test"

# Push to trigger pipeline
git push origin feature/first-deployment
```

### 9.2 Monitor Pipeline

1. Go to Azure DevOps → Pipelines
2. Watch the pipeline run
3. Each stage will execute:
   - ✅ Code Quality & Security
   - ✅ Infrastructure Security
   - ✅ Build & Container Security
   - ✅ Deploy to Staging
   - ⏸️ Manual approval (for production)

### 9.3 Deploy to Production

After staging tests pass:

1. Merge feature branch to `main`
2. Pipeline runs again
3. Approve production deployment when prompted
4. Watch blue-green deployment
5. Verify in production

---

## ✅ Step 10: Verify Everything Works

### Check Application Health

```bash
# Get ingress IP
kubectl get ingress -n production

# Test endpoints
INGRESS_IP=<your-ingress-ip>

# Frontend
curl http://$INGRESS_IP/health

# Backend
curl http://$INGRESS_IP/api/health

# Both should return success
```

### Check Monitoring

1. Go to Azure Portal
2. Navigate to Application Insights
3. View Live Metrics
4. Check for requests and responses

### Check Logs

```bash
# Frontend logs
kubectl logs -f deployment/frontend-blue -n production

# Backend logs
kubectl logs -f deployment/backend-blue -n production

# Database logs
kubectl logs -f statefulset/postgres -n production
```

---

## 📊 What You've Achieved

### ✅ Infrastructure

- [x] AKS cluster running
- [x] Container registry configured
- [x] Key Vault set up
- [x] Networking configured
- [x] Monitoring enabled

### ✅ Application

- [x] Frontend deployed
- [x] Backend API running
- [x] Database operational
- [x] All health checks passing

### ✅ CI/CD

- [x] Pipeline configured
- [x] Security scanning enabled
- [x] Automated testing
- [x] Blue-green deployment
- [x] Rollback capability

### ✅ Security

- [x] Secrets in Key Vault
- [x] Network policies active
- [x] RBAC configured
- [x] Container scanning
- [x] Policy enforcement

---

## 🎓 Next Steps

### Learn & Customize

1. **Review Documentation**
   ```bash
   cat README.md
   cat SETUP_GUIDE.md
   cat CONTRIBUTING.md
   ```

2. **Explore Code**
   - Frontend: `src/frontend/`
   - Backend: `src/backend/`
   - Infrastructure: `infrastructure/terraform/`
   - Kubernetes: `k8s/`

3. **Customize**
   - Update application code
   - Modify Kubernetes resources
   - Adjust security policies
   - Configure monitoring alerts

### Add Features

- [ ] Add more API endpoints
- [ ] Enhance frontend UI
- [ ] Add authentication
- [ ] Implement caching (Redis)
- [ ] Add more tests
- [ ] Set up multi-region
- [ ] Implement service mesh

### Share & Collaborate

1. **Update README.md** with your details
2. **Add team members** to repository
3. **Create issues** for improvements
4. **Accept pull requests**
5. **Share on LinkedIn/Twitter**
6. **Write blog post** about your implementation

---

## 🔧 Troubleshooting

### Script Fails to Run

**Problem:** Permission denied

**Solution:**
```bash
chmod +x create-azure-devsecops-project.sh
bash create-azure-devsecops-project.sh
```

### Azure CLI Not Found

**Problem:** `az: command not found`

**Solution:**
```bash
# Install Azure CLI
# macOS
brew install azure-cli

# Ubuntu/Debian
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Windows
# Download from: https://aka.ms/installazurecliwindows
```

### Terraform Not Found

**Problem:** `terraform: command not found`

**Solution:**
```bash
# macOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Windows
# Download from: https://www.terraform.io/downloads
```

### kubectl Not Found

**Problem:** `kubectl: command not found`

**Solution:**
```bash
# macOS
brew install kubectl

# Ubuntu/Debian
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Windows
# Download from: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
```

### Pipeline Fails at Security Scan

**Problem:** Gitleaks finds secrets in code

**Solution:**
```bash
# Remove secrets from code
# Use environment variables instead
# Re-run pipeline
```

**Problem:** SonarQube quality gate fails

**Solution:**
- Review SonarQube report
- Fix code quality issues
- Increase test coverage
- Re-run pipeline

### Pods Not Starting

**Problem:** Pods stuck in `Pending` state

**Solution:**
```bash
# Check pod status
kubectl describe pod <pod-name> -n production

# Common issues:
# 1. Insufficient resources - scale up nodes
# 2. Image pull errors - check ACR access
# 3. Volume mount issues - check PVC status

# Check events
kubectl get events -n production --sort-by='.lastTimestamp'
```

### Can't Access Application

**Problem:** Ingress not working

**Solution:**
```bash
# Check ingress status
kubectl get ingress -n production

# Check ingress controller
kubectl get pods -n ingress-nginx

# If ingress controller not installed:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml

# Wait for external IP
kubectl get svc -n ingress-nginx
```

---

## 💡 Pro Tips

### 1. Use Aliases

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgi='kubectl get ingress'
alias kl='kubectl logs -f'
alias kd='kubectl describe'

# Project aliases
alias cdp='cd ~/azure-devsecops-pipeline'
alias startdev='bash scripts/local-dev/start-dev.sh'
alias stopdev='docker-compose -f docker-compose.dev.yml down'
```

### 2. Keep It Updated

```bash
# Update dependencies regularly
cd src/frontend && npm update
cd src/backend && npm update

# Update Terraform providers
cd infrastructure/terraform
terraform init -upgrade

# Update Kubernetes
az aks upgrade --resource-group rg-ecommerce-prod --name aks-ecommerce-prod --kubernetes-version 1.28.3
```

### 3. Monitor Costs

```bash
# Check current costs
az consumption usage list --start-date 2024-10-01 --end-date 2024-10-31

# Set up budget alerts in Azure Portal
# Set budget to $500/month
# Alert at 80% and 100%
```

### 4. Backup Regularly

```bash
# Backup Kubernetes configs
kubectl get all --all-namespaces -o yaml > k8s-backup.yaml

# Backup database
bash scripts/maintenance/backup.sh production

# Backup Terraform state
cd infrastructure/terraform
terraform state pull > terraform-backup.tfstate
```

### 5. Use Tags

```bash
# Tag deployments
kubectl label deployment frontend-blue release=v1.0.0 -n production

# Tag commits
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## 📚 Additional Resources

### Documentation

- **Azure AKS:** https://docs.microsoft.com/azure/aks/
- **Kubernetes:** https://kubernetes.io/docs/
- **Terraform:** https://www.terraform.io/docs/
- **Azure DevOps:** https://docs.microsoft.com/azure/devops/

### Learning Resources

- **Azure Learning Paths:** https://docs.microsoft.com/learn/azure/
- **Kubernetes Tutorials:** https://kubernetes.io/docs/tutorials/
- **DevSecOps Guide:** https://www.devsecops.org/

### Community

- **Azure Reddit:** r/AZURE
- **Kubernetes Slack:** https://kubernetes.slack.com
- **DevOps Stack Exchange:** https://devops.stackexchange.com/

---

## 🎉 Success Checklist

Mark off as you complete:

- [ ] Script downloaded and made executable
- [ ] Project created successfully
- [ ] Git repository initialized
- [ ] Pushed to GitHub
- [ ] Azure CLI installed and configured
- [ ] Azure resources created with Terraform
- [ ] Azure DevOps configured
- [ ] Service connections created
- [ ] Variable groups set up
- [ ] Pipeline created
- [ ] Kubernetes secrets created
- [ ] Local development tested
- [ ] Deployed to staging
- [ ] Pipeline runs successfully
- [ ] Deployed to production
- [ ] Application accessible
- [ ] Monitoring configured
- [ ] Documentation reviewed
- [ ] Team onboarded

---

## 🚀 You're Ready!

**Congratulations!** You now have a complete, production-ready Azure DevSecOps CI/CD pipeline!

### What You Can Do Now:

✅ Deploy applications with confidence  
✅ Scale to millions of users  
✅ Maintain security compliance  
✅ Monitor everything in real-time  
✅ Roll back in 2 minutes if needed  
✅ Contribute to open source  
✅ Build your portfolio  
✅ Help others learn  

### Share Your Success!

- **Twitter:** "Just deployed a complete DevSecOps pipeline to Azure! 🚀 #DevOps #Azure #Kubernetes"
- **LinkedIn:** Share your experience and learnings
- **GitHub:** Star the repo and fork it
- **Blog:** Write about your implementation

---

## 📞 Need Help?

### Quick Questions
- Check `QUICK_REFERENCE.md`
- Read `SETUP_GUIDE.md`
- Search existing GitHub issues

### Still Stuck?
- Open a GitHub issue
- Ask in discussions
- Email: devops@company.com

### Want to Contribute?
- Read `CONTRIBUTING.md`
- Find "good first issue" labels
- Submit a pull request

---

**Happy Deploying! 🎊**

*Made with ❤️ for the DevOps Community*

---

## 📄 File Reference

All files created by the script:

```
azure-devsecops-pipeline/
├── README.md                          ← Main documentation
├── SETUP_GUIDE.md                     ← Complete setup instructions  
├── QUICK_REFERENCE.md                 ← Quick command reference
├── CONTRIBUTING.md                    ← How to contribute
├── CHANGELOG.md                       ← Version history
├── LICENSE                            ← MIT License
├── .gitignore                         ← Git ignore rules
├── docker-compose.dev.yml             ← Local dev environment
├── Makefile                           ← Common commands
├── sonar-project.properties           ← SonarQube config
├── .azure-pipelines/
│   └── azure-pipelines.yml           ← CI/CD pipeline
├── src/
│   ├── frontend/                      ← React app
│   └── backend/                       ← Node.js API
├── infrastructure/terraform/          ← IaC
├── k8s/                              ← Kubernetes manifests
├── opa-policies/                     ← Security policies
├── database/migrations/              ← SQL migrations
├── scripts/                          ← Automation scripts
└── .github/                          ← GitHub templates
```

**Total:** 100+ files created automatically! 🎉