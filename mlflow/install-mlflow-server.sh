#!/bin/bash
helm repo add community-charts https://community-charts.github.io/helm-charts
helm repo update
helm install mlflow-server community-charts/mlflow