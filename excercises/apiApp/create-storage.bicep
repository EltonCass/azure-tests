@description('Specifies the location for resources.')
param location string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 'teststorageaccount'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
    supportsHttpsTrafficOnly: true
  }
}
