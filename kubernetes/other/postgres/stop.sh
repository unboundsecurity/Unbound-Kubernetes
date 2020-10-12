#!/bin/bash
# set -e
cd "$(dirname "$0")"

# PostgreSQL
kubectl delete service postgres
kubectl delete configmap postgres-config
kubectl delete -f postgres-server/deployments/postgres-stateful.yaml
# WARNING, the line below deletes persistent volumes with data
if [[ " $@ " =~ " --delete-persistent-volumes " ]];
then
    kubectl delete persistentvolumeclaim postgres-postgres-0
fi
