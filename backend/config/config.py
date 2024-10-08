# author: Renato García Morán
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

dotenv = os.path.join(os.path.dirname(__file__), '..', '..','.env')
load_dotenv(dotenv)

class Config:
    """Configuracion basica para el funcionamiento de la api."""
    # URL de la base de datos con datos de la conexion
    DATABASE_URL = os.getenv('DATABASE_URL')

    if DATABASE_URL is None:
        raise ValueError('DATABASE_URL no se ha definido en el archivo .env')
    
    engine = create_engine(DATABASE_URL)

    sessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

    Base = declarative_base()

    @classmethod
    def get_db(cls):
        """Obtiene una sesion de la base de datos."""
        db = cls.sessionLocal()
        try:
            yield db
        finally:
            db.close()