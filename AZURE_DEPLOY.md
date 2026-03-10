# Azure Deployment Guide

## Prerequisites
- Azure account with $200 credit (signup at https://azure.microsoft.com/free)
- GitHub repository with this code
- Azure CLI installed: `winget install Microsoft.AzureCLI`

## Step 1: Create Azure Account
1. Go to https://azure.microsoft.com/free
2. Sign up with email: `gnanaraj.kalidass@gmail.com`
3. Complete identity verification
4. Add payment method (required for free tier, won't be charged)
5. Activate $200 credit in Cost Management

## Step 2: Install Azure CLI & Login
```bash
# Install Azure CLI
winget install Microsoft.AzureCLI

# Login
az login
```

## Step 3: Deploy Infrastructure
```bash
cd infra

# Make script executable (Linux/Mac)
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

This will:
- Create Resource Group
- Deploy 3 App Services (Host, Products, ProductDetail)
- Create Service Principal for GitHub Actions

## Step 4: Configure GitHub Secrets
Go to your GitHub repository → Settings → Secrets and add:

| Secret | Value |
|--------|-------|
| AZURE_CLIENT_ID | From deploy.sh output |
| AZURE_SUBSCRIPTION_ID | From deploy.sh output |
| AZURE_TENANT_ID | From deploy.sh output |
| AZURE_CLIENT_PASSWORD | From deploy.sh output |

## Step 5: Push to Deploy
```bash
git add .
git commit -m "Add Azure CI/CD"
git push origin main
```

The GitHub Actions workflow will:
1. Build all 3 applications
2. Deploy to Azure App Service
3. Your app will be live at: `https://nxstore-host.azurewebsites.net`

## Architecture
```
┌─────────────────────────────────────────────┐
│              Azure App Service              │
│  ┌─────────────────────────────────────┐   │
│  │         Host (Angular)              │   │
│  │   loads productsRemote MF           │   │
│  │   loads productDetailRemote MF      │   │
│  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
         │                    │
         ▼                    ▼
┌─────────────────┐  ┌─────────────────────────┐
│ Products Remote │  │ ProductDetail Remote    │
│ (nxstore-      │  │ (nxstore-productdetail   │
│  products.azure │  │  .azurewebsites.net)     │
│  .net)          │  │
└─────────────────┘  └─────────────────────────┘
```

## Cost Estimate (~$30-50/month)
- App Service Plan (B1): ~$13/month
- Bandwidth: ~$5-10/month
- Total: Under $25/month (covered by $200 credit for 8+ months)
