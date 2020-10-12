#!/bin/bash
# set -e

# Delete UKC setup in Kubernetes environment

cd "$(dirname "$0")"
# UKC
kubectl delete -f ukc-server/deployments/ukc-add-servers.yaml
kubectl delete -f ukc-server/deployments/ukc-ep-server.yaml
kubectl delete -f ukc-server/deployments/ukc-partner-server.yaml
kubectl delete -f ukc-server/deployments/ukc-aux-server.yaml
kubectl delete -f ukc-server/deployments/ukc-add-services.yaml
kubectl delete -f ukc-server/deployments/ukc-ep-service.yaml
kubectl delete -f ukc-server/deployments/ukc-partner-service.yaml
kubectl delete -f ukc-server/deployments/ukc-aux-service.yaml
kubectl delete -f ukc-server/deployments/ukc-configmap.yaml
kubectl delete -f ukc-server/deployments/ukc-ep-secrets.yaml
kubectl delete configmap casp-public-key
# WARNING, the line below deletes UKC persistent volumes with data
if [[ " $@ " =~ " --delete-persistent-volumes " ]];
then
    kubectl delete -f ukc-server/deployments/ukc-volumes.yaml
fi

