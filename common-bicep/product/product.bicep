param apimServiceName string

@description('Name of the APIM Product to publish APIs')
@minLength(1)
@maxLength(80)
param productName string

@description('''Whether a product subscription is required for accessing APIs included in this product. 
If `true` (default), the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. 
If `false`, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key.''')
param subscriptionRequired bool = true

@description('''Whether subscription approval is required. 
If `false` (default), new subscriptions will be approved automatically enabling developers to call the product's APIs immediately after subscribing. 
If `true`, administrators must manually approve the subscription before the developer can any of the product's APIs. 
Can be present only if subscriptionRequired property is present and has a value of `false`.''')
param approvalRequired bool = false

@description('Product description. May include HTML formatting tags.')
param productDescription string

@description('Product name.')
param productDisplayName string

@description('''Whether the number of subscriptions a user can have to this product at the same time. 
Set to 0 to allow unlimited per user subscriptions. 
Can be present only if subscriptionRequired property is present and has a value of `false`.''')
param subscriptionLimit int = 0

@description('''Published products are discoverable by users of developer portal. 
Non published products are visible only to administrators. 
Default value is `false`.''')
param isPublished bool = false

@description('''Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.''')
param termsOfUse string = ''

@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
@description('Format of the policyContent.')
param productPolicyFormat string = 'rawxml'
@description('Policy content based on the format.')
param productPolicyContent string = ''

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource product 'Microsoft.ApiManagement/service/products@2021-08-01' = {
  name: productName
  parent: apimService
  properties: {
    approvalRequired: approvalRequired
    description: productDescription
    displayName: productDisplayName
    state: isPublished ? 'published' : 'notPublished'
    subscriptionRequired: subscriptionRequired
    subscriptionsLimit: subscriptionLimit == 0 ? null : subscriptionLimit
    terms: termsOfUse ?? null
  }
}

resource productPolicy 'Microsoft.ApiManagement/service/products/policies@2021-08-01' = if (!empty(productPolicyContent)) {
  name: 'policy'
  parent: product
  properties: {
    value: productPolicyContent
    format: productPolicyFormat
  }
}
output productId string = product.id
