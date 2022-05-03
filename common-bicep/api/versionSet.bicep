@description('API friendly name.')
@maxLength(300)
@minLength(1)
param apiDisplayName string

param apiServiceName string
param apiName string

@allowed([
  'Query'
  'Header'
  'Segment'
])
param versionScheme string = 'Segment'

@description('Description of API Version Set.	')
param versionSetDescription string = 'Version set for ${apiDisplayName}'

@description('Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.')
param versionHeaderName string = ''

@description('Name of query parameter that indicates the API Version if versioningScheme is set to query.')
param versionQueryName string = ''

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiServiceName
}

resource versionSet 'Microsoft.ApiManagement/service/apiVersionSets@2021-08-01' = {
  name: replace(guid(apim.name, apiName), '-', '')
  parent: apim
  properties: {
    displayName: apiDisplayName
    versionQueryName: versionScheme == 'Query' ? versionQueryName : null
    versionHeaderName: versionScheme == 'Header' ? versionHeaderName : null
    versioningScheme: versionScheme
    description: versionSetDescription
  }
}

output versionSetId string = versionSet.id
