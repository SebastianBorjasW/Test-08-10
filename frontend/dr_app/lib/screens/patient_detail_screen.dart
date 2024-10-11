// author: Renato García Morán
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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

  Future<void> _downloadPatientPdf() async {
    try {
      final pdfBytes = await _apiService.getPatientPdf(widget.patient.id);
      if (pdfBytes != null) {
        final fileName =
            '${widget.patient.first_name}_${widget.patient.last_name}.pdf';
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory != null) {
          final filePath = '$selectedDirectory/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(pdfBytes);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF guardado en $filePath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La descarga fue cancelada')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al descargar el PDF')),
      );
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
            // Datos del paciente centrados
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Datos del paciente',
                      style: TextStyle(
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
                    const SizedBox(height: 24),
                    // Botón para descargar el PDF
                    ElevatedButton(
                      onPressed: _downloadPatientPdf,
                      child: const Text('Descargar PDF'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Foto del paciente
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
