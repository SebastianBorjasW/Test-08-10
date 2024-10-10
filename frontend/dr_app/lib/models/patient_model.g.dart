// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientBase _$PatientBaseFromJson(Map<String, dynamic> json) => PatientBase(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      sex: json['sex'] as String,
      dob: DateTime.parse(json['dob'] as String),
      doctor_id: (json['doctor_id'] as num).toInt(),
      diagnosis: json['diagnosis'] as String,
    );

Map<String, dynamic> _$PatientBaseToJson(PatientBase instance) =>
    <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'sex': instance.sex,
      'dob': instance.dob.toIso8601String(),
      'doctor_id': instance.doctor_id,
      'diagnosis': instance.diagnosis,
    };

PatientCreate _$PatientCreateFromJson(Map<String, dynamic> json) =>
    PatientCreate(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      sex: json['sex'] as String,
      dob: DateTime.parse(json['dob'] as String),
      doctor_id: (json['doctor_id'] as num).toInt(),
      diagnosis: json['diagnosis'] as String,
      xray_image_path: json['xray_image_path'] as String,
    );

Map<String, dynamic> _$PatientCreateToJson(PatientCreate instance) =>
    <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'sex': instance.sex,
      'dob': instance.dob.toIso8601String(),
      'doctor_id': instance.doctor_id,
      'diagnosis': instance.diagnosis,
      'xray_image_path': instance.xray_image_path,
    };

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      sex: json['sex'] as String,
      dob: DateTime.parse(json['dob'] as String),
      doctor_id: (json['doctor_id'] as num).toInt(),
      diagnosis: json['diagnosis'] as String,
      id: (json['id'] as num).toInt(),
      registered_at: DateTime.parse(json['registered_at'] as String),
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'sex': instance.sex,
      'dob': instance.dob.toIso8601String(),
      'doctor_id': instance.doctor_id,
      'diagnosis': instance.diagnosis,
      'id': instance.id,
      'registered_at': instance.registered_at.toIso8601String(),
    };
