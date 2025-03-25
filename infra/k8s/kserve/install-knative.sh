#!/bin/bash

#https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/#prerequisites


set -e

echo "Installing metrics-server"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "Installing knative"
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-core.yaml

echo "Installing network layer"
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.17.0/kourier.yaml
kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'


echo "Installing serving extension with hpa"
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.17.0/serving-hpa.yaml


kubectl get pods -n knative-serving
