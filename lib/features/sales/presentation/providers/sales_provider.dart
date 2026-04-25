import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/features/sales/data/repositories/sale_repository_impl.dart';
import 'package:grocery/shared/models/sale.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_provider.g.dart';

@riverpod
Future<List<Sale>> salesList(Ref ref, String storeId) =>
    ref.watch(saleRepositoryProvider).listSales(storeId: storeId);
