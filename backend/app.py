# author: Renato García Morán
from models import * # Crea las tablas en la base de datos
from predictions import * # Descarga el modelo preentrenado
from fastapi import FastAPI
from routes import doctor
from routes import patient
from routes import auth

app = FastAPI()
app.include_router(doctor.doctor, prefix='/api/doctors', tags=['Doctor'])
app.include_router(auth.auth, prefix='/api/auth/doctor', tags=['Auth'])
app.include_router(patient.patient, prefix='/api/patients', tags=['Patient'])