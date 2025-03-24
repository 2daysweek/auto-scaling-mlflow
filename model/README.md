# Running and building mlflow model


## Install dependencies
Create a virtual environment
```
cd model/
python -m venv test_env
. test_env/bin/activate
```

```shell
pip install .
```


## Run MLflow UI

```shell
mlflow ui --port 5000
```

## Build model
```shell
python src/model_creation/build_model.py
```

You should now see the newly build model in the MLflow UI.
Copy the run ID from the 'experiments' tab.

```
Run the following command; abundant-flea-87 
RUN_ID="1797864b1837479f92023e7ca0964ae9"
mlflow models build-docker -m runs:/${RUN_ID}/sklearn-model -n example-mlflow-model:latest --enable-mlserver


```