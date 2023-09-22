@description('Specifies the location for resources.')
param location string = 'eastus'

resource storageacct 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'testingStorage399342'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

