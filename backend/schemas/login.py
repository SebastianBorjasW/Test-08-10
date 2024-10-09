# author: Renato García Morán
from pydantic import BaseModel

class Login(BaseModel):
    email: str
    password: str