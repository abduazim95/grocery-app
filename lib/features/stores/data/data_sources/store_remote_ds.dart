import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/store.dart';
import 'package:grocery/shared/models/user.dart';

class StoreRemoteDs {
  final DioClient _client;

  StoreRemoteDs(this._client);

  Future<List<Store>> listStores() async {
    final response = await _client.dio.get(Endpoints.stores);
    return unwrapList(response, (d) => Store.fromJson(d as Map<String, dynamic>));
  }

  Future<Store> create({required String name, String? address}) async {
    final response = await _client.dio.post(
      Endpoints.stores,
      data: {'name': name, if (address != null && address.isNotEmpty) 'address': address},
    );
    return unwrapData(response, (d) => Store.fromJson(d as Map<String, dynamic>));
  }

  Future<User> addSeller({
    required String storeId,
    required String name,
    required String phone,
    required String password,
  }) async {
    final response = await _client.dio.post(
      Endpoints.storeSellers(storeId),
      data: {'name': name, 'phone': phone, 'password': password},
    );
    return unwrapData(response, (d) => User.fromJson(d as Map<String, dynamic>));
  }
}
