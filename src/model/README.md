# Running and building mlflow model


## Install dependencies
Create a virtual environment
```shell
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
python src/model/model_creation/build_model.py
```

You should now see the newly build model in the MLflow UI.
Copy the run ID from the 'experiments' tab.

```
RUN_ID="ed12e1f27bfc43c3a0e90f413c5e4d21"
mlflow models build-docker -m runs:/${RUN_ID}/sklearn-model -n example-mlflow-model:latest --enable-mlserver
```
