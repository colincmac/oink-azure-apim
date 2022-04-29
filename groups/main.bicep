param apimServiceName string
param developerAadGroup string

// Example group, not in use at the moment
module orgDeveloperGroup '../common-bicep/group/group.bicep' = {
  name: 'orgDevGroup'
  params: {
    apimServiceName: apimServiceName
    groupDescription: 'Group containing all developers from Oink Financial who will be consuming our APIs'
    groupDisplayName: 'Oink Developers'
    groupType: 'external'
    externalId: developerAadGroup
  }
}
