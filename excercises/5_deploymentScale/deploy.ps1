# Define variables
$RG="testcondrg"
$location="eastus"
$VNet=5

# Powershell
for ($vnetno = 1; $vnetno -le $Vnet; $vnetno++) {
    <# Action that will repeat until the condition is met #>
    $Vnetname = "PSVNET_$vnetno"
    az deployment group create --resource-group $RG `
        --template-file .\vnet.bicep `
        --parameters vnetname=$Vnetname
}

# Check Result
az network vnet list -g $RG -o table
# Delete RG
az group delete -g $RG --yes

#-----------------------------------------------
# Bicep Loop over range
copy '../paramsVarsOutputs/vnet.bicep' vnet-at-scale.bicep
code vnet-at-scale.bicep
# Deploy
az deployment group create --resource-group $RG --template-file vnet-at-scale.bicep `
    --parameters vnet_prefix=bicepvnet vnet=$vnets

# Check Result
az network vnet list -g $RG -o table
# Delete RG
az group delete -g $RG --yes


#-----------------------------------------------
# Bicep Array
# Deploy
az deployment group create --resource-group $RG --template-file vnet-array.bicep

# Check Result
az network vnet list -g $RG -o table
# Delete RG
az group delete -g $RG --yes