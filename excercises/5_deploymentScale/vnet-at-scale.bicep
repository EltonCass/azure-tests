param location string = resourceGroup().location
param vnet_count int
param vnet_prefix string

param vnsettings object = {
  addressPrefix: '10.0.0.0/22'
  subnets: [
    {
      name: 'Subnet-1'
      addressPrefix: '10.0.0.0/24'
    }
    {
      name: 'Subnet-2'
      addressPrefix: '10.0.0.0/24'
    }
  ]
}

@batchSize(2)
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = [for i in range(0, vnet_count): {
  name: '${vnet_prefix}${i}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: vnsettings.subnets[0].name
        properties: {
          addressPrefix: vnsettings.subnets[0].addressPrefix
        }
      }
      {
        name: vnsettings.subnets[1].name
        properties: {
          addressPrefix: vnsettings.subnets[1].addressPrefix
        }
      }
    ]
  }
}]
