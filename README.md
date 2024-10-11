# Description
This project is a technical test that involves developing a deep learning model using transfer learning to classify at least three different labels of images. This model was trained with the pre-trained MobileNetV2 model and the COVID-19 Image Dataset from Kaggle, which contains 317 chest X-ray images. The labels are three: COVID, Normal, and Viral Pneumonia.  

The model was trained and tested with an accuracy of 0.93, but this does not mean it is ready for real-world scenarios. There are several improvements that can be made, such as better data augmentation, model selection, and hyperparameter tuning. However, it is a good starting point because it is a simple model created with a very small dataset.  

This dataset was chosen to avoid the typical datasets of flowers, animals, or fruits and to create something different, such as a hospital dashboard in this case.  

# Technologies
This project utilizes several technologies to build a robust application, including:  
- **TensorFlow**: An open-source library for machine learning and deep learning, used in this project for image classification tasks.  
- **FastAPI**: A modern, fast web framework for building APIs with Python 3.7+ based on standard Python type hints.  
- **SQLAlchemy**: A SQL toolkit and Object-Relational Mapping (ORM) system for Python, used to interact with the MySQL database.
- **Flutter**: An open-source UI software development toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.  

# Resources
- Google Colab notebook: [Open in Colab](https://colab.research.google.com/drive/1b1znwsnHKBp-T1GSe54Rxl1l176xhSV3?usp=sharing)  
- Pre-trained model used: [MobileNetV2](https://www.kaggle.com/models/google/mobilenet-v2)  
- Dataset used: [COVID-19 Image Dataset](https://www.kaggle.com/datasets/pranavraikokte/covid19-image-dataset)

# Setup Project
## Requirements
* Python3.10  
* python3-dev  
* python3-venv  
* mysql-server  
* libmysqlclient-dev  

## Steps  
### Run the server  
1. Clone the repository:  
``` bash
git clone https://github.com/SebastianBorjasW/Test-08-10.git
```

2. Change into the directory:
```
cd Test-08-10
```

3. Create a Python virtual environment:
``` bash
python3 -m venv .venv
```

4. Activate the virtual environment:
``` bash
source .venv/bin/activate
```

5. Install the packages:  
``` bash
pip install -r requirements.txt
```

6. Create a database  
``` bash
sudo service mysql start
mysql -u User -p
CREATE DATABASE pruebatecnica;
exit
```

7. Create .env file with the database information
``` bash
echo "DATABASE_URL=mysql+pymysql://User:Password@localhost:3306/pruebatecnica" > .env
```

8. Change to super user
``` bash
sudo su
```

9. Change into /backend
``` bash
cd backend
```

10. Run the server
```
fastapi run app.py
```

# Run the app
## Requirements
- **Flutter SDK**: You can download it from [flutter.dev](https://flutter.dev/docs/get-started/install).
### Compile the desktop app
1. **Clone the repository** (if not already done)
``` bash
git clone https://github.com/SebastianBorjasW/Test-08-10.git
```

2. **Change to the Flutter project directory**
``` bash
cd Test-08-10/frontend/dr_app
```

3. **Install Flutter dependencies**:
``` bash
flutter pub get
```

4. **Verify the development environment setup**:
``` bash
flutter doctor
```
Make sure all items are marked as correct.

5. **Enable desktop support** (if not already enabled):
``` bash
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

6. **Compile the application for desktop**:
- For Windows:
``` bash
flutter build windows
```
- For macOS:
``` bash
flutter build macos
```
- For Linux:
``` bash
flutter build linux
```
The compiled files will be located in the `build/<platform>` folder.


# Use
## Create an account using the 'Crear cuenta' button. 
![Login](docs/images/login.png)

## Fill in the fields.  
![Signup](docs/images/signup.png)

## Dashboard
![Dashboard](docs/images/dashboard.png)

### a) Filter patients by their diagnosis
![Filter](docs/images/filter.png)
### b) Click on a patient to view details or download a PDF with the information
![Patient](docs/images/patient.png)

## Register a new patient
![NewPatient](docs/images/new_patient.png)
