#!/bin/bash
helm repo add getindata https://getindata.github.io/helm-charts/
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


helm upgrade --install $RELEASE_NAME getindata/mlflow --namespace $NAMESPACE --set ingress.enabled=true --set persistence.defaultArtifactRoot="file:/tmp/artifacts"	

while true; do
  if [[ "$(kubectl get pods | grep $RELEASE_NAME | awk {'print $3}')" == "Running" ]]; then
    echo "container is ready"
    break
  else
    echo "wait for container to get ready"
    sleep 1;
  fi
done

echo "port forwarding"

kubectl --namespace $NAMESPACE port-forward service/$RELEASE_NAME 8080:8080 &

