// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$businessesHash() => r'5d850f870bcdff4f6ba5a67213c18f983c61f351';

/// See also [businesses].
@ProviderFor(businesses)
final businessesProvider = AutoDisposeFutureProvider<List<Business>>.internal(
  businesses,
  name: r'businessesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$businessesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BusinessesRef = AutoDisposeFutureProviderRef<List<Business>>;
String _$businessDetailHash() => r'694bca4925b396083908277e23025c36aa2c312b';

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

/// See also [businessDetail].
@ProviderFor(businessDetail)
const businessDetailProvider = BusinessDetailFamily();

/// See also [businessDetail].
class BusinessDetailFamily extends Family<AsyncValue<BusinessDetail>> {
  /// See also [businessDetail].
  const BusinessDetailFamily();

  /// See also [businessDetail].
  BusinessDetailProvider call(
    String id,
  ) {
    return BusinessDetailProvider(
      id,
    );
  }

  @override
  BusinessDetailProvider getProviderOverride(
    covariant BusinessDetailProvider provider,
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
  String? get name => r'businessDetailProvider';
}

/// See also [businessDetail].
class BusinessDetailProvider extends AutoDisposeFutureProvider<BusinessDetail> {
  /// See also [businessDetail].
  BusinessDetailProvider(
    String id,
  ) : this._internal(
          (ref) => businessDetail(
            ref as BusinessDetailRef,
            id,
          ),
          from: businessDetailProvider,
          name: r'businessDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$businessDetailHash,
          dependencies: BusinessDetailFamily._dependencies,
          allTransitiveDependencies:
              BusinessDetailFamily._allTransitiveDependencies,
          id: id,
        );

  BusinessDetailProvider._internal(
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
  Override overrideWith(
    FutureOr<BusinessDetail> Function(BusinessDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BusinessDetailProvider._internal(
        (ref) => create(ref as BusinessDetailRef),
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
  AutoDisposeFutureProviderElement<BusinessDetail> createElement() {
    return _BusinessDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessDetailProvider && other.id == id;
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
mixin BusinessDetailRef on AutoDisposeFutureProviderRef<BusinessDetail> {
  /// The parameter `id` of this provider.
  String get id;
}

class _BusinessDetailProviderElement
    extends AutoDisposeFutureProviderElement<BusinessDetail>
    with BusinessDetailRef {
  _BusinessDetailProviderElement(super.provider);

  @override
  String get id => (origin as BusinessDetailProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
