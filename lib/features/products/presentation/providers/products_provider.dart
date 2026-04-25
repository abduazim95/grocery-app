import 'package:grocery/features/products/data/repositories/product_repository_impl.dart';
import 'package:grocery/features/products/data/dtos/product_list_result.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_provider.g.dart';

@riverpod
class ProductsListNotifier extends _$ProductsListNotifier {
  int _page = 1;
  bool _hasMore = true;
  List<Product> _items = [];

  @override
  Future<ProductListState> build(String businessId, {String query = ''}) async {
    _page = 1;
    _items = [];
    _hasMore = true;
    return _load(businessId, query);
  }

  Future<ProductListState> _load(String businessId, String query) async {
    final result = await ref
        .read(productRepositoryProvider)
        .listProducts(businessId: businessId, query: query, page: _page);
    _items = [..._items, ...result.products];
    _hasMore = _items.length < result.total;
    return ProductListState(items: _items, hasMore: _hasMore);
  }

  Future<void> loadMore(String businessId, {String query = ''}) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    _page++;
    final prev = _items;
    try {
      state = AsyncData(await _load(businessId, query));
    } catch (_) {
      _items = prev;
      _page--;
    }
  }

  Future<void> refresh(String businessId, {String query = ''}) async {
    ref.invalidateSelf();
    await future;
  }
}

class ProductListState {
  final List<Product> items;
  final bool hasMore;

  const ProductListState({required this.items, required this.hasMore});
}
