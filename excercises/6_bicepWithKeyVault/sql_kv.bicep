param sqlServerName string
param kvName string

param location string = resourceGroup().location

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: kvName
  scope: resourceGroup()
}

module sql 'sql.bicep' = {
  name: 'deploySql'
  params: {
    sqlServerName: sqlServerName
    adminPassword: keyVault.getSecret('adminpassword')
    location: location
  }
}
