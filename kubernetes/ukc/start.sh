#!/bin/bash
# set -e

# Creates UKC setup in Kubernetes environment
cd "$(dirname "$0")"
# UKC
kubectl create configmap casp-public-key --from-file ukc-server/deployments/resources/casp_backup.pem
kubectl apply -f ukc-server/deployments/ukc-configmap.yaml
kubectl apply -f ukc-server/deployments/ukc-ep-secrets.yaml
kubectl apply -f ukc-server/deployments/ukc-volumes.yaml
kubectl apply -f ukc-server/deployments/ukc-ep-service.yaml
kubectl apply -f ukc-server/deployments/ukc-partner-service.yaml
kubectl apply -f ukc-server/deployments/ukc-aux-service.yaml
kubectl apply -f ukc-server/deployments/ukc-add-services.yaml
kubectl apply -f ukc-server/deployments/ukc-ep-server.yaml
kubectl apply -f ukc-server/deployments/ukc-partner-server.yaml
kubectl apply -f ukc-server/deployments/ukc-aux-server.yaml
kubectl apply -f ukc-server/deployments/ukc-add-servers.yaml

