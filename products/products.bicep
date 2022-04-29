param apimServiceName string

module unlimited '../common-bicep/product/product.bicep' = {
  name: 'product-unlimited'
  params: {
    productDescription: 'Subscribers have completely unlimited access to the API. Administrator approval is required.'
    subscriptionRequired: true
    approvalRequired: true
    subscriptionLimit: 1
    isPublished: true
    productDisplayName: 'Unlimited'
    apimServiceName: apimServiceName
    productName: 'unlimited'
    productPolicyContent: loadTextContent('policies/unlimited.xml')
  }
}

module starter '../common-bicep/product/product.bicep' = {
  name: 'product-starter'
  params: {
    productDescription: 'Include 3 APIs. Limited to 1 subscription per developer. Throttled at 3 calls per 10 second.'
    subscriptionRequired: true
    approvalRequired: true
    subscriptionLimit: 1
    isPublished: true
    productDisplayName: 'Starter'
    apimServiceName: apimServiceName
    productName: 'starter'
  }
}

module beta '../common-bicep/product/product.bicep' = {
  name: 'product-beta'
  params: {
    productDescription: 'Allows for Beta API access.'
    subscriptionRequired: true
    approvalRequired: true
    subscriptionLimit: 1
    isPublished: true
    productDisplayName: 'Beta'
    apimServiceName: apimServiceName
    productName: 'beta'
  }
}
