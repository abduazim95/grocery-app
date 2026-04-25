import 'package:grocery/shared/models/debt.dart';

abstract interface class DebtRepository {
  Future<List<DebtRecord>> listDebts({String? storeId});
  Future<DebtRecord> getById(String id);
  Future<DebtRecord> create({
    required String storeId,
    required String debtorName,
    String? debtorPhone,
    required double amount,
    String? description,
  });
  Future<DebtRecord> update({
    required String id,
    required String debtorName,
    String? debtorPhone,
    String? description,
  });
  Future<List<DebtPayment>> listDebtPayments(String id);
  Future<DebtRecord> addPayment({
    required String id,
    required double amount,
    String? note,
  });
  Future<void> delete(String id);
}
