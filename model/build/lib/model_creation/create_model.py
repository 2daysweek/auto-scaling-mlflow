from sklearn.datasets import load_diabetes
import pickle
from sklearn.linear_model import LinearRegression
import mlflow

def train_model():
    X, y = load_diabetes(return_X_y=True, as_frame=True)
    model = LinearRegression().fit(X, y)
    return model


def store_model(model):
    with open("model.pkl", "wb") as f:
        pickle.dump(model, f)


def load_model(model_name="model.pkl"):
    with open(model_name, "rb") as f:
        return pickle.load(f)


def main():
    model = train_model()
    store_model(model)
    mlflow.sklearn.log_model(model, "model")

if __name__ == "__main__":
    main()
