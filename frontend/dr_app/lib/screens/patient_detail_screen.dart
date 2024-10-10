// author: Renato García Morán
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/api_service.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late Future<String> _doctorNameFuture;
  late Future<Uint8List?> _patientPhotoFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _doctorNameFuture = _getDoctorName(widget.patient.doctor_id);
    _patientPhotoFuture = _getPatientPhoto(widget.patient.id);
  }

  Future<String> _getDoctorName(int doctorId) async {
    try {
      final doctor = await _apiService.getDoctor(doctorId);
      return doctor?.first_name ?? 'Desconocido';
    } catch (e) {
      return 'Error al obtener el nombre del doctor';
    }
  }

  Future<Uint8List?> _getPatientPhoto(int patientId) async {
    try {
      return await _apiService.getPatientPhoto(patientId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.patient.first_name} ${widget.patient.last_name}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // datos del paciente centrados
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Datos del paciente',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Nombre: ${widget.patient.first_name}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Apellido: ${widget.patient.last_name}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sexo: ${widget.patient.sex}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Fecha de Nacimiento: ${widget.patient.dob.toIso8601String().substring(0, 10)}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Diagnóstico: ${widget.patient.diagnosis}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<String>(
                      future: _doctorNameFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Cargando doctor...',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          );
                        } else {
                          return Text(
                            'Doctor: ${snapshot.data}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // foto del paciente
            Expanded(
              flex: 1,
              child: FutureBuilder<Uint8List?>(
                future: _patientPhotoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Center(
                      child: Text(
                        'No se pudo cargar la foto',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    );
                  } else {
                    return Image.memory(
                      snapshot.data!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
