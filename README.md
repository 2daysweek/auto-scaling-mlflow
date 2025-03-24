# Auto-Scalable MLFlow on Raspberry Pi Cluster

## Overview

This project aims to develop an auto-scalable MLFlow system. We will build a
lightweight, containerized environment where incoming requests to run ML models
on datasets are managed by a simple request queue. When a new task is received,
the system dynamically spins up a Kubernetes pod that processes the request,
stores the results, and then frees up resources.

## Architecture 

### Central Node (Raspberry Pi 5)

- Hosts the MLFlow server and request queue.
- Serves as the Kubernetes control plane.

### Worker Nodes (Other Raspberry Pis)

- Run pods that execute ML models for prediction tasks.

### Kubernetes Distribution

- **k3s**: We propose using k3s instead of MicroK8s because it’s optimized for
low-resource environments like Raspberry Pis. k3s has a smaller footprint and
simpler configuration, making it ideal for our hackathon scenario.

### Request Queue

A lightweight queue (e.g., using RabbitMQ, Redis Queue, or a custom solution)
that handles incoming prediction requests. Once resources are free, the system
spins up a pod to process the task.

### Auto-Scaling

Pods are dynamically scaled based on the queue’s workload. This can be achieved
through Kubernetes’ Horizontal Pod Autoscaler (HPA) or a custom scaling
mechanism.

### Technologies and Tools Hardware

- Raspberry Pi 5 devices (1 central node, 2 worker nodes)

- Operating System: Raspberry Pi OS

- Containerization: Docker for packaging ML models and supporting services

- Kubernetes: k3s (recommended over MicroK8s for its lightweight footprint on
ARM-based devices)

- MLFlow: For tracking machine learning experiments

- Request Queue: RabbitMQ, Redis Queue, or similar

- Data Storage: Local 

## Setup 

### Prepare the Raspberry Pi Cluster

- Flash Raspberry Pi OS onto all devices.

- Connect the devices on the same network.

### Kubernetes Installation

- Central Node: Install k3s as the control plane.
- Worker Nodes: Join these nodes to the k3s cluster.
- Verify cluster health with kubectl get nodes.

### Containerization & Deployment

Build Docker images for the MLFlow server, ML model services, and the request
queue.

Push images to a local or cloud container registry.

### Deploy MLFlow & Request Queue

- Deploy MLFlow on the central node.
- Set up the request queue service to listen for incoming model execution
requests.

### Implement Auto-Scaling

- Configure Kubernetes autoscaling (via HPA or custom controllers) to monitor the
queue and spin up pods as needed.

### Testing:

- Simulate model requests to test auto-scaling and resource allocation.
- Monitor logs and resource usage to refine performance.

## Resources 

- [wp-k8s: WordPress on privately hosted Kubernetes cluster (Raspberry Pi 4 + Synology)](https://foolcontrol.org/?p=4004)
