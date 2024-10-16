// author: Renato García Morán
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';
import '../models/patient_model.dart';
import 'dart:typed_data';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<Doctor?> signup(DoctorCreate doctorCreate) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/doctor/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(doctorCreate.toJson()),
    );

    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear la cuenta');
    }
  }

  Future<Doctor?> signin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/doctor/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  Future<http.Response?> registerPatient(
    String firstName,
    String lastName,
    String sex,
    DateTime dob,
    int doctorId,
    String filePath,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/patients/'));

    // Configura los campos del formulario
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['sex'] = sex;
    request.fields['dob'] = dob.toIso8601String();
    request.fields['doctor_id'] = doctorId.toString();

    // Añade el archivo (imagen) al formulario
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    // Envía la solicitud al servidor
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<List<Patient>> getPatients({int skip = 0, int limit = 100}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/patients/?skip=$skip&limit=$limit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((patient) => Patient.fromJson(patient)).toList();
    } else {
      throw Exception('Error al obtener la lista de pacientes');
    }
  }

  Future<Doctor?> getDoctor(int doctorId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/doctors/$doctorId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el doctor');
    }
  }

  Future<Doctor?> getDoctorByEmail(String doctorEmail) async {
    final response = await http.get(
      Uri.parse('$baseUrl/doctors/email/$doctorEmail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el doctor');
    }
  }

  Future<Uint8List?> getPatientPhoto(int patientId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/patients/$patientId/photo'));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error al obtener la foto del paciente');
    }
  }

  Future<Uint8List?> getPatientPdf(int patientId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/patients/$patientId/pdf'));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error al descargar el PDF del paciente');
    }
  }
}
