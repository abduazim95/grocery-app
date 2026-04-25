import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/stores/data/data_sources/store_remote_ds.dart';
import 'package:grocery/shared/models/store.dart';
import 'package:grocery/shared/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_repository_impl.g.dart';

@riverpod
StoreRemoteDs storeRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return StoreRemoteDs(client);
}

@riverpod
Future<List<Store>> storesList(Ref ref) =>
    ref.watch(storeRepositoryProvider).listStores();
