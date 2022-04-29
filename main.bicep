param apimServiceName string

@metadata({
  clientId: 'Application/Client ID for the Developer Portal App registration'
  clientSecret: 'Client secret for the Developer Portal App registration'
  passwordResetPolicy: 'Name of the B2C password reset policy'
  profileEditPolicy: 'Name of the B2C profile edit policy'
  signInPolicy: 'Name of the B2C sign in policy'
  signUpPolicy: 'Name of the B2C sign up policy'
  tenantName: '(Optional) contoso.onmicrosoft.com'
  authority: '(Optional) contoso.b2clogin.com'
})
@secure()
param portalB2cConfig object

// NOTE: This assumes an existing APIM instance. To deploy the APIM instance, 
// deploy the Bicep file `service/main.bicep`

module security 'security/main.bicep' = {
  name: 'configure-security'
  params: {
    apimServiceName: apimServiceName
    b2cClientId: portalB2cConfig.clientId
    b2cClientSecret: portalB2cConfig.clientSecret
    b2cPasswordResetPolicy: portalB2cConfig.passwordResetPolicy
    b2cProfileEditPolicy: portalB2cConfig.profileEditPolicy
    b2cSignInPolicy: portalB2cConfig.signInPolicy
    b2cSignUpPolicy: portalB2cConfig.signUpPolicy
    b2cTenantName: portalB2cConfig.tenantName
    b2cAuthority: portalB2cConfig.authority
  }
}

module products 'products/main.bicep' = {
  name: 'deploy-default-products'
  params: {
    apimServiceName: apimServiceName
  }
}

module apis 'apis/main.bicep' = {
  name: 'publish-all-apis'
  dependsOn: [
    products
    security // In case there are certificate dependencies
  ]
  params: {
    apimServiceName: apimServiceName
  }
}
