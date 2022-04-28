targetScope = 'subscription'

@description('Targeted region to deploy resources.')
param location string = deployment().location

@description('Target Resource Group for the API Management Service.')
param apimRgName string = 'lz-apps-mgmt-oink'

@minLength(3)
@maxLength(50)
@description('Globally unique name of the API Management Service to provision.')
param apimName string = 'oink-dev-001'

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string = 'cmccullough@microsoft.com'

@description('The name of the owner of the service')
@minLength(1)
param publisherName string = 'Oink Financial'

@allowed([
  'Basic'
  'Consumption'
  'Developer'
  'Isolated'
  'Premium'
  'Standard'
])
@description('The pricing tier of this API Management service')
param skuSize string = 'Developer'

@description('The instance size of this API Management service.')
param capacitySize int = 1

@description('Existing virtual network name.')
param existingVnetName string = 'apps-mgmt-oink-eastus2'

@description('Existing virtual network resource group.')
param existingVnetRgName string = apimRgName

@description('Virtual network subnet name.')
param subnetName string = 'APIM-dev'

@description('''Virtual network subnet prefix. Minumum of `/29` size for a capacitySize of 1.
Reference: https://docs.microsoft.com/en-us/azure/api-management/virtual-network-concepts?tabs=stv2#subnet-size''')
param subnetPrefix string = '10.2.4.32/27'

@description('Name of NSG to create for the APIM subnet.')
param apimNsgName string = '${subnetName}-NSG'

@allowed([
  'External'
  'Internal'
  // 'private-endpoint'
])
@description('How to configure the APIM instance networking.')
param vnetType string = 'External'

param certificateKeyVaultRg string
param certificateKeyVaultName string

module networking '../common-bicep/apim/secureApimNetwork.bicep' = {
  name: 'apimNetworking'
  scope: resourceGroup(existingVnetRgName)
  params: {
    apimNsgName: apimNsgName
    existingVnetName: existingVnetName
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    isExternal: vnetType == 'external'
    location: location
  }
}

module apim '../common-bicep/apim/apim.bicep' = {
  name: apimName
  scope: resourceGroup(apimRgName)
  params: {
    apimName: apimName
    capacitySize: capacitySize
    existingSubnetId: networking.outputs.subnetId
    publisherEmail: publisherEmail
    publisherName: publisherName
    skuSize: skuSize
    location: location
    vnetType: vnetType
  }
}

module kvBaseRbacAccess '../common-bicep/keyVaultRoles.bicep' = {
  name: 'apim-kv-rbac'
  scope: resourceGroup(certificateKeyVaultRg)
  params: {
    keyVaultName: certificateKeyVaultName
    principalId: apim.outputs.systemIdentityPrincipalId
    roleGuid: '89a199fe-c3ac-4f9e-8c5e-b9b4b778847f' // Custom role allowing secret, key, and cert access
  }
}

// Certificate access seems to fail without this role
module kvCertRbacAccess '../common-bicep/keyVaultRoles.bicep' = {
  name: 'apim-kv-rbac'
  scope: resourceGroup(certificateKeyVaultRg)
  params: {
    keyVaultName: certificateKeyVaultName
    principalId: apim.outputs.systemIdentityPrincipalId
    roleGuid: 'a4417e6f-fecd-4de8-b567-7b0420556985' // Key Vault Certificates Officer
  }
}

// TODO: configure default loggers and diagnostics
// module apimLogging '../common-bicep/apim/logging.bicep' = {
//   name: '${apimName}-logging'
//   scope: resourceGroup(apimRgName)
//   dependsOn: [
//     apim
//   ]
//   params: {
//     apimName: apimName
//     appInsightsId: appInsightsId
//     appInsightsInstrumentationKey: appInsightsInstrumentationKey
//   }
// }

output apimId string = apim.outputs.apimId
