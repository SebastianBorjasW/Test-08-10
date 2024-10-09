// author: Renato García Morán
import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientBase {
    final String first_name;
    final String last_name;
    final String sex;
    final String dob;
    final String doctor_id;
    final String diagnosis;
}

@JsonSerializable()
class PatientCreate extends PatientBase {
    final String xray_image_path;

    PatientCreate({required String first_name, required String last_name, required

@JsonSerializable()
class Patient extends PatientBase {
    final int id;
    final String registered_at;

    Patient({required String first_name, required String last_name, required