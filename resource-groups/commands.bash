#!/usr/bin/env bash
az group create \
  --name training \
  --location eastus2

#   az deployment group create \
#   --template-file main.bicep \
#   --resource-group storage-resource-group

# bicep build main.bicep
# bicep decompile