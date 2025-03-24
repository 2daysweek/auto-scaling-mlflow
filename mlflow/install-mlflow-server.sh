#!/bin/bash
helm repo add community-charts https://community-charts.github.io/helm-charts
helm repo update


NAMESPACE=mlflow
RELEASE_NAME=mlflow-server

if [ -z "$NAMESPACE" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

# Check if the namespace exists
kubectl get namespace $NAMESPACE > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Namespace '$NAMESPACE' already exists."
else
  # Create the namespace
  kubectl create namespace $NAMESPACE
  if [ $? -eq 0 ]; then
    echo "Namespace '$NAMESPACE' created."
  else
    echo "Failed to create namespace '$NAMESPACE'."
  fi
fi


helm upgrade --install $RELEASE_NAME community-charts/mlflow --namespace $NAMESPACE --set .Values.ingress.enabled=true

wait

kubectl --namespace $NAMESPACE port-forward service/$(kubectl get svc | grep $RELEASE_NAME  | awk {'print $1}') 5000:5000 &

