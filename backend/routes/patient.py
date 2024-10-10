# author: Renato García Morán
from fastapi import APIRouter, Depends, File, UploadFile, Form
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from utils import patient_crud
from config.config import Config
from schemas.patient import Patient, PatientCreate
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
        xray_image_path='',
        doctor_id=doctor_id,
        diagnosis=diagnosis
    )
    
    return patient_crud.register_patient(db, patient_create, file)

@patient.get('/', response_model=list[Patient])
def get_patients(skip: int = 0, limit: int = 100, db: Session = Depends(Config.get_db)):
    return patient_crud.get_patients(db, skip, limit)

@patient.get('/{patient_id}/photo')
def get_patient_photo(patient_id: int, db: Session = Depends(Config.get_db)):
    """Devuelve la foto del paciente dado su ID."""
    return patient_crud.get_patient_photo_by_id(patient_id, db)

@patient.get('/{patient_id}/pdf')
def get_patient_pdf(patient_id: int, db: Session = Depends(Config.get_db)):
    """Genera un PDF con los datos del paciente y su imagen."""
    pat = patient_crud.get_patient_by_id(db, patient_id)
    try:
        # genera el PDF
        pdf_buffer = patient_crud.generate_patient_pdf(db, patient_id)
        # devuelve el PDF como respuesta
        return StreamingResponse(pdf_buffer, media_type="application/pdf", headers={"Content-Disposition": f"attachment; filename={pat.first_name}_{pat.last_name}.pdf"})
    except ValueError as e:
        return {"error": str(e)}