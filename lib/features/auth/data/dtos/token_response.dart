import 'package:grocery/shared/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';

@JsonSerializable()
class TokenResponse {
  final String token;
  final User user;

  const TokenResponse({required this.token, required this.user});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}
