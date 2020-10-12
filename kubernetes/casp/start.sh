#!/bin/bash

cd "$(dirname "$0")"

# CASP
kubectl apply -f casp-server/deployments/casp-configmap.yaml
kubectl apply -f casp-server/deployments/casp-secrets.yaml
kubectl apply -f casp-server/deployments/casp-volumes.yaml
kubectl apply -f casp-server/deployments/casp-server-stateful.yaml
kubectl apply -f casp-server/deployments/casp-service.yaml

