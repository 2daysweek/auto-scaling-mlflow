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
