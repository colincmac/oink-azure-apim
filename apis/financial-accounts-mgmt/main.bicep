@description('API friendly name.')
@maxLength(300)
@minLength(1)
param apiDisplayName string = 'Financial Account Management'

param apimServiceName string

@allowed([
  'graphql'
  'http'
  'soap'
  'websocket'
])
@description('Type of API to create')
param apiType string = 'http'
param apiName string = 'fin-acct-mgmt'

@description('Description of API Version Set.	')
param versionSetDescription string = 'Version set for ${apiDisplayName}'

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

module versionSet '../../common-bicep/api/versionSet.bicep' = {
  name: 'versionSet-${apiName}'
  params: {
    apiDisplayName: apiDisplayName
    versionScheme: 'Segment'
    versionSetDescription: versionSetDescription
    apiName: apiName
    apiServiceName: apimServiceName
  }
}

var v1CurrentRev = 2

module apiVer1Rev1 './v1/rev1/deploy.bicep' = {
  name: 'ver1-rev1'
  params: {
    apiDisplayName: apiDisplayName
    apimServiceName: apim.name
    apiName: apiName
    apiType: apiType
    isCurrent: v1CurrentRev == 1
    versionSetId: versionSet.outputs.versionSetId
  }
}

module apiVer1Rev2 './v1/rev2/deploy.bicep' = {
  name: 'ver1-rev2'
  dependsOn: [
    apiVer1Rev1
  ]
  params: {
    apiDisplayName: apiDisplayName
    apimServiceName: apim.name
    apiName: apiName
    apiType: apiType
    isCurrent: v1CurrentRev == 2
    versionSetId: versionSet.outputs.versionSetId
  }
}

var v2CurrentRev = 1

module apiVer2Rev1 './v2/rev1/deploy.bicep' = {
  name: 'ver2-rev1'
  dependsOn: [
    apiVer1Rev2
  ]
  params: {
    apiDisplayName: apiDisplayName
    apimServiceName: apim.name
    apiName: apiName
    apiType: apiType
    isCurrent: v2CurrentRev == 1
    versionSetId: versionSet.outputs.versionSetId
  }
}

var betaCurrentRev = 1

module beta './beta/rev1/deploy.bicep' = {
  name: 'beta-rev1'
  params: {
    apiDisplayName: apiDisplayName
    apimServiceName: apim.name
    apiName: apiName
    apiType: apiType
    isCurrent: betaCurrentRev == 1
    versionSetId: versionSet.outputs.versionSetId
  }
}
