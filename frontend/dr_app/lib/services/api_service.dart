// author: Renato García Morán
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api/auth';

  Future<Doctor?> signup(DoctorCreate doctorCreate) async {
    final response = await http.post(
      Uri.parse('$baseUrl/doctor/signup'),
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
      Uri.parse('$baseUrl/doctor/signin'),
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
}