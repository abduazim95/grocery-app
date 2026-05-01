// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessDetailImpl _$$BusinessDetailImplFromJson(Map<String, dynamic> json) =>
    _$BusinessDetailImpl(
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
      managers: (json['managers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      sellers: (json['sellers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      stores: (json['stores'] as List<dynamic>)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BusinessDetailImplToJson(
        _$BusinessDetailImpl instance) =>
    <String, dynamic>{
      'business': instance.business,
      'managers': instance.managers,
      'sellers': instance.sellers,
      'stores': instance.stores,
    };
