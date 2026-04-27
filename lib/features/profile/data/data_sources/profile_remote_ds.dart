import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/user.dart';

class ProfileRemoteDs {
  final DioClient _client;

  ProfileRemoteDs(this._client);

  Future<User> updateName(String name) async {
    final response = await _client.put(
      Endpoints.profile,
      data: {'name': name},
    );
    return unwrapData(response, (d) => User.fromJson(d as Map<String, dynamic>));
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _client.put(
      Endpoints.profilePassword,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
  }
}
