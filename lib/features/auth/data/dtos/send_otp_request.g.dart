// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpRequest _$SendOtpRequestFromJson(Map<String, dynamic> json) =>
    SendOtpRequest(
      phone: json['phone'] as String,
      purpose: json['purpose'] as String,
    );

Map<String, dynamic> _$SendOtpRequestToJson(SendOtpRequest instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'purpose': instance.purpose,
    };
