# author: Renato García Morán
from config.config import Config
from .doctor import Doctor
from .patient import Patient

def create_tables():
    """Crea las tablas en la base de datos."""
    Config.Base.metadata.create_all(bind=Config.engine)

create_tables()