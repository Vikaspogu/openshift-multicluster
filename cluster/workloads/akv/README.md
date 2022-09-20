# Azure Key vault using CSI

```bash
az login
az group create --name "vpogu-akv" --location "EastUS"
az keyvault create --name "vpogu-keyvault" --resource-group "vpogu-akv" --location "EastUS"
az keyvault secret set --vault-name "vpogu-keyvault" --name "ExamplePassword" --value "hVFkk965BuUv"
```

## Create a service principal to access keyvault

```bash
export SERVICE_PRINCIPAL_CLIENT_SECRET="$(az ad sp create-for-rbac --skip-assignment --name http://vpogu-keyvault-test --query 'password' -otsv)"
export SERVICE_PRINCIPAL_CLIENT_ID="$(az ad sp show --id a7891faf-b6c9-4e4b-a091-2c9930d0cde9 --query 'appId' -otsv)"
az keyvault set-policy -n vpogu-keyvault --secret-permissions get --spn ${SERVICE_PRINCIPAL_CLIENT_ID}

kubectl create secret generic secrets-store-creds --from-literal clientid=${SERVICE_PRINCIPAL_CLIENT_ID} --from-literal clientsecret=${SERVICE_PRINCIPAL_CLIENT_SECRET}
kubectl label secret secrets-store-creds secrets-store.csi.k8s.io/used=true
```

## Resources

- https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/demos/standard-walkthrough/
- https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/configurations/identity-access-modes/service-principal-mode/
