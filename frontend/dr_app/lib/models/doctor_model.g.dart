// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorBase _$DoctorBaseFromJson(Map<String, dynamic> json) => DoctorBase(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$DoctorBaseToJson(DoctorBase instance) =>
    <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
    };

DoctorCreate _$DoctorCreateFromJson(Map<String, dynamic> json) => DoctorCreate(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$DoctorCreateToJson(DoctorCreate instance) =>
    <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'password': instance.password,
    };

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      email: json['email'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'id': instance.id,
    };
