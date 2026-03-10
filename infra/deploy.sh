#!/bin/bash

# Azure Deployment Script for Nx Store Demo
# Run this after creating Azure resources

set -e

echo "=== Azure Deployment Script ==="

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Azure CLI not found. Install from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Login check
echo "Checking Azure login..."
az account show --output json > /dev/null 2>&1 || {
    echo "Please run: az login"
    exit 1
}

# Get subscription
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo "Using subscription: $SUBSCRIPTION_ID"

# Create resource group
RESOURCE_GROUP="nx-store-demo-rg"
LOCATION="eastus"

echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION --output none

# Deploy Bicep infrastructure
echo "Deploying infrastructure..."
az deployment group create \
    --resource-group $RESOURCE_GROUP \
    --template-file main.bicep \
    --parameters prefix=nxstore env=prod \
    --output json > deployment-output.json

# Get deployment outputs
HOST_URL=$(az deployment group show -n main -g $RESOURCE_GROUP --query properties.outputs.hostUrl.value -o tsv)
PRODUCTS_URL=$(az deployment group show -n main -g $RESOURCE_GROUP --query properties.outputs.productsUrl.value -o tsv)
PRODUCTDETAIL_URL=$(az deployment group show -n main -g $RESOURCE_GROUP --query properties.outputs.productDetailUrl.value -o tsv)

echo "=== Deployment Complete ==="
echo "Host URL: $HOST_URL"
echo "Products URL: $PRODUCTS_URL"
echo "Product Detail URL: $PRODUCTDETAIL_URL"

# Create Service Principal for GitHub Actions
echo "Creating Service Principal for CI/CD..."
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
RESOURCE_GROUP="nx-store-demo-rg"

SP_PASSWORD=$(az ad sp create-for-rbac \
    --name "nx-store-demo-cicd" \
    --role contributor \
    --scope "subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}" \
    --query password -o tsv)

SP_APP_ID=$(az ad sp list \
    --display-name "nx-store-demo-cicd" \
    --query '[].appId' -o tsv)

TENANT_ID=$(az account show --query tenantId -o tsv)

echo "=== GitHub Secrets Required ==="
echo "Add these secrets to your GitHub repository:"
echo "AZURE_CLIENT_ID: $SP_APP_ID"
echo "AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "AZURE_TENANT_ID: $(az account show --query tenantId -o tsv)"
echo "AZURE_CLIENT_PASSWORD: $SP_PASSWORD"

echo ""
echo "Run the following to deploy the app:"
echo "git add . && git commit -m 'Add Azure CI/CD' && git push"
