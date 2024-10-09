# author: Renato García Morán
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.doctor import Doctor, DoctorCreate
from utils import doctor_crud
from config.config import Config

doctor = APIRouter()

@doctor.post('/')
def create_doctor(doctor_create: DoctorCreate, db: Session = Depends(Config.get_db)):
    ok = doctor_crud.create_doctor(db, doctor_create)
    message = ''
    if ok:
        message = 'OK'
    else:
        message = 'ERROR'
    return {'message': message}

@doctor.get('/', response_model=list[Doctor])
def get_doctors(skip: int = 0, limit = 100, db: Session = Depends(Config.get_db)):
    return doctor_crud.get_doctors(db, skip=skip, limit=limit)

@doctor.get('/{doctor_id}', response_model=Doctor)
def get_doctor(doctor_id: int, db: Session = Depends(Config.get_db)):
    return doctor_crud.get_doctor(db, doctor_id)

@doctor.delete('/{doctor_id}')
def delete_doctor(doctor_id: int, db: Session = Depends(Config.get_db)):
    ok = doctor_crud.delete_doctor(db, doctor_id)
    message = ''
    if ok:
        message = 'OK'
    else:
        message = 'ERROR'
    return {'message': message}