# author: Renato García Morán
from sqlalchemy.orm import Session
from fastapi import HTTPException
import models
import schemas
import bcrypt

# Hashear contraseña
def hash_password(password: str) -> str:
    """Hashea la contraseña."""
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8') # Hashea la contraseña y la convierte a string

# Obtener doctores
def get_doctors(db: Session, skip: int = 0, limit: int = 100):
    """Obtiene todos los doctores en la db."""
    return db.query(models.Doctor).offset(skip).limit(limit).all() # Obtiene todos los doctores en la db

# Crea un doctor
def create_doctor(db: Session, doctor_create: schemas.doctor.DoctorCreate):
    """Crea un doctor en la db."""
    
    if get_doctor_by_email(db, doctor_create.email): # Si ya existe un doctor con el email especificado lanzar un error
        raise HTTPException(status_code=400, detail="El email ya está registrado.")

    hashed_password = hash_password(doctor_create.password) # Hashea la contraseña

    doctor = models.Doctor(
        first_name=doctor_create.first_name,
        last_name=doctor_create.last_name,
        email=doctor_create.email,
        password=hashed_password # Guarda la contraseña hasheada
    )

    db.add(doctor)
    db.commit()
    db.refresh(doctor) # Actualiza la tabla de doctores
    return doctor
    
# Obtiene un doctor por su email
def get_doctor_by_email(db: Session, email: str):
    """Obtiene un doctor por su email."""
    return db.query(models.Doctor).filter(models.Doctor.email == email).first() # Obtiene el primer doctor con el email especificado

# Elimina un doctor por su id
def delete_doctor(db: Session, doctor_id: int):
    """Elimina un doctor por su id."""
    doctor = get_doctor(db, doctor_id) # Obtiene el doctor por su id
    if doctor is None:
        raise HTTPException(status_code=404, detail="Doctor no encontrado.") # Si no se encuentra el doctor, lanzar un error 404
    db.delete(doctor)
    db.commit() # Elimina el doctor de la db
    return True

# Obtiene un doctor por su id
def get_doctor(db: Session, doctor_id: int):
    """Obtiene un doctor por su id."""
    doctor = db.query(models.Doctor).filter(models.Doctor.id == doctor_id).first() # Obtiene el primer doctor con el id especificado
    if doctor is None:
        raise HTTPException(status_code=404, detail="Doctor no encontrado.") # Si no se encuentra el doctor, lanzar un error 404
    return doctor