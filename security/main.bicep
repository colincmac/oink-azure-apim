param apimServiceName string
param b2cTenantName string
param b2cClientId string

@secure()
param b2cClientSecret string

param b2cSignUpPolicy string

param b2cSignInPolicy string

param b2cProfileEditPolicy string
param b2cPasswordResetPolicy string

param b2cSignInTenant string = '${b2cTenantName}.onmicrosoft.com'
param b2cAuthority string = '${b2cTenantName}.b2clogin.com'

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

module identityProviders 'identityProviders.bicep' = {
  name: 'apim-identity-providers'
  params: {
    b2cAuthority: b2cAuthority
    b2cClientId: b2cClientId
    b2cClientSecret: b2cClientSecret
    b2cProfileEditPolicy: b2cProfileEditPolicy
    b2cPasswordResetPolicy: b2cPasswordResetPolicy
    b2cSignUpPolicy: b2cSignUpPolicy
    b2cSignInPolicy: b2cSignInPolicy
    b2cSignInTenant: b2cSignInTenant
    b2cTenantName: b2cTenantName
    apimServiceName: apimServiceName
  }
}
