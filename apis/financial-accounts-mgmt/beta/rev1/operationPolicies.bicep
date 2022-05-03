param apimServiceName string
param apiRevisionName string

module GetAccountPaymentsByAccountIdPolicy '../../../../common-bicep/api/apiOperationPolicy.bicep' = {
  name: 'GetAccountPaymentsByAccountId-Policy'
  params: {
    apimServiceName: apimServiceName
    apiRevisionName: apiRevisionName
    format: 'rawxml'
    operationName: 'GetAccountPaymentsByAccountId'
    value: loadTextContent('./policies/GetAccountPaymentsByAccountId.xml')
  }
}
