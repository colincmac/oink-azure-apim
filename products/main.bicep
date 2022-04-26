param apimServiceName string

module orgProducts 'products.bicep' = {
  name: 'org-products'
  params: {
    apimServiceName: apimServiceName
  }
}
