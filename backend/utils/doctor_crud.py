# author: Renato García Morán
from sqlalchemy.orm import Session
from fastapi import HTTPException
import models
import schemas
import bcrypt

def hash_password(password: str) -> str:
    """Hashea la contraseña."""
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

# Obtener doctores
def get_doctors(db: Session, skip: int = 0, limit: int = 100):
    """Obtiene todos los doctores en la db."""
    return db.query(models.Doctor).offset(skip).limit(limit).all()

# Crea un doctor
def create_doctor(db: Session, doctor_create: schemas.doctor.DoctorCreate):
    """Crea un doctor en la db."""

    hashed_password = hash_password(doctor_create.password)

    doctor = models.Doctor(
        first_name=doctor_create.first_name,
        last_name=doctor_create.last_name,
        email=doctor_create.email,
        password=hashed_password
    )

    if get_doctor_by_email(db, doctor_create.email):
        raise HTTPException(status_code=400, detail="El email ya está registrado.")

    db.add(doctor)
    db.commit()
    db.refresh(doctor)
    return True
    
def get_doctor_by_email(db: Session, email: str):
    """Obtiene un doctor por su email."""
    return db.query(models.Doctor).filter(models.Doctor.email == email).first()

def delete_doctor(db: Session, doctor_id: int):
    """Elimina un doctor por su id."""
    doctor = db.query(models.Doctor).filter(models.Doctor.id == doctor_id).first()
    if doctor is None:
        raise HTTPException(status_code=404, detail="Doctor no encontrado.")
    db.delete(doctor)
    db.commit()
    return True