#!/bin/bash
# set -e
cd "$(dirname "$0")"

# Mongo DB
kubectl delete -f deployments/mongodb.yaml
kubectl delete -f deployments/mongo-configmap.yaml
kubectl delete -f deployments/mongo-secrets.yaml
