
# Unbound-Kubernetes

This repository enables deploying Unbound Tech products in a containerized manner using [Kubernetes](https://kubernetes.io/). This solution supports **UKC** and **CASP**. 

**Note:** The CASP deployment includes UKC as subset.

## Prerequisites
A Kubernetes cluster that is configured with `kubectl` access is required. See [Getting Started with Amazon EKS](Getting_Started_with_Amazon_EKS.md) to get started with Kubernetes in the Amazon EKS.


## Kubernetes Setup

### Notes about the Kubernetes setup
- The *kubernetes* directory contains YAML files with Kubernetes definitions.
- The UKC setup includes three UKC servers along with the option of scaling with more server pairs. See [UKC server description](kubernetes/ukc/README.md) for details.
- The CASP setup includes a CASP server and CASP bots.
- Scripts are provided to automate the Kubernetes deployment tasks. 

### Run these commands to set up Kubernates
1. Run the following command one time.
    ```
    kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>
    ```
1. Run `kubernetes/start-ukc.sh` to deploy UKC.
2. Run `kubernetes/start-casp.sh` to deploy both CASP and UKC.

There are also corresponding scripts to stop the servers and delete the setup.


## Advanced: Build Docker Images
If you need to build the Docker images, follow these steps.

1. Clone or download this repository.
2. The [docker](./docker) directory contains the files required to build Docker images.
3. Build CASP by running the following command in *docker/casp/casp-server* directory.

    `docker build`

    See [CASP image build](docker/casp/casp-server) for more details.
4. Build UKC by running the following command in *docker/ukc/ukc-server* directory.

    `docker build`

    See [UKC image build](docker/ukc/ukc-server) for more details.
