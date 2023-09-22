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
az deployment group create --resource-grpoup $RG --template-file .\manual-arm-storage-account.bicep|
# Need the RG
az group create --name $RG --location $location

# Try again,  but see what would happen first
az deployment group create --resource-group $RG --template-file .\manual-arm-storage-account.bicep --what-if
az deployment group create --resource-grpoup $RG --template-file .\manual-arm-storage-account.bicep|

# Show result
az resource list --resource-group $RG -o table

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