import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/stock/data/data_sources/stock_remote_ds.dart';
import 'package:grocery/shared/models/stock_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_repository_impl.g.dart';

@riverpod
StockRemoteDs stockRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return StockRemoteDs(client);
}

@riverpod
Future<List<StockItem>> stockList(Ref ref, String storeId) =>
    ref.watch(stockRepositoryProvider).getStock(storeId);
