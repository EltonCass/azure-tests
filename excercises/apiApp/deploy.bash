#!/usr/bin/env bash
resourceGroup=training
location=eastus2

az group create \
  --name $resourceGroup \
  --location $location

#   az deployment group create \
#   --template-file main.bicep \
#   --resource-group $resourceGroup

configName=training-appconfig

## Security
az role definition list --query "[?rolename == 'Storage Account Contributor']"

# App configuration service
az appconfig create \
  --name $configName \
  --resource-group $resourceGroup \
  --location $location

az appconfig kv set -n $configName \
  --key color --value blue --yes

## Export all configurations
az appconfig kv export \
  --name $configName \
  --destination file \
  --path ./appsettings.AzureAppConfiguration.json \
  --format json --separator :

az storage account create \
  --name teststorageaccount \
  --resource-group training \
  --location eastus2 \
  --sku Standard_LRS \
  --kind StorageV2 \
  --access-tier Cool \
  --https-only true