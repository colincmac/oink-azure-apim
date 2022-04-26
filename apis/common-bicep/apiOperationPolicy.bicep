param apimServiceName string
param apiRevisionName string
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
@description('Format of the policyContent.')
param format string
@description('Policy content based on the format.')
param value string

@description('Name of operation to apply the policy')
param operationName string

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' existing = {
  name: apiRevisionName
  parent: apimService
}

resource operation 'Microsoft.ApiManagement/service/apis/operations@2021-08-01' = {
  name: operationName
  parent: api
}

resource policy 'Microsoft.ApiManagement/service/apis/operations/policies@2021-08-01' = {
  name: 'policy'
  parent: operation
  properties: {
    format: format
    value: value
  }
}

output policyId string = policy.id
