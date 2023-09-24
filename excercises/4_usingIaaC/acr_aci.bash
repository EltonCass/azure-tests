$ACR_NAME = 'demoacr'
$RG="testBicepRG"
$location="eastus"

az login
az group create --name $RG --location $location
az create acr --resource-group $RG --name $ACR_NAME --sku Basic

az acr login --name $ACR_NAME

$ACR_LOGIN_SERVER = az acr show --name $ACR_NAME --query loginServer --output tsv

# Build docker Image
wsl
docker build -t webappimage:v1 .
## demo.azurecr.io
docker tag webappimage:v1 $ACR_LOGIN_SERVER/webappimage:v1
docker push $ACR_LOGIN_SERVER/webappimage:v1

## Build using ACR Tasks
az acr build --image "webappimage:v1" --registry $ACR_NAME --file Dockerfile .


