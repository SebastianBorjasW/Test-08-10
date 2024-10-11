// author: Renato García Morán
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  String? firstName;
  String? lastName;
  String? sex;
  DateTime? dob;
  File? file;

  Map<String, dynamic>? diagnosisPrediction;

  @override
  void initState() {
    super.initState();
    _getDoctorId();
  }

  int? doctorId;
  Future<void> _getDoctorId() async {
    final email = Provider.of<AppState>(context, listen: false).email;

    try {
      final doctor = await apiService.getDoctorByEmail(email);
      setState(() {
        doctorId = doctor?.id;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener el ID del doctor')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerPatient() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (doctorId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El ID del doctor no está disponible')),
        );
        return;
      }

      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una imagen')),
        );
        return;
      }

      try {
        final http.Response? response = await apiService.registerPatient(
          firstName!,
          lastName!,
          sex!,
          dob!,
          doctorId!,
          file!.path,
        );

        if (response != null && response.body.isNotEmpty) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          setState(() {
            diagnosisPrediction = responseData;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Paciente registrado exitosamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error en la respuesta del servidor')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar el paciente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<AppState>(context).email;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de pacientes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const DashboardScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: const Text(
              'Pacientes',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'Registrar Paciente',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Parte izquierda - Muestra los valores de predicción
          Expanded(
            child: Container(
              color: Colors.grey[800],
              child: Center(
                child: diagnosisPrediction == null
                    ? const Text(
                        'Predicción de diagnóstico.',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Predicciones',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...diagnosisPrediction!.entries.map((entry) {
                            return Text(
                              '${entry.key}: ${(entry.value * 100).toStringAsFixed(2)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
              ),
            ),
          ),
          // Parte derecha - Formulario de registro
          Expanded(
            child: Container(
              color: Colors.grey[850],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Campo requerido' : null,
                        onSaved: (value) => firstName = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Apellido',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Campo requerido' : null,
                        onSaved: (value) => lastName = value,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sexo',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                    textTheme: TextTheme(
                                        bodyMedium:
                                            TextStyle(color: Colors.white)),
                                  ),
                                  child: RadioListTile<String>(
                                    title: const Text('M',
                                        style: TextStyle(color: Colors.white)),
                                    value: 'M',
                                    groupValue: sex,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      sex = value;
                                      (context as Element).markNeedsBuild();
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white,
                                    textTheme: TextTheme(
                                        bodyMedium:
                                            TextStyle(color: Colors.white)),
                                  ),
                                  child: RadioListTile<String>(
                                    title: const Text('F',
                                        style: TextStyle(color: Colors.white)),
                                    value: 'F',
                                    groupValue: sex,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      sex = value;
                                      (context as Element).markNeedsBuild();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dob = pickedDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: dob == null
                                  ? 'Fecha de Nacimiento'
                                  : 'Fecha de Nacimiento: ${dob!.day}-${dob!.month}-${dob!.year}',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) =>
                                dob == null ? 'Campo requerido' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text(file == null
                            ? 'Seleccionar Imagen'
                            : 'Imagen Seleccionada'),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _registerPatient,
                        child: const Text('Registrar Paciente'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
