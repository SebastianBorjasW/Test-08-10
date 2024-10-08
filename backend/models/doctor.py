# author: Renato García Morán
from config.config import Config
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

# Clase Doctor para la tabla doctor
class Doctor(Config.Base):
    """Modelo de la tabla Doctor."""
    __tablename__ = 'doctor' # Nombre de la tabla

    id = Column(Integer, primary_key=True, index=True) # Columna id
    first_name = Column(String(70), nullable=False) # Columna first_name
    last_name = Column(String(70), nullable=False) # Columna last_name
    email = Column(String(70), nullable=False) # Columna email
    password = Column(String(70), nullable=False) # Columna password

    # Relacion con la tabla patient
    patients = relationship('Patient', back_populates='doctor')