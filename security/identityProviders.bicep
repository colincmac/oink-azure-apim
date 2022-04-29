param apimServiceName string
param b2cTenantName string
param b2cClientId string

@secure()
param b2cClientSecret string

param b2cSignUpPolicy string

param b2cSignInPolicy string

param b2cProfileEditPolicy string
param b2cPasswordResetPolicy string

var b2cSignInTenant = '${b2cTenantName}.onmicrosoft.com'
var b2cAuthority = '${b2cTenantName}.b2clogin.com'

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource b2cIdentityProvider 'Microsoft.ApiManagement/service/identityProviders@2021-08-01' = {
  name: 'aadB2C'
  parent: apimService
  properties: {
    authority: b2cAuthority
    clientId: b2cClientId
    clientSecret: b2cClientSecret
    profileEditingPolicyName: b2cProfileEditPolicy
    passwordResetPolicyName: b2cPasswordResetPolicy
    signupPolicyName: b2cSignUpPolicy
    signinPolicyName: b2cSignInPolicy
    signinTenant: b2cSignInTenant
    allowedTenants: [
      b2cSignInTenant
    ]
  }
}
