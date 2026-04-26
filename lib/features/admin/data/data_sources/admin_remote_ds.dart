import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/user.dart';

class AdminRemoteDs {
  final DioClient _client;

  AdminRemoteDs(this._client);

  Future<User> createManager({
    required String name,
    required String phone,
    required String password,
  }) async {
    final response = await _client.post(
      Endpoints.managers,
      data: {'name': name, 'phone': phone, 'password': password},
    );
    return unwrapData(response, (d) => User.fromJson(d as Map<String, dynamic>));
  }
}
