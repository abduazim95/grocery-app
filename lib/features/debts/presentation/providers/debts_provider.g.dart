// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$debtsListHash() => r'ed536e853b5ea4cf74e11a8036492162324d0bea';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DebtsList
    extends BuildlessAutoDisposeAsyncNotifier<List<DebtRecord>> {
  late final String? storeId;

  FutureOr<List<DebtRecord>> build({
    String? storeId,
  });
}

/// See also [DebtsList].
@ProviderFor(DebtsList)
const debtsListProvider = DebtsListFamily();

/// See also [DebtsList].
class DebtsListFamily extends Family<AsyncValue<List<DebtRecord>>> {
  /// See also [DebtsList].
  const DebtsListFamily();

  /// See also [DebtsList].
  DebtsListProvider call({
    String? storeId,
  }) {
    return DebtsListProvider(
      storeId: storeId,
    );
  }

  @override
  DebtsListProvider getProviderOverride(
    covariant DebtsListProvider provider,
  ) {
    return call(
      storeId: provider.storeId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'debtsListProvider';
}

/// See also [DebtsList].
class DebtsListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DebtsList, List<DebtRecord>> {
  /// See also [DebtsList].
  DebtsListProvider({
    String? storeId,
  }) : this._internal(
          () => DebtsList()..storeId = storeId,
          from: debtsListProvider,
          name: r'debtsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$debtsListHash,
          dependencies: DebtsListFamily._dependencies,
          allTransitiveDependencies: DebtsListFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  DebtsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
  }) : super.internal();

  final String? storeId;

  @override
  FutureOr<List<DebtRecord>> runNotifierBuild(
    covariant DebtsList notifier,
  ) {
    return notifier.build(
      storeId: storeId,
    );
  }

  @override
  Override overrideWith(DebtsList Function() create) {
    return ProviderOverride(
      origin: this,
      override: DebtsListProvider._internal(
        () => create()..storeId = storeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeId: storeId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DebtsList, List<DebtRecord>>
      createElement() {
    return _DebtsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DebtsListProvider && other.storeId == storeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DebtsListRef on AutoDisposeAsyncNotifierProviderRef<List<DebtRecord>> {
  /// The parameter `storeId` of this provider.
  String? get storeId;
}

class _DebtsListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DebtsList, List<DebtRecord>>
    with DebtsListRef {
  _DebtsListProviderElement(super.provider);

  @override
  String? get storeId => (origin as DebtsListProvider).storeId;
}

String _$debtDetailNotifierHash() =>
    r'871f8974dd7821826d6bf258923d0722047c1936';

abstract class _$DebtDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<DebtRecord> {
  late final String id;

  FutureOr<DebtRecord> build(
    String id,
  );
}

/// See also [DebtDetailNotifier].
@ProviderFor(DebtDetailNotifier)
const debtDetailNotifierProvider = DebtDetailNotifierFamily();

/// See also [DebtDetailNotifier].
class DebtDetailNotifierFamily extends Family<AsyncValue<DebtRecord>> {
  /// See also [DebtDetailNotifier].
  const DebtDetailNotifierFamily();

  /// See also [DebtDetailNotifier].
  DebtDetailNotifierProvider call(
    String id,
  ) {
    return DebtDetailNotifierProvider(
      id,
    );
  }

  @override
  DebtDetailNotifierProvider getProviderOverride(
    covariant DebtDetailNotifierProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'debtDetailNotifierProvider';
}

/// See also [DebtDetailNotifier].
class DebtDetailNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    DebtDetailNotifier, DebtRecord> {
  /// See also [DebtDetailNotifier].
  DebtDetailNotifierProvider(
    String id,
  ) : this._internal(
          () => DebtDetailNotifier()..id = id,
          from: debtDetailNotifierProvider,
          name: r'debtDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$debtDetailNotifierHash,
          dependencies: DebtDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              DebtDetailNotifierFamily._allTransitiveDependencies,
          id: id,
        );

  DebtDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  FutureOr<DebtRecord> runNotifierBuild(
    covariant DebtDetailNotifier notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(DebtDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DebtDetailNotifierProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DebtDetailNotifier, DebtRecord>
      createElement() {
    return _DebtDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DebtDetailNotifierProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DebtDetailNotifierRef on AutoDisposeAsyncNotifierProviderRef<DebtRecord> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DebtDetailNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DebtDetailNotifier,
        DebtRecord> with DebtDetailNotifierRef {
  _DebtDetailNotifierProviderElement(super.provider);

  @override
  String get id => (origin as DebtDetailNotifierProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
