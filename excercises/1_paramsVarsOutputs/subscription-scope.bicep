@description('Specifies the location for resources.')
param location string = 'eastus'

targetScope= 'subscription'

resource biceRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'testBicepRG'
  location: location
}
