# author: Renato García Morán
import numpy as np
import cv2
from .load_model import model

def predict_diagnosis(path):
    """Función para hacer predicciones sobre la condición de la imagen."""
    arr = []
    img = cv2.imread(path)
    
    img = cv2.resize(img, (224, 224))
    
    arr.append(img)
    arr = np.array(arr)

    pred = model.predict(arr)
    
    labels = ['Normal', 'Viral Pneumonia', 'Covid']
    res = np.squeeze(pred)

    return {labels[i]: float(res[i]) for i in range(len(labels))}