
# Unbound-Kubernetes

This folder contains helper scripts (in bash format) to start and stop UKC and CASP Kubernetes configurations.

## UKC

- `start-ukc.sh` - deploy UKC configuration.
- `stop-ukc.sh` - stop and remove UKC configuration (keeps persistent data).

**Note:** Use `stop-ukc.sh --delete-persistent-volumes` to delete UKC persistent data.

## CASP

- `start-casp.sh` - deploy CASP (including UKC) configurations.
- `stop-casp.sh` - stop and remove CASP (including UKC) configurations (keep persistent data).

**Note:** Use `stop-casp.sh --delete-persistent-volumes` to delete both UKC and CASP persistent data.

**Note:** When deploying the CASP configuration, the UKC configuration is deployed as well.
