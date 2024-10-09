# author: Renato García Morán
from fastapi import APIRouter, Depends, File, UploadFile, Form
from sqlalchemy.orm import Session
from utils import patient_crud
from config.config import Config
from schemas.patient import Patient, PatientCreate
import os
from datetime import date

patient = APIRouter()

@patient.post('/')
def register_patient(
    first_name: str = Form(...),
    last_name: str = Form(...),
    sex: str = Form(...),
    dob: date = Form(...),
    doctor_id: int = Form(...),
    diagnosis: str = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(Config.get_db)
):
    patient_create = PatientCreate(
        first_name=first_name,
        last_name=last_name,
        sex=sex,
        dob=dob,
        xray_image_path='',  # El path de la imagen lo asignamos después
        doctor_id=doctor_id,
        diagnosis=diagnosis
    )
    
    # Pasar los datos a la función del CRUD
    return patient_crud.register_patient(db, patient_create, file)

# @patient.get('/')
# def get_doctors():
#     ruta_imagen = os.path.join(os.path.dirname(__file__), '..', '..', 'Covid19-dataset/test/Covid/0100.jpeg')

#     return predict_diagnosis(ruta_imagen)