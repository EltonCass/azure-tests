ACR_NAME='demoacr'
RG="testBicepRG"
location="eastus"

az login
az group create --name $RG --location $location
## Create ACR without Admin Permissions
az create acr --resource-group $RG --name $ACR_NAME --sku Basic
## Create an ACR with admin permissions
# az deployment group create -template-file acr_aci.bicep \
#     -resource-group $RG -parameters acrName=$ACR_NAME

az acr login --name $ACR_NAME

ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)

# Build docker Image
## If you are using WSL, you need to switch to the Linux container mode
wsl
docker build -t webappimage:v1 .
## demo.azurecr.io
docker tag webappimage:v1 $ACR_LOGIN_SERVER/webappimage:v1
docker push $ACR_LOGIN_SERVER/webappimage:v1

# Get List of repos
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository webappimage --output table

##-----------------------------------------------------
## Build using ACR Tasks instead of manually
az acr build --image "webappimage:v1" --registry $ACR_NAME .
az acr repository show-tags --name $ACR_NAME --repository webappimage --output table

##-----------------------------------------------------
## Create Service Principal for ACI
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

SP_NAME=acr-service-principal
SP_PASSWD=$(az ad sp create-for-rbac \
    --name $SP_NAME --scopes $ACR_REGISTRY_ID \
    --role acrpull --query password --output tsv)

SP_APPID=$(az ad sp show \
    --id http://$SP_NAME --query appId --output tsv)

CI_NAME=demorg
## Create ACI for ACR with SP permissions
az container create --resource-group $RG --name $CI_NAME \
    --image $ACR_LOGIN_SERVER/webappimage:v1 \
    --registry-login-server $ACR_LOGIN_SERVER \
    --registry-username $SP_APPID \
    --registry-password $SP_PASSWD \
    --dns-name-label webappcontainer \
    --ports 80

## Create ACI for ACR with Admin permissions
# az container create --resource-group $RG --name $CI_NAME \
#     --image $ACR_LOGIN_SERVER/webappimage:v1 \
#     --dns-name-label webappcontainer \
#     --ports 80

az container show --resource-group $RG \ 
    --name $CI_NAME

URL=$(az container show --resource-group $RG \ 
    --name $CI_NAME --query ipAddress.fqdn --output tsv)

curl $URL

## Logs
az container logs --resource-group $RG --name $CI_NAME

## Delete container
az container delete --resource-group $RG --name $CI_NAME --yes

## Cleanup
az group delete --name $RG --yes
docker image rm $ACR_LOGIN_SERVER/webappimage:v1