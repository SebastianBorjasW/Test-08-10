# author: Renato García Morán
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.doctor import Doctor, DoctorCreate
from schemas.login import Login
from utils import auth_doc
from config.config import Config

auth = APIRouter()

# Crear una cuenta
@auth.post('/signup', response_model=Doctor)
def signup(doctor_create: DoctorCreate, db: Session = Depends(Config.get_db)):
    """Crea una cuenta."""
    return auth_doc.signup(db, doctor_create)

# Iniciar sesión
@auth.post('/signin', response_model=Doctor)
def signin(login_request: Login, db: Session = Depends(Config.get_db)):
    """Inicia sesión."""
    return auth_doc.signin(db, str(login_request.email), str(login_request.password))