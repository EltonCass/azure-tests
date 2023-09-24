param location string = resourceGroup().location
@secure()
param password string
param kvname string = 'bcpvault${uniqueString(resourceGroup().id, deployment().name)}'

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: kvname
  location: location
  properties: {
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    tenantId: subscription().id
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyVault
  name: 'adminpassword'
  properties: {
    value: password
  }
}

output kvname string = kvname
