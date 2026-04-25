import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
class Store with _$Store {
  const factory Store({
    required String id,
    required String name,
    @JsonKey(defaultValue: '') String? address,
    @JsonKey(name: 'manager_id') required String managerId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}
