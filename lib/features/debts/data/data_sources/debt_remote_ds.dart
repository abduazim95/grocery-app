import 'package:grocery/core/api/api_endpoints.dart';
import 'package:grocery/core/api/dio_client.dart';
import 'package:grocery/shared/models/debt.dart';

class DebtRemoteDs {
  final DioClient _client;

  DebtRemoteDs(this._client);

  Future<List<DebtRecord>> listDebts({String? storeId}) async {
    final response = await _client.get(
      Endpoints.debts,
      queryParameters: storeId != null ? {'store_id': storeId} : {},
    );
    return unwrapList(response, (d) => DebtRecord.fromJson(d as Map<String, dynamic>));
  }

  Future<List<DebtPayment>> listDebtPayments(String id) async {
    final response = await _client.get(Endpoints.debtPayments(id));
    return unwrapList(response, (d) => DebtPayment.fromJson(d as Map<String, dynamic>));
  }

  Future<DebtRecord> getById(String id) async {
    final response = await _client.get(Endpoints.debtById(id));
    return unwrapData(response, (d) => DebtRecord.fromJson(d as Map<String, dynamic>));
  }

  Future<DebtRecord> create({
    required String storeId,
    required String debtorName,
    String? debtorPhone,
    required double amount,
    String? description,
  }) async {
    final response = await _client.post(
      Endpoints.debts,
      data: {
        'store_id': storeId,
        'debtor_name': debtorName,
        if (debtorPhone != null && debtorPhone.isNotEmpty) 'debtor_phone': debtorPhone,
        'amount': amount,
        if (description != null && description.isNotEmpty) 'description': description,
      },
    );
    return unwrapData(response, (d) => DebtRecord.fromJson(d as Map<String, dynamic>));
  }

  Future<DebtRecord> update({
    required String id,
    required String debtorName,
    String? debtorPhone,
    String? description,
  }) async {
    final response = await _client.put(
      Endpoints.debtById(id),
      data: {
        'debtor_name': debtorName,
        if (debtorPhone != null) 'debtor_phone': debtorPhone,
        if (description != null) 'description': description,
      },
    );
    return unwrapData(response, (d) => DebtRecord.fromJson(d as Map<String, dynamic>));
  }

  Future<DebtRecord> addPayment({
    required String id,
    required double amount,
    String? note,
  }) async {
    final response = await _client.post(
      Endpoints.debtPayments(id),
      data: {
        'amount': amount,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
    return unwrapData(response, (d) => DebtRecord.fromJson(d as Map<String, dynamic>));
  }

  Future<void> delete(String id) async {
    await _client.delete(Endpoints.debtById(id));
  }
}
