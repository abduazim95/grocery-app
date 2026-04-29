import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_selection_provider.g.dart';

@riverpod
class ProductSelection extends _$ProductSelection {
  @override
  Set<String> build() => {};

  void toggle(String id) {
    if (state.contains(id)) {
      state = Set.from(state)..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void selectAll(Iterable<String> ids) => state = {...state, ...ids};

  void clear() => state = {};
}
