import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String phone;
  final String otp;
  final String name;
  final String password;

  const RegisterRequest({
    required this.phone,
    required this.otp,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
