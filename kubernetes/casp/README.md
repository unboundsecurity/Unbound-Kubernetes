# CASP Server in Kubernetes

Unbound’s Crypto Asset Security Platform (“**CASP**”) provides the advanced technology and the architecture to secure crypto asset transactions. An overview of the CASP solution is found [here](https://www.unboundtech.com/docs/CASP/CASP_User_Guide-HTML/Content/Products/CASP/CASP_Offering_Description/Solution.htm).

## Overview

The system architecture is shown in the following figure.

![CASP System](images/casp_arch.png)

The CASP implementation is comprised of the following components:

1. **UKC** - Unbound Key Management servers, including an Entry Point, Partner and Auxiliary server. [See details](../ukc/README.md).
2. **PostgreSQL Database** - used by CASP Service.
3. **CASP Services** - including the CASP core service and CASP wallet service.
4. **CASP Web UI** - a web interface used to manage CASP.
5. **Mongo DB** is used for centralized logging. [See details](../other/mongodb/README.md).

After installation, you can log into the CASP web interface and start using CASP!

<a name="General-Prerequisites"></a>
## General Prerequisites
The following are required before installing CASP.

1. An Infura project ID (only needed for Ethereum ledger access). See [Infura](https://infura.io/register).
   - Register for the Infura site.
   - Create a new project.
   - Copy the access token from the project page.
1. BlockSet access token.
1. Firebase messaging token (to enable push notifications). [Contact Unbound](https://www.unboundtech.com/company/contact-us/) for it.

## Configure the setup before start

The Kubernetes secrets file contains default passwords and access tokens (Infura, BlockSet, Firebase), and should be configured as needed. See [Secrets file](casp-server/deployments/casp-secrets.yaml).

The following parameters (which are listed above in the [General Prerequisites](#General-Prerequisites)) must be set or CASP will not start:

- CASP_FIREBASE_TOKEN - Firebase messaging token.
- INFURA_PROJECTID - Infura project ID for Ethereum.
- BLOCKSET_TOKEN - Blockset access token.


A number of other items may be configured for UKC. See [Configmap file](casp-server/deployments/casp-configmap.yaml).

The default CASP backup key is provided for demo purposes only. Create your own CASP backup key and provide it in [CASP backup key](../ukc/ukc-server/deployments/resources/casp_backup.pem).

## Scripts

Start/stop scripts are provided to apply/delete the CASP deployment. The scripts apply/delete the YAML files in the correct order.
