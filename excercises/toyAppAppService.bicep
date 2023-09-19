// param location string = resourceGroup().location\
// @minLength(5)
// @maxLength(24)
// param storageAccountName string

// @secure()
// param sqlServerAdministratorLogin string

@description('The Azure region into which the resources should be deployed.')
param location string
param appServiceAppName string

@description('The name of the environment. This must be prod or nonprod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

param resourceTags object = {
  EnvironmentName: 'Test'
  Team: 'Human Resources'
}

// param cosmosDBAccountLocations array = [
//   {
//     locationName: 'australiaeast'
//   }
//   {
//     locationName: 'southcentralus'
//   }
//   {
//     locationName: 'westeurope'
//   }
// ]

var appServicePlanName = 'toy-product-launch-plan'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  tags: resourceTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
//output ipFqdn string = publicIPAddress.properties.dnsSettings.fqdn
