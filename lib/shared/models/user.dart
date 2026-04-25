import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  @JsonValue('super_admin')
  superAdmin,
  @JsonValue('manager')
  manager,
  @JsonValue('seller')
  seller,
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String phone,
    required UserRole role,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'business_id') String? businessId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  const User._();

  bool get isManager => role == UserRole.manager;
  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isSeller => role == UserRole.seller;

  String get roleLabel => switch (role) {
        UserRole.superAdmin => 'Администратор',
        UserRole.manager => 'Руководитель',
        UserRole.seller => 'Продавец',
      };
}
