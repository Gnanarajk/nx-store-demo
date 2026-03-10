# Azure Deployment Script for Nx Store Demo (Windows)
# Run this in PowerShell as Administrator

$ErrorActionPreference = "Stop"

Write-Host "=== Azure Deployment Script ===" -ForegroundColor Cyan

# Check if Azure CLI is installed
$azPath = Get-Command az -ErrorAction SilentlyContinue
if (-not $azPath) {
    Write-Host "Azure CLI not found. Installing..." -ForegroundColor Yellow
    Write-Host "Download from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
}

# Login check
Write-Host "Checking Azure login..." -ForegroundColor Yellow
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "Please run: az login" -ForegroundColor Red
    exit 1
}

Write-Host "Logged in as: $($account.user.name)" -ForegroundColor Green

# Get subscription
$subscriptionId = $account.id
Write-Host "Subscription: $subscriptionId" -ForegroundColor Green

# Variables
$resourceGroup = "nx-store-demo-rg"
$location = "eastus"
$prefix = "nxstore"

# Create resource group
Write-Host "Creating resource group..." -ForegroundColor Yellow
$existingRg = az group show --name $resourceGroup 2>$null
if (-not $existingRg) {
    az group create --name $resourceGroup --location $location --output none
    Write-Host "Resource group created" -ForegroundColor Green
} else {
    Write-Host "Resource group already exists" -ForegroundColor Yellow
}

# Deploy Bicep infrastructure
Write-Host "Deploying infrastructure (this may take a few minutes)..." -ForegroundColor Yellow
$deployment = az deployment group create `
    --resource-group $resourceGroup `
    --template-file "infra/main.bicep" `
    --parameters prefix=$prefix env=prod `
    --output json 2>&1 | ConvertFrom-Json

if ($deployment.properties.provisioningState -eq "Succeeded") {
    Write-Host "Infrastructure deployed successfully!" -ForegroundColor Green
} else {
    Write-Host "Infrastructure deployment failed" -ForegroundColor Red
    exit 1
}

# Get deployment outputs
$hostUrl = $deployment.properties.outputs.hostUrl.value
$productsUrl = $deployment.properties.outputs.productsUrl.value
$productDetailUrl = $deployment.properties.outputs.productDetailUrl.value

Write-Host "`n=== Deployment Complete ===" -ForegroundColor Cyan
Write-Host "Host URL: $hostUrl" -ForegroundColor Green
Write-Host "Products URL: $productsUrl" -ForegroundColor Green
Write-Host "Product Detail URL: $productDetailUrl" -ForegroundColor Green

# Create Service Principal for GitHub Actions
Write-Host "`nCreating Service Principal for CI/CD..." -ForegroundColor Yellow
$spn = az ad sp create-for-rbac `
    --name "nx-store-demo-cicd" `
    --role contributor `
    --scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup" `
    --output json 2>&1 | ConvertFrom-Json

$spAppId = $spn.appId
$spPassword = $spn.password
$tenantId = $account.tenantId

Write-Host "`n=== GitHub Secrets Required ===" -ForegroundColor Cyan
Write-Host "Add these secrets to your GitHub repository (Settings -> Secrets):" -ForegroundColor Yellow
Write-Host ""
Write-Host "AZURE_CLIENT_ID: $spAppId" -ForegroundColor White
Write-Host "AZURE_SUBSCRIPTION_ID: $subscriptionId" -ForegroundColor White
Write-Host "AZURE_TENANT_ID: $tenantId" -ForegroundColor White
Write-Host "AZURE_CLIENT_PASSWORD: $spPassword" -ForegroundColor White
Write-Host ""
Write-Host "Run: git add . && git commit -m 'Add Azure CI/CD' && git push" -ForegroundColor Cyan
