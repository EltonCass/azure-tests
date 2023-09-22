resource testingStorage399342 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: 'testingstorage399342'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
