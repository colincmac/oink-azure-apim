param apiName string
param versionSetId string
param apimServiceName string
param apiType string
param apiDisplayName string
param isCurrent bool

var rev = json(loadTextContent('revision-info.json'))
module apiRevision '../../../common-bicep/apiVersion.bicep' = {
  name: '${apiName}-${rev.version}-rev${rev.revision}'
  params: {
    apimServiceName: apimServiceName
    apiDisplayName: apiDisplayName
    apiType: apiType
    versionSetId: versionSetId

    apiVersionedName: apiName
    apiVersion: rev.version
    apiPath: rev.path
    revision: rev.revision
    apiVersionDescription: rev.apiDescription
    apiDescription: rev.apiDescription
    revisionDescription: rev.revisionDescription
    isCurrentRevision: isCurrent
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
