<<<<<<< HEAD
# https://kserve.github.io/website/0.8/modelserving/autoscaling/autoscaling/#predict-inferenceservice-with-concurrent-requests

=======
>>>>>>> main
### Deploy model in kserve

```shell
kubectl apply -f config/deploy-external-model.yaml
```

### Port forward model inference server
```
kubectl port-forward services/sklearn-iris-predictor 8080:80
```

### Get inference server
```
kubectl get inferenceservices sklearn-iris -n kserve-test
```


```
curl -v -H "Content-Type: application/json" http://localhost:8080/v1/models/sklearn-iris:predict -d @./request.json
```


## Load testing

### Install hey
```
brew install hey
```

```shell
INPUT_PATH="./request.json" 
SERVICE_HOSTNAME="localhost"
PREDICT_URI="http://localhost:8080/v1/models/sklearn-iris:predict"

hey -z 30s -c 10 -m POST -host ${SERVICE_HOSTNAME} -D $INPUT_PATH $PREDICT_URI
```
kubectl apply -n kserve-test -f - <<EOF
apiVersion: "serving.kserve.io/v1beta1"
kind: "InferenceService"
metadata:
  name: "sklearn-iris"
spec:
  predictor:
    model:
      modelFormat:
        name: sklearn
      storageUri: "gs://kfserving-examples/models/sklearn/1.0/model"
EOF
```


### Add metrics server
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
