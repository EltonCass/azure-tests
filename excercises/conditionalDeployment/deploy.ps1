$RG="testConditionalRG"
$subscription=""
$location="eastus"

code nsg.bicep
az deployment group create --resource-group $RG --template-file .\nsg.bicep --parameters nsgName=nsgwithRDP allowRDP=true
az deployment group create --resource-group $RG --template-file .\nsg.bicep --parameters nsgName=nsgwithoutRDP allowRDP=false

az network nsg list -g $rg -o table
az network nsg rule list -g $rg --nsg-name nsgwithRDP -o table
az network nsg rule list -g $rg --nsg-name nsgwithoutRDP -o table

az group delete -g $RG --yes