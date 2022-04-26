
param apimName string

resource apim 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimName
}
