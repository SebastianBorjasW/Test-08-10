import tensorflow_hub as hub
import tf_keras as tfk 

def load_model():
    try:
        # Cargar el modelo
        model = tfk.models.load_model('predictions/model.keras', custom_objects={'KerasLayer': hub.KerasLayer})
        print("Modelo cargado exitosamente.")
        return model
    except IOError as e:
        print(f"Error al cargar el modelo: {e}")
        return None
model = load_model()