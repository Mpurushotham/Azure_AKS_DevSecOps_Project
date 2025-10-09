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
