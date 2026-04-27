import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/debts/data/data_sources/debt_remote_ds.dart';
import 'package:grocery/features/debts/domain/repositories/debt_repository.dart';
import 'package:grocery/shared/models/debt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debt_repository_impl.g.dart';

@riverpod
DebtRepository debtRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return _DebtRepositoryImpl(DebtRemoteDs(client));
}

class _DebtRepositoryImpl implements DebtRepository {
  final DebtRemoteDs _ds;

  _DebtRepositoryImpl(this._ds);

  @override
  Future<List<DebtRecord>> listDebts({String? storeId}) =>
      _ds.listDebts(storeId: storeId);

  @override
  Future<DebtRecord> getById(String id) => _ds.getById(id);

  @override
  Future<List<DebtPayment>> listDebtPayments(String id) => _ds.listDebtPayments(id);

  @override
  Future<DebtRecord> create({
    required String storeId,
    required String debtorName,
    String? debtorPhone,
    required double amount,
    String? description,
  }) =>
      _ds.create(
          storeId: storeId,
          debtorName: debtorName,
          debtorPhone: debtorPhone,
          amount: amount,
          description: description);

  @override
  Future<DebtRecord> update({
    required String id,
    required String debtorName,
    String? debtorPhone,
    String? description,
  }) =>
      _ds.update(
          id: id,
          debtorName: debtorName,
          debtorPhone: debtorPhone,
          description: description);

  @override
  Future<DebtRecord> addPayment({
    required String id,
    required double amount,
    String? note,
  }) =>
      _ds.addPayment(id: id, amount: amount, note: note);

  @override
  Future<DebtRecord> updatePayment({
    required String id,
    required String paymentId,
    required double amount,
    String? note,
  }) =>
      _ds.updatePayment(id: id, paymentId: paymentId, amount: amount, note: note);

  @override
  Future<DebtRecord> deletePayment({
    required String id,
    required String paymentId,
  }) =>
      _ds.deletePayment(id: id, paymentId: paymentId);

  @override
  Future<void> delete(String id) => _ds.delete(id);
}
