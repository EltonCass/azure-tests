# Define variables
$RG="testcondrg"
# Securing bicep
code sql.bicep

# Create a KV and secret
code keyvault.bicep

$PW="P@ssw0rd1234"
# Get the output in a variable
$KVName = (az deployment group create --resource-group $RG `
    --template-file .\keyvault.bicep `
    --parameters password=$PW `
    --query 'properties.outputs.kvname.value' -o tsv)
## Deploy Key Vault
az keyvault secret show --vault-name $KVName --name adminpassword

# Create Sql Server using keyvault password secret
code.sql_kv.bicep

# Create Server Name
$sqlserver="sqlserver" + (Get-Random -Minimum 1000000 -Maximum 9999999)
# Deploy Sql Server
az deployment group create --resource-group $RG `
    --template-file .\sql_kv.bicep `
    --parameters sqlServerName=$sqlserver kvname=$KVName

# Create Firewall Rule
az sql server firewall-rule create -g $RG -s $sqlserver -n 'Azure' `
    --start-ip-adress 0.0.0.0 --end-ip-address 0.0.0.0

# Set Sql Server Full Name
$Servername = $sqlserver + ".database.windows.net"
# Connect to Sql Server
sqlcmd -S $Servername -U sqladmin -P $PW -Q "SELECT @@VERSION"

# Delete RG
az group delete -g $RG --yes