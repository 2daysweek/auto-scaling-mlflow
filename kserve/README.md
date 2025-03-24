# Run minikube with kserve
## https://kserve.github.io/website/master/admin/kubernetes_deployment/#2-install-network-controller
1. Start Minikube

1. Install [certmanager](https://cert-manager.io/docs/installation/)
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
```

1. Setup gateway for kserve
```
k create namespace kserve
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml -n kserve
kubectl apply -f config/gateway-class.yaml
kubectl apply -f config/gateway.yaml
```

1. Install Kserve on cluster
```
helm install kserve-crd oci://ghcr.io/kserve/charts/kserve-crd --version v0.14.1 -n kserve

helm install kserve oci://ghcr.io/kserve/charts/kserve --version v0.14.1  --namespace kserve \
 --set kserve.controller.deploymentMode=RawDeployment \
 --set kserve.controller.gateway.ingressGateway.enableGatewayApi=true \
 --set kserve.controller.gateway.ingressGateway.kserveGateway=kserve/kserve-ingress-gateway
````

1. verify kserve is running by running `kubectl get pods -n kserve`
```
$ kubectl get pods -n kserve
NAME                                         READY   STATUS    RESTARTS   AGE
kserve-controller-manager-58c9c57c74-wrfg5   1/2     Running   0          6s
modelmesh-controller-7555c9776c-lxpwm        0/1     Running   0          6s
```
