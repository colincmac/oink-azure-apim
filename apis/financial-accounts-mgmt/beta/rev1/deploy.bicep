param apiName string
param versionSetId string
param apimServiceName string
param apiType string
param apiDisplayName string
param isCurrent bool

var rev = json(loadTextContent('revision-info.json'))
module apiRevision '../../../../common-bicep/api/apiVersion.bicep' = {
  name: '${apiName}-${rev.version}-rev${rev.revision}'
  params: {
    apimServiceName: apimServiceName
    apiDisplayName: apiDisplayName
    apiType: apiType
    versionSetId: versionSetId
    isCurrentRevision: isCurrent

    apiVersionedName: '${apiName}-${rev.version}'
    apiVersion: rev.version
    apiPath: rev.path
    revision: rev.revision
    apiVersionDescription: rev.apiDescription
    apiDescription: rev.apiDescription
    revisionDescription: rev.revisionDescription
    useSubscriptionKey: rev.subscriptionRequired
    revisionReleaseNotes: rev.releaseNotes
    apiImportContent: loadTextContent('open-api.yaml')
    apiFormat: 'openapi'
    serviceUrl: rev.serviceUrl
  }
}

module policies 'operationPolicies.bicep' = {
  name: 'operationPolicies'
  params: {
    apiRevisionName: apiRevision.outputs.revisionName
    apimServiceName: apimServiceName
  }
}

output revisionId string = apiRevision.outputs.apiId
output revisionName string = apiRevision.outputs.revisionName
output versionedName string = apiRevision.outputs.versionedName
