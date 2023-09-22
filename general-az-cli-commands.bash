az bicep install && az bicep upgrade

az login

az account list
## Set the default subscription for all of the Azure CLI commands that you run in this session.
az account set --subscription "<Sub Name>" # Concierge Subscription

## Set the default to the resource group that's created for you in the sandbox environment.
az configure --defaults group=learn-39a17b8e-02ab-4688-9fb9-8e5b1d549ef9

az deployment group create --template-file main.bicep
# az deployment group create \
#   --template-file main.bicep \
#   --parameters environmentType=nonprod

az deployment group create \
  --template-file main.bicep \
  --parameters main.parameters.json

# When you create the deployment, we also override the value for appServicePlanInstanceCount.
#  Like with parameter files, you use the --parameters argument, 
az deployment group create \
  --template-file main.bicep \
  --parameters main.parameters.json \
               appServicePlanInstanceCount=5

az deployment group list --output table