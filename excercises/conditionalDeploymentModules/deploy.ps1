# Define variables
$RG="testcondrg"
$location="eastus"

# Create Network Security Group
code nsg.bicep
# Deploy
az deployment group create --resource-group $RG --template-file .\nsg.bicep --parameters nsgName=nsgwithRDP allowRDP=true
az deployment group create --resource-group $RG --template-file .\nsg.bicep --parameters nsgName=nsgwithoutRDP allowRDP=false

# List NSG
az network nsg list -g $rg -o table
az network nsg rule list -g $rg --nsg-name nsgwithRDP -o table
az network nsg rule list -g $rg --nsg-name nsgwithoutRDP -o table
# Delete RG
az group delete -g $RG --yes

#-----------------------------------------------
# Create Subscriptions with module
code subscription-scope.bicep
az deployment sub create --location $location --template-file .\subscription-scope.bicep --parameters RG_Name=$RG

az resource list --resource-group $RG -o table
# Delete RG
az group delete -g $RG --yes