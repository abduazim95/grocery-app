import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/features/admin/data/dtos/business_detail.dart';
import 'package:grocery/shared/models/business.dart';
import 'package:grocery/shared/models/user.dart';

class AdminRemoteDs {
  final DioClient _client;

  AdminRemoteDs(this._client);

  Future<List<Business>> getBusinesses() async {
    final res = await _client.get(Endpoints.businesses);
    return unwrapList(res, (d) => Business.fromJson(d as Map<String, dynamic>));
  }

  Future<BusinessDetail> getBusinessDetail(String id) async {
    final res = await _client.get(Endpoints.businessById(id));
    return unwrapData(res, (d) => BusinessDetail.fromJson(d as Map<String, dynamic>));
  }

  Future<Business> createBusiness(String name) async {
    final res = await _client.post(Endpoints.businesses, data: {'name': name});
    return unwrapData(res, (d) => Business.fromJson(d as Map<String, dynamic>));
  }

  Future<User> createManager({
    required String businessId,
    required String name,
    required String phone,
    required String password,
  }) async {
    final res = await _client.post(
      Endpoints.managers,
      data: {
        'business_id': businessId,
        'name': name,
        'phone': phone,
        'password': password,
      },
    );
    return unwrapData(res, (d) => User.fromJson(d as Map<String, dynamic>));
  }
}
