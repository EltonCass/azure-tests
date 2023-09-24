@description('Specifies the location for resources.')
param location string = 'eastus'

param RG_Name string

targetScope= 'subscription'

resource conditionalDeploymentRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: RG_Name
  location: location
}

module nsg 'nsg.bicep' = {
  scope: conditionalDeploymentRG
  name: 'nsg'
  params: {
    nsgName: 'nsg'
    location: conditionalDeploymentRG.location
    allowRDP: true
  }
}
