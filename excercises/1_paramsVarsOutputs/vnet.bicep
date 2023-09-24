param location string = resourceGroup().location
param vnetname string
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

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetname
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
}

output vnetname string = vnetname
output vnettype string = virtualNetwork.type
