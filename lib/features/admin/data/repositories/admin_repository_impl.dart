import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/admin/data/data_sources/admin_remote_ds.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_repository_impl.g.dart';

@riverpod
AdminRemoteDs adminRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return AdminRemoteDs(client);
}
