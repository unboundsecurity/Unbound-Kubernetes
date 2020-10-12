# Getting started with Amazon EKS
Amazon Elastic Kubernetes Service (Amazon EKS) is a fully managed Kubernetes service. This readme contains details on how to get started with Amazon EKS. It contains links to the relevant AWS tutorials as needed.

After performing the following steps, one will have a cloud Kubernetes environment capable of running UKC/CASP.

## Accounts, users and roles
An IAM user with Administrator permissions is required. If this type of user does not exist, create one in your AWS account and then use that user for the following operations.

## Create a cluster
There are [two tutorials](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html) to choose from. The [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) tuturial is more simple, while the [console](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html) tutuorial provides more flexibility.

For "Compute" we recommend starting with *AWS Managed Nodes group*. [AWS Fargate](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html) may be added later for particular namespaces.

## Persistent storage
A [Persistent storage driver](https://aws.amazon.com/premiumsupport/knowledge-center/eks-persistent-storage/) needs to be installed.

**Note:** Currently, only EBS supports dynamic provisioning and thus it might be preferable over EFS.

## Access existing environment via kubectl
Access the existing environment as a client via `kubectl`. 
1. Perform the “Install the AWS CLI” and “Configure your AWS CLI credentials” steps in the [getting-started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html). 
1. Follow the instructions to [Create a cubeconfig](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html).

## Kubernetes Dashboard
1. Follow [these instructions](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html) to get started with the dashboard.
1. Use `kubectl proxy` to serve the dashboard for EKS.
