import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request.g.dart';

@JsonSerializable()
class ResetPasswordRequest {
  final String phone;
  final String otp;
  @JsonKey(name: 'new_password')
  final String newPassword;

  const ResetPasswordRequest({
    required this.phone,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
