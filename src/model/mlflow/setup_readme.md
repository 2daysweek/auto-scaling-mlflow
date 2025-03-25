## Guided steps to start a mlflow server using helm deployments and register a model in it.


1. Run  below bash script to install mlflow server using helm chart
```bash 
  mlflow/install-mlflow-server.sh.
```
You should see "Container is ready" and "Port forwarding" message in logs of above command.

2. Open browser and enter URL `http://localhost:8080/`
  You'll see the mlflow instance up and running.

3. Now run below command to download the dependencies for the model.
```python
    pip install -r mlflow/requirements.txt
```

4. Now run below python code to upload the model to mlflow instance
```python
python mlflow/upload_model.py
```
