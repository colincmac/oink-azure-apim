targetScope = 'subscription'

@description('Targeted region to deploy resources.')
param location string = deployment().location

@description('Target Resource Group for the API Management Service.')
param apimRgName string

@minLength(3)
@maxLength(50)
@description('Globally unique name of the API Management Service to provision.')
param apimName string

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string

@description('The name of the owner of the service')
@minLength(1)
param publisherName string

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
param existingVnetName string

@description('Existing virtual network resource group.')
param existingVnetRgName string = apimRgName

@description('Virtual network subnet name.')
param subnetName string

@description('''Virtual network subnet prefix. Minumum of `/29` size for a capacitySize of 1.
Reference: https://docs.microsoft.com/en-us/azure/api-management/virtual-network-concepts?tabs=stv2#subnet-size''')
param subnetPrefix string

@description('Name of NSG to create for the APIM subnet.')
param apimNsgName string = '${subnetName}-NSG'

@allowed([
  'External'
  'Internal'
  // 'private-endpoint'
])
@description('How to configure the APIM instance networking.')
param vnetType string = 'External'
param appInsightsId string = ''
param appInsightsInstrumentationKey string = ''
/*
TODO:
- Give Identity access to cert keyvault
- Import local TLS self-signed cert to trusted CA store
- Add backends
*/
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

module apimLogging '../common-bicep/apim/logging.bicep' = {
  name: '${apimName}-logging'
  scope: resourceGroup(apimRgName)
  dependsOn: [
    apim
  ]
  params: {
    apimName: apimName
    appInsightsId: appInsightsId
    appInsightsInstrumentationKey: appInsightsInstrumentationKey
  }
}

output apimId string = apim.outputs.provisionedResourceId
