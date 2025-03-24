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

### Connecting to the Raspberry Pis from outside the local network

In order to connect to them from outside, we need to set a NordVPN meshnet.

#### Install NordVPN

In the Raspberry Pi, install NordVPN:

1. **Update the system:**
```shell
sudo apt update
sudo apt upgrade -y
```
2. **Install curl (if not already installed):**
```shell
sudo apt install curl
```
3. **Install NordVPN client:**
```shell
sh <(curl -sSf [https://downloads.nordcdn.com/apps/linux/install.sh](https://downloads.nordcdn.com/apps/linux/install.sh))
```
4. **Restart your Raspberry Pi:**
```shell
sudo reboot
```

#### Logging into NordVPN

1. **Initiate login:**

```shell
nordvpn login
```
2. **Complete login in browser:** Open the provided URL in a browser and click "Continue".
3. **Copy the callback URL:** Right-click the "Continue" button and copy the link. The URL will look similar to:

```
nordvpn://login?action=login&exchange_token=YOUR_EXCHANGE_TOKEN&status=done
```

4. **Login using the callback URL in the terminal (replace `<URL>` with the copied URL):**

```shell
nordvpn login --callback "<URL>"
```

#### Turning on Meshnet on the Raspberry Pi

1. **Enable Meshnet:**

```shell
nordvpn set meshnet on
```

2. **Verify Meshnet is enabled (optional):**

```bash
nordvpn meshnet peer list
```

#### Invite users to the meshnet

You can add users to the meshnet like this:

```shell
nordvpn meshnet invite send <email>
```

Install NordVPN in your machine and turn on the Meshnet. You should be able to
connect to the Raspberry Pi using the IP shown in:

```bash
nordvpn meshnet peer list
```

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
