# author: Renato García Morán
import os
import kagglehub
from .load_model import model

MODEL_PATH = os.path.expanduser('/root/.cache/kagglehub/models/google/mobilenet-v2/tensorFlow2/100-224-feature-vector')

def download_model_if_not_exists():
    if not os.path.exists(MODEL_PATH):
        print("Descargando el modelo preentrenado mobilenet...")
        kagglehub.model_download("google/mobilenet-v2/tensorFlow2/100-224-feature-vector")
    else:
        print("El modelo preentrenado mobilenet ya está descargado.")

download_model_if_not_exists()