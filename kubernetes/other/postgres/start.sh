#!/bin/bash
# set -e
cd "$(dirname "$0")"

# PostgreSQL
kubectl apply -f postgres-server/deployments/postgres-configmap.yaml
kubectl apply -f postgres-server/deployments/postgres-service.yaml
kubectl apply -f postgres-server/deployments/postgres-stateful.yaml


