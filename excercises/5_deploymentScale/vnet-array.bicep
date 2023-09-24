param location string = resourceGroup().location
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

var vnets = [
  'ArrayVNET1'
  'ArrayVNET2'
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = [for vnet in vnets: {
  name: vnet
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
