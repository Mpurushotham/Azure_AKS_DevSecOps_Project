# 🚀 Azure DevSecOps CI/CD Pipeline for AKS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

> Enterprise-grade DevSecOps CI/CD pipeline for deploying 3-tier applications to Azure Kubernetes Service

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Deployment](#deployment)
- [Monitoring](#monitoring)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This repository contains a complete, production-ready DevSecOps CI/CD pipeline that implements:

- **11-stage CI/CD pipeline** with comprehensive security scanning
- **12-layer security approach** from code to runtime
- **Blue-green deployment** strategy for zero-downtime updates
- **Infrastructure as Code** with Terraform
- **Kubernetes manifests** with OPA policy enforcement
- **Complete monitoring** and alerting setup

### Key Statistics

| Metric | Value |
|--------|-------|
| Pipeline Stages | 11 |
| Security Scans | 12 different tools |
| Deployment Time | ~2.5 hours (full production) |
| Rollback Time | 2 minutes (automated) |
| Uptime Target | 99.9% |

## 🏗️ Architecture

### 3-Tier Application

```
Frontend (React) → Backend API (Node.js) → Database (PostgreSQL)
```

### Azure Infrastructure

- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Key Vault
- Azure Database for PostgreSQL
- Application Insights
- Log Analytics Workspace

## ✨ Features

### 🔒 Security Features

- Secret scanning (Gitleaks)
- SAST (SonarQube, Snyk)
- Container scanning (Trivy)
- IaC scanning (Checkov, tfsec)
- DAST (OWASP ZAP)
- Policy enforcement (OPA)
- Image signing (Cosign)
- Network policies
- RBAC and Azure AD integration

### 🚀 DevOps Features

- Zero-downtime deployments (blue-green)
- Automated testing (unit, integration, E2E)
- Infrastructure as Code (Terraform)
- Automated rollback
- Comprehensive monitoring

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/azure-devsecops-pipeline.git
cd azure-devsecops-pipeline
```

### 2. Set Up Azure

```bash
# Run setup script
bash scripts/setup-azure.sh

# Initialize Terraform
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

### 3. Configure Azure DevOps

1. Create service connections in Azure DevOps
2. Import the pipeline from `.azure-pipelines/azure-pipelines.yml`
3. Set up variable groups with required secrets
4. Run the pipeline

### 4. Local Development

```bash
# Start local development environment
bash scripts/local-dev/start-dev.sh

# Access services:
# Frontend: http://localhost:3001
# Backend:  http://localhost:3000
# Database: localhost:5432
```

## 📁 Project Structure

```
azure-devsecops-pipeline/
├── .azure-pipelines/          # CI/CD pipeline definitions
├── src/
│   ├── frontend/             # React application
│   └── backend/              # Node.js API
├── infrastructure/
│   └── terraform/            # Infrastructure as Code
├── k8s/                      # Kubernetes manifests
│   ├── frontend/
│   ├── backend/
│   ├── database/
│   └── ingress/
├── opa-policies/             # OPA security policies
├── database/migrations/      # SQL migrations
├── scripts/                  # Automation scripts
│   ├── deployment/
│   ├── maintenance/
│   └── local-dev/
└── docs/                     # Documentation
```

## 📋 Prerequisites

### Required Tools

- Azure CLI (2.50+)
- kubectl (1.28+)
- Terraform (1.6+)
- Docker (24.0+)
- Node.js (18 LTS)
- Git (2.40+)

### Azure Resources

- Azure subscription with Owner role
- Azure DevOps organization
- Service principal with Contributor role

## 🔧 Installation

### Step 1: Azure Resources

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "your-subscription-id"

# Run setup script
bash scripts/setup-azure.sh
```

### Step 2: Infrastructure Deployment

```bash
cd infrastructure/terraform

# Initialize Terraform
terraform init

# Review plan
terraform plan -out=tfplan

# Apply infrastructure
terraform apply tfplan
```

### Step 3: Application Deployment

```bash
# Deploy to staging
bash scripts/deployment/deploy-staging.sh

# Deploy to production (after testing)
bash scripts/deployment/deploy-production.sh
```

## 💻 Usage

### Running Locally

```bash
# Start all services
bash scripts/local-dev/start-dev.sh

# Stop services
docker-compose -f docker-compose.dev.yml down
```

### Running Tests

```bash
# Frontend tests
cd src/frontend
npm test

# Backend tests
cd src/backend
npm test
```

### Deploying Changes

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"
git push origin feature/my-feature

# Create pull request
# Pipeline runs automatically
```

## 🚢 Deployment

### Staging Deployment

Triggered automatically on push to `develop` branch:

1. Code quality checks
2. Security scanning
3. Build and test
4. Deploy to staging
5. Integration tests

### Production Deployment

Triggered on push to `main` branch (requires approval):

1. All staging checks
2. Manual approval gate
3. Blue-green deployment
4. Smoke tests
5. Traffic switch
6. Monitoring

### Rollback

```bash
# Automatic rollback on failure
# Or manual rollback:
bash scripts/deployment/rollback.sh green
```

## 📊 Monitoring

### Application Insights

- Request/response metrics
- Error tracking
- Performance monitoring
- Custom events

### Azure Monitor

- Container insights
- Resource metrics
- Log analytics
- Alerts

### Access Dashboards

```bash
# Get Application Insights key
az monitor app-insights component show \
  --resource-group rg-ecommerce-prod \
  --app appi-ecommerce-prod
```

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

## 🙏 Acknowledgments

- Azure DevOps team
- Kubernetes community
- Open source security tools
- All contributors

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/your-org/azure-devsecops-pipeline/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/azure-devsecops-pipeline/discussions)
- **Email**: devops@company.com

## 🗺️ Roadmap

- [ ] Multi-region deployment
- [ ] Advanced A/B testing
- [ ] Chaos engineering
- [ ] GitOps integration
- [ ] Service mesh (Istio)

---

**Made with ❤️ by the DevOps Team**
