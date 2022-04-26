param apimServiceName string

@description('Name of the service that implements your front-end API and its operations.')
@minLength(3)
@maxLength(80)
param backendName string

param backendUrl string

@allowed([
  'azure-resource'
  'custom-url'
])
param backendType string = 'custom-url'

@description('The Azure resourceId if backendType is `azure-resource`.')
param azureResourceId string = ''

param backendAuthHeaders object = {}

@allowed([
  'http'
  'soap'
])
param protocol string = 'http'

@description('Simple description to identify the backend service.')
param backendDescription string

param validateCertificateChain bool = true
param validateCertificateName bool = true

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource backend 'Microsoft.ApiManagement/service/backends@2021-08-01' = {
  name: backendName
  parent: apimService
  properties: {
    credentials: {
      header: backendAuthHeaders
    }
    description: backendDescription
    protocol: protocol
    resourceId: backendType == 'azure-resource' ? azureResourceId : null
    tls: {
      validateCertificateChain: validateCertificateChain
      validateCertificateName: validateCertificateName
    }
    url: backendUrl
  }
}
