# APIM Automation for centralized deployment of APIs

**This is a work in progress. This repo is a part of a larger effort to demonstrate secure workloads on Azure. This is for reference only and not meant for production workloads**

This sample demonstrates a possible DevOps strategy for Azure API Management deployments across multiple environments.
It follows a similar process as the [APIM Landing Zone Accelerator](https://github.com/Azure/apim-landing-zone-accelerator/blob/main/docs/Design-Areas/automation-devops.md), with a few changes.

## Similarities to the referenced Azure Accelerator

- A central team would manage the production APIM environment, deploying changes in Staging on a schedule.
- Environments are separated by different APIM instances (Dev/Staging/Prod).

## Differences from Landing Zone Accelerator

- Does not use the Creator or Extractor.
- Utilizes Bicep file functions to load policy XML, common values, and OpenAPI yaml definitions.
- The API definitions are synced from the supplied OpenAPI yaml. Policies are synced from the policy XML.

## Features

## Related GitHub repositories

### Supporting

|Item|Description|
|----|-----|
|[Utility Docker Images](https://github.com/colincmac/oink-docker-images)|Images used to support Ops scenarios. Built using [ACR Tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)|
|[Helm Charts](https://github.com/colincmac/oink-helm-charts)|Helm charts to support GitOps scenarios|
|[AKS GitOps - Core Platform](https://github.com/colincmac/aks-lz-manifests)|Flux multi-tenant configuration in AKS - Core Platform|
|[AKS GitOps - Shared Services](https://github.com/colincmac/aks-lz-shared-services-manifests)|Flux multi-tenant configuration in AKS - Shared Services|
|[Landing Zone IaC](https://github.com/colincmac/aks-lz-shared-services-manifests)| Bicep configuration of supporting Azure resources|

### Application Workloads

|Item|Description|
|----|-----|
|[Shared .NET Libraries](https://github.com/colincmac/oink-core-dotnet)|Base .NET seedwork for implementing CQRS, EventSourcing, and DDD|
|[Financial Account Management](https://github.com/colincmac/oink-financial-account-mgmt)|Serverless Azure Function used to demonstrate several concepts|

## Getting Started

### Prerequisites

(ideally very short, if any)

- OS
- Library version
- ...

### Installation

(ideally very short)

- npm install [package name]
- mvn install
- ...

### Quickstart

(Add steps to get up and running quickly)

1. git clone [repository clone url]
2. cd [repository name]
3. ...

## Demo

A demo app is included to show how to use the project.

To run the demo, follow these steps:

(Add steps to start up the demo)

1.
2.
3.

## Resources

(Any additional resources or related projects)

- Link to supporting information
- Link to similar sample
- ...
