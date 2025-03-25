#!/bin/bash

# Based on:
# https://kserve.github.io/website/master/admin/kubernetes_deployment/#2-install-network-controller

set -e

NAMESPACE="kserve"

echo "Installing cert-manager"
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml

while true; do
    if [[ -z "$(kubectl get pods -n cert-manager --field-selector=status.phase!=Running -o name)" ]]; then
        echo "container is ready"
    break
  else
    echo "wait for container to get ready"
    sleep 1;
  fi
done

echo "Installing kserve network configuration in namespace ${NAMESPACE}"

if kubectl get namespace | grep -q "kserve"; then
  echo "Namespace '$NAMESPACE' already exists."
else
  # Create the namespace
  echo "creating namespace"
  kubectl create namespace $NAMESPACE
  if [ $? -eq 0 ]; then
    echo "Namespace '$NAMESPACE' created."
  else
    echo "Failed to create namespace '$NAMESPACE'."
  fi
fi

echo "Waiting for cert-manager to be ready (60s)"
sleep 30

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml -n kserve
kubectl apply -f config/gateway-class.yaml
kubectl apply -f config/gateway.yaml

echo "Waiting for kserve dependencies to be ready (60s)"
sleep 60

echo "Installing kserve"
helm install kserve-crd oci://ghcr.io/kserve/charts/kserve-crd --version v0.14.1 -n ${NAMESPACE}

echo "Waiting for kserve-crd to be ready (30s)"
sleep 30

helm upgrade --install kserve oci://ghcr.io/kserve/charts/kserve --version v0.14.1  --namespace ${NAMESPACE} \
 --set kserve.controller.deploymentMode=RawDeployment \
 --set kserve.controller.gateway.ingressGateway.enableGatewayApi=true \
 --set kserve.controller.gateway.ingressGateway.kserveGateway=${NAMESPACE}/kserve-ingress-gateway

while true; do
  if [[ -z "$(kubectl get pods -n kserve --field-selector=status.phase!=Running -o name)" ]]; then
    echo "KServe controller is ready"
    break
  else
    echo "Waiting for kserve controller to get ready"
    sleep 1;
  fi
done

echo "KServe is ready to be used."
