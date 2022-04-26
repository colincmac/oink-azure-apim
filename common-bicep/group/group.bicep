param apimServiceName string

@description('The friendly name of the group.')
param groupDisplayName string

@description('The name of the group.')
@minLength(1)
@maxLength(80)
param groupName string = toLower(replace(groupDisplayName, ' ', '-'))

@allowed([
  'custom'
  'external'
  'system'
])
param groupType string = 'custom'

param groupDescription string

@description('''If `groupType` is `external`. Identifier of the external groups, this property contains the id of the group from the external identity provider, e.g. for Azure Active Directory `aad://{tenant}.onmicrosoft.com/groups/{group object id}`.
If left empty, defaults to null.''')
param externalId string = ''

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource group 'Microsoft.ApiManagement/service/groups@2021-08-01' = {
  name: groupName
  parent: apimService
  properties: {
    description: groupDescription
    displayName: groupDisplayName
    externalId: externalId ?? null
    type: groupType
  }
}

output groupId string = group.id
