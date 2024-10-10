// author: Renato García Morán
import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientBase {
  final String first_name;
  final String last_name;
  final String sex;
  final DateTime dob;
  final int doctor_id;
  final String diagnosis;

  PatientBase({
    required this.first_name,
    required this.last_name,
    required this.sex,
    required this.dob,
    required this.doctor_id,
    required this.diagnosis,
  });

  factory PatientBase.fromJson(Map<String, dynamic> json) =>
      _$PatientBaseFromJson(json);
  Map<String, dynamic> toJson() => _$PatientBaseToJson(this);
}

@JsonSerializable()
class PatientCreate extends PatientBase {
  final String xray_image_path;

  PatientCreate({
    required super.first_name,
    required super.last_name,
    required super.sex,
    required super.dob,
    required super.doctor_id,
    required super.diagnosis,
    required this.xray_image_path,
  });

  factory PatientCreate.fromJson(Map<String, dynamic> json) =>
      _$PatientCreateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PatientCreateToJson(this);
}

@JsonSerializable()
class Patient extends PatientBase {
  final int id;
  final DateTime registered_at;

  Patient({
    required super.first_name,
    required super.last_name,
    required super.sex,
    required super.dob,
    required super.doctor_id,
    required super.diagnosis,
    required this.id,
    required this.registered_at,
  });

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
