@description('The Azure region into which the resources should be deployed.')
param location string

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'training'
  location: location
}
