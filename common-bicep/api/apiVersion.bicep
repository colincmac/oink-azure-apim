param apiVersionedName string
param apimServiceName string

// API
@description('API friendly name.')
@maxLength(300)
@minLength(1)
param apiDisplayName string
@description('Description of the API. May include HTML formatting tags.')
param apiDescription string
@allowed([
  'graphql'
  'http'
  'soap'
  'websocket'
])
@description('Type of API to create')
param apiType string
@description('''Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. 
It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.''')
param apiPath string
@allowed([
  'http'
  'https'
  'ws'
  'wss'
])
param apiProtocols array = [
  'https'
]

@description('Defaults to email `oink@example.com`. Reference: https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service/apis?tabs=bicep#apicontactinformation ')
param apiContactInfo object = {}

// Version
@description('Indicates the version identifier of the API if the API is versioned.')
param apiVersion string
@description('Description of the API Version.')
param apiVersionDescription string = ''
@description('A resource identifier for the related ApiVersionSet.')
param versionSetId string

// Revision
@description('Describes the revision of the API. If no value is provided, default revision 1 is created.')
param revision int
@description('Description of the API Revision.')
param revisionDescription string = ''
@description('Release notes to publishe to the changelog.')
param revisionReleaseNotes string = ''
@description('Indicates if API revision is current api revision.')
param isCurrentRevision bool = false

@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
@description('Format of the policyContent.')
param globalPolicyFormat string = 'rawxml'
@description('(Optional) If customizing the global policy. Policy content based on the format.')
param globalPolicyContent string = ''

// Configuration
@description('')
@allowed([
  'graphql-link'
  'openapi'
  'openapi+json'
  'openapi+json-link'
  'openapi-link'
  'swagger-json'
  'swagger-link-json'
  'wadl-link-json'
  'wadl-xml'
  'wsdl'
  'wsdl-link'
])
param apiFormat string = 'openapi'

@description('Content value when Importing an API.')
param apiImportContent string = ''

@description('The license name used for the API.')
param licenseName string = ''
@description('A URL to the license used for the API. MUST be in the format of a URL')
param licenseUrl string = ''

@maxLength(2000)
@description('Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
param serviceUrl string = ''

@description('A URL to the Terms of Service for the API. MUST be in the format of a URL.')
param termsOfServiceUrl string = ''

@description('If true, will authorize the API with the default header and query param `subscription-key`.')
param useSubscriptionKey bool = false
param subscriptionKeyQueryParam string = 'subscription-key'
param subscriptionKeyHeader string = 'Ocp-Apim-Subscription-Key'

@description('Reference: https://docs.microsoft.com/en-us/azure/templates/microsoft.apimanagement/service/apis?tabs=bicep#authenticationsettingscontract')
param authenticationSettings object = {}

var common = json(loadTextContent('../../common.json'))
var isRevision = revision != 1
var revisionName = isRevision ? '${apiVersionedName};rev=${revision}' : apiVersionedName

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: revisionName
  parent: apim
  properties: {
    apiRevision: string(revision)
    apiRevisionDescription: revisionDescription
    apiType: apiType
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    apiVersionSetId: versionSetId

    authenticationSettings: authenticationSettings
    contact: empty(apiContactInfo) ? common.defaultContact : apiContactInfo

    description: apiDescription
    displayName: apiDisplayName
    license: !empty(licenseName) && !empty(licenseUrl) ? {
      name: licenseName
      url: licenseUrl
    } : null

    path: apiPath
    protocols: apiProtocols
    serviceUrl: serviceUrl ?? null
    subscriptionKeyParameterNames: useSubscriptionKey ? {
      header: subscriptionKeyHeader
      query: subscriptionKeyQueryParam
    } : null

    subscriptionRequired: useSubscriptionKey

    termsOfServiceUrl: termsOfServiceUrl ?? null
    type: apiType

    format: !empty(apiImportContent) ? apiFormat : null
    value: !empty(apiImportContent) ? apiImportContent : null
  }
}

resource globalPolicy 'Microsoft.ApiManagement/service/apis/policies@2021-08-01' = if (!empty(globalPolicyContent)) {
  name: 'policy'
  parent: api
  properties: {
    format: globalPolicyFormat
    value: globalPolicyContent
  }
}

resource setCurrent 'Microsoft.ApiManagement/service/apis/releases@2021-08-01' = if (isRevision && isCurrentRevision) {
  name: '${apim.name}/${apiVersionedName}/${apiVersion}-rev${revision}'
  properties: {
    notes: revisionReleaseNotes
    apiId: api.id
  }
}

output apiId string = api.id
output versionedName string = apiVersionedName
output revisionName string = revisionName
