# author: Renato García Morán
from pydantic import BaseModel
from datetime import datetime, date
from typing import Literal

class PatientBase(BaseModel):
    first_name: str
    last_name: str
    sex: Literal['M', 'F']
    dob: date
    doctor_id: int
    diagnosis: str

class PatientCreate(PatientBase):
    xray_image_path: str

class Patient(PatientBase):
    id: int
    registered_at: datetime

    class Config:
        from_attributes = True