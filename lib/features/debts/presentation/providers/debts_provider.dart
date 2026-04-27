import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/debts/data/repositories/debt_repository_impl.dart';
import 'package:grocery/shared/models/debt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debts_provider.g.dart';

@riverpod
class DebtsList extends _$DebtsList {
  @override
  Future<List<DebtRecord>> build({String? storeId}) =>
      ref.watch(debtRepositoryProvider).listDebts(storeId: storeId);

  Future<void> createDebt({
    required String storeId,
    required String debtorName,
    String? debtorPhone,
    required double amount,
    String? description,
  }) async {
    await ref.read(debtRepositoryProvider).create(
          storeId: storeId,
          debtorName: debtorName,
          debtorPhone: debtorPhone,
          amount: amount,
          description: description,
        );
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class DebtDetailNotifier extends _$DebtDetailNotifier {
  @override
  Future<DebtRecord> build(String id) =>
      ref.watch(debtRepositoryProvider).getById(id);

  Future<void> addPayment(double amount, {String? note}) async {
    final record =
        await ref.read(debtRepositoryProvider).addPayment(id: id, amount: amount, note: note);
    state = AsyncData(record);
    ref.invalidate(debtsListProvider());
  }

  Future<void> updatePayment(String paymentId, double amount, {String? note}) async {
    final record = await ref.read(debtRepositoryProvider).updatePayment(
          id: id,
          paymentId: paymentId,
          amount: amount,
          note: note,
        );
    state = AsyncData(record);
    ref.invalidate(debtsListProvider());
  }

  Future<void> deletePayment(String paymentId) async {
    final record = await ref
        .read(debtRepositoryProvider)
        .deletePayment(id: id, paymentId: paymentId);
    state = AsyncData(record);
    ref.invalidate(debtsListProvider());
  }

  Future<void> editDebt({
    required String debtorName,
    String? debtorPhone,
    String? description,
  }) async {
    final record = await ref.read(debtRepositoryProvider).update(
          id: id,
          debtorName: debtorName,
          debtorPhone: debtorPhone,
          description: description,
        );
    state = AsyncData(record);
    ref.invalidate(debtsListProvider());
  }

  Future<void> delete() async {
    await ref.read(debtRepositoryProvider).delete(id);
    ref.invalidate(debtsListProvider());
  }
}
