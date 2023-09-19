@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(24)
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(24)
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id) }'
param location string = 'westus3'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'toyAppAppService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: environmentType
  }
}

// resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
//   name: keyVaultName
// }

// module applicationModule 'application.bicep' = {
//   name: 'application-module'
//   params: {
//     apiKey: keyVault.getSecret('ApiKey')
//   }
// }

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
