targetScope = 'subscription'

@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string

param apimServiceName string

@description('Targeted region to deploy resources.')
param location string = deployment().location

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

@allowed([
  'External'
  'Internal'
  // 'private-endpoint'
])
@description('How to configure the APIM instance networking.')
param vnetType string = 'External'

var env = {
  dev: json(loadTextContent('config.dev.json'))
  staging: json(loadTextContent('config.staging.json'))
  prod: json(loadTextContent('config.prod.json'))
}
var existingVnetName = env[environment].existingVnetName
var existingVnetRgName = env[environment].existingVnetRgName
var subnetName = env[environment].subnetName
var subnetPrefix = env[environment].subnetPrefix
var certificateKeyVaultRg = env[environment].certificateKeyVaultRg
var certificateKeyVaultName = env[environment].certificateKeyVaultName
var apimRgName = env[environment].apimRgName
var apimNsgName = '${subnetName}-NSG'

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
  name: apimServiceName
  scope: resourceGroup(apimRgName)
  params: {
    apimName: apimServiceName
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
  name: 'apim-kv-base-rbac'
  scope: resourceGroup(certificateKeyVaultRg)
  params: {
    keyVaultName: certificateKeyVaultName
    principalId: apim.outputs.systemIdentityPrincipalId
    roleGuid: '89a199fe-c3ac-4f9e-8c5e-b9b4b778847f' // Custom role allowing secret, key, and cert access
  }
}

// Certificate access seems to fail without this role
module kvCertRbacAccess '../common-bicep/keyVaultRoles.bicep' = {
  name: 'apim-kv-cert-rbac'
  scope: resourceGroup(certificateKeyVaultRg)
  params: {
    keyVaultName: certificateKeyVaultName
    principalId: apim.outputs.systemIdentityPrincipalId
    roleGuid: 'a4417e6f-fecd-4de8-b567-7b0420556985' // Key Vault Certificates Officer
  }
}

output apimId string = apim.outputs.apimId
