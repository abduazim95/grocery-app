import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:grocery/shared/models/sale.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_provider.g.dart';

class SalesPageData {
  final List<Sale> sales;
  final bool hasMore;
  final bool isLoadingMore;

  const SalesPageData({
    required this.sales,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  SalesPageData copyWith({
    List<Sale>? sales,
    bool? hasMore,
    bool? isLoadingMore,
  }) =>
      SalesPageData(
        sales: sales ?? this.sales,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

@riverpod
class SalesList extends _$SalesList {
  static const _limit = 30;

  int _page = 1;
  DateTime? _from;
  DateTime? _to;

  @override
  Future<SalesPageData> build(String storeId) => _fetchPage(1, reset: true);

  Future<SalesPageData> _fetchPage(int page, {required bool reset}) async {
    final items = await ref.read(saleRepositoryProvider).listSales(
          storeId: storeId,
          page: page,
          limit: _limit,
          from: _from,
          to: _to,
        );
    final existing = reset ? <Sale>[] : (state.valueOrNull?.sales ?? <Sale>[]);
    return SalesPageData(
      sales: [...existing, ...items],
      hasMore: items.length == _limit,
    );
  }

  Future<void> applyFilter({DateTime? from, DateTime? to}) async {
    _from = from;
    _to = to;
    _page = 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(1, reset: true));
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
Future<Sale> saleDetail(Ref ref, String id) =>
    ref.watch(saleRepositoryProvider).getSaleById(id);
