import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocery/shared/models/business.dart';
import 'package:grocery/shared/models/store.dart';
import 'package:grocery/shared/models/user.dart';

part 'business_detail.freezed.dart';
part 'business_detail.g.dart';

@freezed
class BusinessDetail with _$BusinessDetail {
  const factory BusinessDetail({
    required Business business,
    required List<User> managers,
    required List<User> sellers,
    required List<Store> stores,
  }) = _BusinessDetail;

  factory BusinessDetail.fromJson(Map<String, dynamic> json) =>
      _$BusinessDetailFromJson(json);
}
