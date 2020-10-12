#!/bin/bash
# set -e
cd "$(dirname "$0")"


# CASP
kubectl delete -f casp-server/deployments/casp-server-stateful.yaml
kubectl delete -f casp-server/deployments/casp-service.yaml
kubectl delete -f casp-server/deployments/casp-configmap.yaml
kubectl delete -f casp-server/deployments/casp-secrets.yaml
# WARNING, the line below deletes persistent volumes with all the data
if [[ " $@ " =~ " --delete-persistent-volumes " ]];
then
    kubectl delete -f casp-server/deployments/casp-volumes.yaml
fi





