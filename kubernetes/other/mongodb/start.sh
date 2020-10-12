#!/bin/bash
# set -e
cd "$(dirname "$0")"

# Mongo DB
kubectl apply -f deployments/mongo-configmap.yaml
kubectl apply -f deployments/mongo-secrets.yaml
kubectl apply -f deployments/mongodb.yaml

