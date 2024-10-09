# author: Renato García Morán
from sqlalchemy.orm import Session
from fastapi import File
import models
from schemas.patient import PatientCreate
from predictions.predict_diagnosis import predict_diagnosis
import os

def register_patient(db: Session, patient_create: PatientCreate, file: File):
    """Registra un paciente en la db."""
    # Generar el nombre del archivo a partir del nombre del paciente
    file_name = f"{patient_create.first_name}_{patient_create.last_name}.jpeg"
    
    # Definir la ruta donde se guardará la imagen
    file_path = os.path.join(os.path.dirname(__file__), '..', 'photos', file_name)

    # Guardar el archivo en el sistema de archivos
    with open(file_path, "wb") as image_file:
        image_file.write(file.file.read())  # Leer los datos del archivo recibido y escribirlo en la ruta especificada

    #realizar la predicción de diagnóstico con la imagen recién guardada
    diagnosis_prediction = predict_diagnosis(file_path)
    #obtiene el valor mas grande del diccionario de prediccion
    diagnosis_prediction_max = max(diagnosis_prediction, key=diagnosis_prediction.get)
    # Crear un nuevo paciente con los datos recibidos
    patient = models.Patient(
        first_name=patient_create.first_name,
        last_name=patient_create.last_name,
        sex=patient_create.sex,
        dob=patient_create.dob,
        xray_image_path=file_path,  # Ruta de la imagen guardada
        doctor_id=patient_create.doctor_id,
        diagnosis=diagnosis_prediction_max
    )
    
    db.add(patient)
    db.commit()
    db.refresh(patient)
    
    return diagnosis_prediction