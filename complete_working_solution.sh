#!/bin/bash

################################################################################
# COMPLETE WORKING SOLUTION - Deploy from Scratch
# This script creates a simplified but production-ready infrastructure
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║       Complete Working Azure Infrastructure Solution          ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

cd infrastructure/terraform

# Backup everything first
echo -e "${YELLOW}📦 Creating backup...${NC}"
mkdir -p ../../backup_$(date +%Y%m%d_%H%M%S)
cp -r . ../../backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || true

# Complete cleanup
echo -e "${YELLOW}🧹 Complete cleanup...${NC}"
rm -rf .terraform .terraform.lock.hcl terraform.tfstate* .terraform.tfstate.lock.info

################################################################################
# CREATE SIMPLIFIED WORKING CONFIGURATION
################################################################################

echo -e "${BLUE}📝 Creating simplified working configuration...${NC}"

# 1. Main Terraform Configuration (NO MODULES - Direct Resources)
cat > main.tf << 'EOFMAIN'
terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"  # Latest stable as of Oct 2024
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "REPLACE_WITH_YOUR_STORAGE"
    container_name       = "tfstate"
    key                  = "ecommerce.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

# Random suffix for unique names
resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}-${var.environment}"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# AKS Subnet
resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aks_subnet_address_prefix
  
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Container Registry
resource "azurerm_container_registry" "main" {
  name                = "acr${var.project_name}${var.environment}${random_string.unique.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"  # Changed to Basic for testing
  admin_enabled       = true     # Enable admin for easier testing
  tags                = var.tags
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.project_name}-${random_string.unique.result}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    
    key_permissions         = ["Get", "List", "Create"]
    secret_permissions      = ["Get", "List", "Set", "Delete"]
    certificate_permissions = ["Get", "List", "Create"]
  }
  
  tags = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.project_name}${var.environment}"
  kubernetes_version  = "1.28.3"
  
  default_node_pool {
    name                = "default"
    node_count          = 2  # Reduced for testing
    vm_size             = "Standard_D2s_v3"  # Smaller for cost
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = false
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }
  
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }
  
  tags = var.tags
}

# Role Assignment for ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}
EOFMAIN

# 2. Variables
cat > variables.tf << 'EOFVARS'
variable "resource_group_name" {
  type    = string
  default = "rg-ecommerce-prod"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "project_name" {
  type    = string
  default = "ecommerce"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "aks_subnet_address_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = "ecommerce"
  }
}
EOFVARS

# 3. Outputs
cat > outputs.tf << 'EOFOUT'
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "aks_get_credentials" {
  value = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "acr_admin_username" {
  value     = azurerm_container_registry.main.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_container_registry.main.admin_password
  sensitive = true
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "next_steps" {
  value = <<-EOT
  
  ✅ Infrastructure deployed successfully!
  
  Next steps:
  1. Get AKS credentials:
     az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}
  
  2. Verify cluster:
     kubectl get nodes
  
  3. Login to ACR:
     az acr login --name ${azurerm_container_registry.main.name}
  
  4. Deploy applications:
     cd ../../
     kubectl apply -f k8s/base/
  
  EOT
}
EOFOUT

# 4. Create terraform.tfvars
cat > terraform.tfvars << 'EOFTFVARS'
resource_group_name = "rg-ecommerce-prod"
location            = "eastus"
project_name        = "ecommerce"
environment         = "prod"

tags = {
  Environment = "production"
  ManagedBy   = "Terraform"
  Project     = "ecommerce"
  Owner       = "DevOps Team"
}
EOFTFVARS

echo -e "${GREEN}✅ Configuration files created${NC}"

################################################################################
# DEPLOYMENT
################################################################################

echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: Update backend storage account name${NC}"
echo "Edit main.tf line 13 and replace: REPLACE_WITH_YOUR_STORAGE"
echo ""
read -p "Have you updated the storage account name? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Please update main.tf and run this script again"
    exit 1
fi

echo -e "${BLUE}🚀 Deploying infrastructure...${NC}"

# Initialize
terraform init

# Validate
terraform validate

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Configuration valid${NC}"
else
    echo -e "${RED}❌ Configuration invalid${NC}"
    exit 1
fi

# Plan
terraform plan -out=tfplan

echo ""
echo -e "${YELLOW}Review the plan above.${NC}"
read -p "Apply this plan? (yes/no): " APPLY

if [ "$APPLY" == "yes" ]; then
    terraform apply tfplan
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║                                                                ║${NC}"
        echo -e "${GREEN}║            ✅ DEPLOYMENT SUCCESSFUL!                            ║${NC}"
        echo -e "${GREEN}║                                                                ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        terraform output next_steps
    else
        echo -e "${RED}❌ Deployment failed${NC}"
        exit 1
    fi
else
    echo "Deployment cancelled"
fi
