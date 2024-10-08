# author: Renato García Morán
from config.config import Config
from sqlalchemy import Column, Integer, String, Date, TIMESTAMP, ForeignKey, func
from sqlalchemy.orm import relationship

# Clase Patient para la tabla patient
class Patient(Config.Base):
    """Modelo de la tabla Patient."""
    __tablename__ = 'patient' # Nombre de la tabla

    id = Column(Integer, primary_key=True, index=True) # Columna id
    first_name = Column(String(70), nullable=False) # Columna first_name
    last_name = Column(String(70), nullable=False) # Columna last_name
    diagnosis = Column(String(20), nullable=False) # Columna diagnosis
    sex = Column(String(1), nullable=False) # Columna sex
    dob = Column(Date, nullable=False) # Columna date of birth
    xray_image_path = Column(String(150), nullable=False) # Columna xray_image_path
    registered_at = Column(TIMESTAMP, server_default=func.current_timestamp(), nullable=False) # Columna created_at

    # Relacion con la tabla doctor
    doctor_id = Column(Integer, ForeignKey('doctor.id'), nullable=False) # Columna doctor_id
    doctor = relationship('Doctor', back_populates='patients')  # Definición de relación