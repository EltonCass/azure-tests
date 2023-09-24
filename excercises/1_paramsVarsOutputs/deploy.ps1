# Variables
code '.variables.ps1'
. './variables.ps1'

# Building and Deploying Bicep
# Createing a Bicep File from ARM template
code arm-storage-account.json

# Decompile using built-in command
az bicep decompile --file .\arm-storage-account.json

code .\arm-storage-account.bicep

# Creating a Bicep File from scratch
code .\manual-arm-storage-account.bicep

# Deploying a Bicep File
az login --only-show-errors
az account set -s $subscription

# RG Scope (it is expected this will fail since the RG does not exist yet)
az deployment group create --resource-group $RG --template-file .\arm-storage-account.bicep
# Need the RG
az group create --name $RG --location $location

# Try again,  but see what would happen first
az deployment group create --resource-group $RG --template-file .\manual-arm-storage-account.bicep --parameters prefix=testingStore --what-if
az deployment group create --resource-group $RG --template-file .\manual-arm-storage-account.bicep --parameters prefix=store

# Deploy with paremeter file
az deployment group create --resource-group $RG --template-file .\manual-arm-storage-account.bicep --parameters @storage-parameters.param.json

# Show result
az resource list --resource-group $RG -o table

# Deploy other services
code .\vnet.bicep
az deployment group create --resource-group $RG --template-file .\vnet.bicep --parameters vnetname=firstvnet3342
code .\aks.bicep
az deployment group create --resource-group $RG --template-file .\aks.bicep --parameters tierType=test

# Outputs
## Save outputs on a different file
az deployment group show --resource-group $RG --name vnet > vnet-output.json

## Check result
az deployment group show --resource-group $RG --name vnet --query 'properties.outputs'
az deployment group create --resource-group $RG --template-file .\aks.bicep --parameters tierType=test --query 'properties.outputs.fullyqualifieddomainname.value'
az deployment group create --resource-group $RG --template-file .\manual-arm-storage-account.bicep `
    --parameters @storage-parameters.param.json --query 'properties.outputs.keys'

#-----------------------------------------------
# Subscription Scope (expected to fail since we need to define a resource group first)
az deployment sub create --location $location --template-file .\manual-arm-storage-account.bicep

# Create a new bicep for a subscription
code ./subscription-scope.bicep
# Deploy RG group
az deployment sub create --location $location --template-file .\subscription-scope.bicep

# Management Group Scope
# az deployment mg create --location <location> --template-file <path-to-bicep>

# Tenant Group Scope
# az deployment tenant create --location <location> --template-file <path-to-bicep>

#-----------------------------------------------
# Powershell commandlets
# Connect-AzAccount -Subscription $subscription

# RG Scope
# New-AzResourceGroupDeployment -ResourceGroupName $RG -TemplateFile .\manual-arm-storage-account.bicep

# Subscription Scope
# New-AzSubscriptionDeployment -Location <location> -TemplateFile <path-to-bicep>

# Management Group Scope
# New-AzManagementGroupDeployment -Location <location> -TemplateFile <path-to-bicep>

# Tenant Scope
# New-AzTenantDeployment -Location <location> -TemplateFile <path-to-bicep>

## Delete RG
az group delete -g $RG --yes