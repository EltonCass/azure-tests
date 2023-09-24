$RG="testBicepRG"
##$subscription=""
$location="eastus"
$vmName="myVM"
$linVmName="myLinVM"
$winos="win2019datacenter"
$linos="UbuntuLTS"
$username="elton"
$password="password123"

az login
az group create --name $RG --location $location
##az account set --subscription $subscription

## Windows VM
az vm create `
    --resource-group $RG `
    --name $vmName `
    --image $winos `
    --admin-username $username `
    --admin-password $password

# Using Powershell
# Connect-AzAccount -SubscriptionName $subscription
# New-AzResourceGroup -Name $RG -Location $location
# $WindowsCerd = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))
# New-AzVM -ResourceGroupName $RG `
#     -Name $vmName  `
#     -Image $winos `
#     -Credential $WindowsCerd `
#     -OpenPorts 3389

# Get-AzPublicIpAddress `
#     -ResourceGroupName $RG `
#     -Name $vmName `
#     | Select-Object IpAddress

# Remove-AzResourceGroup -Name $RG

## Linux VM
az vm create `
    --resource-group $RG `
    --name $linVmName `
    --image $linos `
    --admin-username $username `
    --authentication-type "ssh" `
    --ssh-key-value ~/.ssh/id_rsa.pub

## Open ports for Windows
az vm open-port `
    --resource-group $RG `
    --name $vmName `
    --port 3389

## Open ports for Linux
az vm open-port `
    --resource-group $RG `
    --name $linVmName `
    --port 22

## Get Public IP
az vm list-ip-addresses `
    --resource-group $RG `
    --name $vmName `
    --output table

## Log into Linux VM
ssh elton@PUBLIC_IP

az group delete --name $RG --yes


## Run ACI script
acr_aci.sh