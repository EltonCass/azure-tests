#!/usr/bin/env bash
az storage account create \
  --name teststorageaccount \
  --resource-group training \
  --location eastus2 \
  --sku Standard_LRS \
  --kind StorageV2 \
  --access-tier Cool \
  --https-only true