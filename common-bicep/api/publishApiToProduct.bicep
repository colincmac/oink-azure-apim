param apimServiceName string

@description('Name of the APIM Product to publish APIs')
@minLength(1)
@maxLength(80)
param productName string

param apiVersionedName string

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource product 'Microsoft.ApiManagement/service/products@2021-08-01' existing = {
  name: productName
  parent: apimService
}

resource publishedApi 'Microsoft.ApiManagement/service/products/apis@2021-08-01' = {
  name: apiVersionedName
  parent: product
}
