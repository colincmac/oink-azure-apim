param apimServiceName string

module financialAccountMgmtApi 'financial-accounts-mgmt/main.bicep' = {
  name: 'deploy-financial-acct-mgmt'
  params: {
    apimServiceName: apimServiceName
  }
}
