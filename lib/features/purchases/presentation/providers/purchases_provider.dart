import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/purchases/data/repositories/purchase_repository_impl.dart';
import 'package:grocery/shared/models/purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchases_provider.g.dart';

class PurchasesPageData {
  final List<PurchaseOrder> purchases;
  final bool hasMore;
  final bool isLoadingMore;

  const PurchasesPageData({
    required this.purchases,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  PurchasesPageData copyWith({
    List<PurchaseOrder>? purchases,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      PurchasesPageData(
        purchases: purchases ?? this.purchases,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

@riverpod
class PurchasesList extends _$PurchasesList {
  static const _limit = 30;
  int _page = 1;

  @override
  Future<PurchasesPageData> build({String? storeId, String? status}) =>
      _fetchPage(1, reset: true);

  Future<PurchasesPageData> _fetchPage(int page, {required bool reset}) async {
    final items = await ref.read(purchaseRepositoryProvider).listPurchases(
          storeId: storeId,
          page: page,
          limit: _limit,
          status: status,
        );
    final existing =
        reset ? <PurchaseOrder>[] : (state.valueOrNull?.purchases ?? <PurchaseOrder>[]);
    return PurchasesPageData(
      purchases: [...existing, ...items],
      hasMore: items.length == _limit,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    _page++;
    final next = await AsyncValue.guard(() => _fetchPage(_page, reset: false));
    state = next.when(
      data: (d) => AsyncData(d.copyWith(isLoadingMore: false)),
      error: (e, s) {
        _page--;
        return AsyncData(current.copyWith(isLoadingMore: false));
      },
      loading: () => AsyncData(current.copyWith(isLoadingMore: false)),
    );
  }

  Future<void> refresh() async {
    _page = 1;
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class PurchaseDetail extends _$PurchaseDetail {
  @override
  Future<PurchaseOrder> build(String id) =>
      ref.watch(purchaseRepositoryProvider).getById(id);

  Future<void> markBought(String itemId, bool isBought) async {
    final order = await ref
        .read(purchaseRepositoryProvider)
        .markBought(purchaseId: id, itemId: itemId, isBought: isBought);
    state = AsyncData(order);
  }

  Future<void> deleteItem(String itemId) async {
    await ref
        .read(purchaseRepositoryProvider)
        .deleteItem(purchaseId: id, itemId: itemId);
    ref.invalidateSelf();
    await future;
  }

  Future<void> close() async {
    final order = await ref.read(purchaseRepositoryProvider).close(id);
    state = AsyncData(order);
  }

  Future<void> addItem({
    required String productId,
    required double quantity,
    required double price,
  }) async {
    await ref.read(purchaseRepositoryProvider).addItem(
          purchaseId: id,
          productId: productId,
          quantity: quantity,
          price: price,
        );
    ref.invalidateSelf();
    await future;
  }
}
