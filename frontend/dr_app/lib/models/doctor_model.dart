// author: Renato García Morán
import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorBase {
  final String first_name;
  final String last_name;
  final String email;

  DoctorBase(
      {required this.first_name, required this.last_name, required this.email});

  factory DoctorBase.fromJson(Map<String, dynamic> json) =>
      _$DoctorBaseFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorBaseToJson(this);
}

@JsonSerializable()
class DoctorCreate extends DoctorBase {
  final String password;

  DoctorCreate(
      {required super.first_name,
      required super.last_name,
      required super.email,
      required this.password});

  factory DoctorCreate.fromJson(Map<String, dynamic> json) =>
      _$DoctorCreateFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DoctorCreateToJson(this);
}

@JsonSerializable()
class Doctor extends DoctorBase {
  final int id;

  Doctor(
      {required super.first_name,
      required super.last_name,
      required super.email,
      required this.id});

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
