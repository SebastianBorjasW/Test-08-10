# author: Renato García Morán
from pydantic import BaseModel, EmailStr

class DoctorBase(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr

class DoctorCreate(DoctorBase):
    password: str

class Doctor(DoctorBase):
    id: int

    class Config:
        from_attributes = True