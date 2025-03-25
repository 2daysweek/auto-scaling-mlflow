#!/bin/bash

NAMESPACE="kserve"

kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
kubectl delete namespace "cert-manager"

kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml -n kserve
kubectl delete -f config/gateway-class.yaml
kubectl delete -f config/gateway.yaml

helm delete kserve-crd oci://ghcr.io/kserve/charts/kserve-crd --version v0.14.1 -n ${NAMESPACE}

helm delete kserve oci://ghcr.io/kserve/charts/kserve

kubectl delete namespace "${NAMESPACE}"