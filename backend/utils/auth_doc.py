# author: Renato García Morán
from sqlalchemy.orm import Session
from fastapi import HTTPException
import schemas
from utils import doctor_crud
import bcrypt

# Verificar contraseña
def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verifica la contraseña."""
    return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8')) # Verifica si la contraseña es correcta

# Crear una cuenta
def signup(db: Session, doctor_create: schemas.doctor.DoctorCreate):
    """Crea una cuenta."""
    return doctor_crud.create_doctor(db, doctor_create)

# Iniciar sesión
def signin(db: Session, email: str, password: str):
    db_doctor = doctor_crud.get_doctor_by_email(db, email) # Obtiene el doctor por su email
    if db_doctor is None:
        raise HTTPException(status_code=404, detail="Correo o contraseña incorrectos.") # Si no se encuentra el doctor, lanzar un error 404
    if not verify_password(password, db_doctor.password):
        raise HTTPException(status_code=404, detail="Correo o contraseña incorrectos.")
    return db_doctor