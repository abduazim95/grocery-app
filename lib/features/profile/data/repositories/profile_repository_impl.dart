import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery/core/providers/core_providers.dart';
import 'package:grocery/features/profile/data/data_sources/profile_remote_ds.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository_impl.g.dart';

@riverpod
ProfileRemoteDs profileRepository(Ref ref) {
  final client = ref.watch(dioClientProvider);
  return ProfileRemoteDs(client);
}
