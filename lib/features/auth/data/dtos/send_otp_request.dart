import 'package:json_annotation/json_annotation.dart';

part 'send_otp_request.g.dart';

@JsonSerializable()
class SendOtpRequest {
  final String phone;
  final String purpose;

  const SendOtpRequest({required this.phone, required this.purpose});

  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);
}
