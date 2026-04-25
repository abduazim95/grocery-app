// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secureStorageHash() => r'10668ae3fad0db245a71eb708b471853edadede6';

/// See also [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider = Provider<SecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = ProviderRef<SecureStorage>;
String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$dioClientHash() => r'c8a55e1b6ebba4e7f9c858f3bb59a4690a528704';

/// See also [dioClient].
@ProviderFor(dioClient)
final dioClientProvider = Provider<DioClient>.internal(
  dioClient,
  name: r'dioClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioClientRef = ProviderRef<DioClient>;
String _$serverConfigHash() => r'9b492e67f6dd82d0aafc790e434e4fd999f199cf';

/// See also [ServerConfig].
@ProviderFor(ServerConfig)
final serverConfigProvider =
    AsyncNotifierProvider<ServerConfig, String?>.internal(
  ServerConfig.new,
  name: r'serverConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$serverConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServerConfig = AsyncNotifier<String?>;
String _$authStateHash() => r'd96b6f1f418eae17350f31b47b6d654efc669c82';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider = AsyncNotifierProvider<AuthState, User?>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = AsyncNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
