$RG="teststorage"
$accname="test"
$dbname="testdb"
$location="eastus"

## Create SQL API Cosmos DB
az cosmosdb create --name $accname --resource-group $RG
## Create SQL API Cosmos DB Database
az cosmosdb sql database create `
    --account-name $accname --name $dbname `
    --resource-group $RG

## Create SQL API Cosmos Container
az cosmosdb sql container create `
    --resource-group $RG `
    --account-name $accname `
    --database-name $dbname `
    --name "testcontainer" `
    --partition-key-path "/id"

## Create Storage Account
az storage account create `
    --name storagesample22 `
    --resource-group $RG `
    --location $location `
    --kind StorageV2 `
    --sku Standard_RAGRS

    #storage, blobstorage
## Change Access Tier
az storage blob set-tier `
    --account-name storagesample22 `
    --account-key $(az storage account keys list --account-name storagesample22 --resource-group $RG --query "[0].value" -o tsv) `
    --container-name testcontainer `
    --name testblob.jpg `
    --tier Cool
    
## Copy items
az storage blob copy start-batch `
    --source-account-name storagesample22 `
    --source-account-key $(az storage account keys list --account-name storagesample22 --resource-group $RG --query "[0].value" -o tsv) `
    --souce-container testcontainer `
    --account-name storagesample22 `
    --account-key $(az storage account keys list --account-name storagesample21 --resource-group $RG --query "[0].value" -o tsv) `
    --destination-container testcontainer
