// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_setup_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ServerSetupState {
  String get url => throw _privateConstructorUsedError;
  bool get isTesting => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ServerSetupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServerSetupStateCopyWith<ServerSetupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerSetupStateCopyWith<$Res> {
  factory $ServerSetupStateCopyWith(
          ServerSetupState value, $Res Function(ServerSetupState) then) =
      _$ServerSetupStateCopyWithImpl<$Res, ServerSetupState>;
  @useResult
  $Res call(
      {String url, bool isTesting, bool isVerified, String? errorMessage});
}

/// @nodoc
class _$ServerSetupStateCopyWithImpl<$Res, $Val extends ServerSetupState>
    implements $ServerSetupStateCopyWith<$Res> {
  _$ServerSetupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServerSetupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? isTesting = null,
    Object? isVerified = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      isTesting: null == isTesting
          ? _value.isTesting
          : isTesting // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerSetupStateImplCopyWith<$Res>
    implements $ServerSetupStateCopyWith<$Res> {
  factory _$$ServerSetupStateImplCopyWith(_$ServerSetupStateImpl value,
          $Res Function(_$ServerSetupStateImpl) then) =
      __$$ServerSetupStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url, bool isTesting, bool isVerified, String? errorMessage});
}

/// @nodoc
class __$$ServerSetupStateImplCopyWithImpl<$Res>
    extends _$ServerSetupStateCopyWithImpl<$Res, _$ServerSetupStateImpl>
    implements _$$ServerSetupStateImplCopyWith<$Res> {
  __$$ServerSetupStateImplCopyWithImpl(_$ServerSetupStateImpl _value,
      $Res Function(_$ServerSetupStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServerSetupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? isTesting = null,
    Object? isVerified = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ServerSetupStateImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      isTesting: null == isTesting
          ? _value.isTesting
          : isTesting // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ServerSetupStateImpl implements _ServerSetupState {
  const _$ServerSetupStateImpl(
      {this.url = '',
      this.isTesting = false,
      this.isVerified = false,
      this.errorMessage});

  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final bool isTesting;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ServerSetupState(url: $url, isTesting: $isTesting, isVerified: $isVerified, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerSetupStateImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.isTesting, isTesting) ||
                other.isTesting == isTesting) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, url, isTesting, isVerified, errorMessage);

  /// Create a copy of ServerSetupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerSetupStateImplCopyWith<_$ServerSetupStateImpl> get copyWith =>
      __$$ServerSetupStateImplCopyWithImpl<_$ServerSetupStateImpl>(
          this, _$identity);
}

abstract class _ServerSetupState implements ServerSetupState {
  const factory _ServerSetupState(
      {final String url,
      final bool isTesting,
      final bool isVerified,
      final String? errorMessage}) = _$ServerSetupStateImpl;

  @override
  String get url;
  @override
  bool get isTesting;
  @override
  bool get isVerified;
  @override
  String? get errorMessage;

  /// Create a copy of ServerSetupState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerSetupStateImplCopyWith<_$ServerSetupStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
