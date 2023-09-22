#!/usr/bin/env bash
az group create \
  --name training \
  --location eastus2

#   az deployment group create \
#   --template-file main.bicep \
#   --resource-group storage-resource-group

az storage account create \
  --name teststorageaccount \
  --resource-group training \
  --location eastus2 \
  --sku Standard_LRS \
  --kind StorageV2 \
  --access-tier Cool \
  --https-only true

# bicep build main.bicep
# bicep decompile