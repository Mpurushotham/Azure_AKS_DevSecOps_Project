#Create a storage account for Terraform state

#!/bin/bash

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
sed -i '' "s/storage_account_name = \".*\"/storage_account_name = \"$STORAGE_NAME\"/" ../infrastructure/terraform/main.tf
echo "Update main.tf with: container_name = \"tfstate\""
sed -i '' "s/container_name = \".*\"/container_name = \"tfstate\"/" ../infrastructure/terraform/main.tf
echo "Update main.tf with: key = \"terraform.tfstate\""
sed -i '' "s/key = \".*\"/key = \"terraform.tfstate\"/" ../infrastructure/terraform/main.tf
echo "Done."
echo "You can now run 'terraform init' in the parent directory."

#############################################################################
# IMPORTANT:
# Note: The sed command above is for macOS. If you're using Linux, use the following command instead:
################################################################################


# sed -i "s/storage_account_name = \".*\"/storage_account_name = \"$STORAGE_NAME\"/" ../main.tf
# sed -i "s/container_name = \".*\"/container_name = \"tfstate\"/" ../main.tf
# sed -i "s/key = \".*\"/key = \"terraform.tfstate\"/" ../main.tf
# Also, ensure that the main.tf file has the appropriate placeholders for storage_account_name, container_name, and key.
# Example placeholders in main.tf:
# storage_account_name = "your_storage_account_name"
# container_name = "your_container_name"
# key = "your_key_name"
# Replace them with the actual values using the sed commands above.
# Make sure to have the Azure CLI installed and logged in before running this script.