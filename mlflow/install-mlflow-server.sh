#!/bin/bash
helm repo add bitnami https://charts.bitnami.com/bitnami
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


helm upgrade --install $RELEASE_NAME bitnami/mlflow --version 2.5.5 --namespace $NAMESPACE --set tracking.ingress.enabled=true --set tracking.auth.enabled=false

while true; do
  if [[ "$(kubectl get pods -n $NAMESPACE | grep $RELEASE_NAME-tracking | awk {'print $3}')" == "Running" ]]; then
    echo "container is ready"
    break
  else
    echo "wait for container to get ready"
    sleep 1;
  fi
done

echo "mlflow is ready to be used"