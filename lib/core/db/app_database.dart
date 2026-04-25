import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:grocery/core/db/tables/products_table.dart';
import 'package:grocery/shared/models/product.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ProductsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> upsertProducts(List<ProductsTableCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(productsTable, rows));

  Future<ProductsTableData?> findByBarcode(String storeId, String barcode) =>
      (select(productsTable)
            ..where((t) => t.storeId.equals(storeId) & t.barcode.equals(barcode)))
          .getSingleOrNull();

  Future<List<ProductsTableData>> getByStore(String storeId) =>
      (select(productsTable)..where((t) => t.storeId.equals(storeId))).get();

  Future<void> evictStale() {
    final cutoff = DateTime.now().subtract(const Duration(minutes: 5));
    return (delete(productsTable)
          ..where((t) => t.cachedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  Future<void> clearAll() => transaction(() async {
        await delete(productsTable).go();
      });
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'grocery.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

extension ProductsTableDataX on ProductsTableData {
  Product toProduct() => Product(
        id: id,
        storeId: storeId,
        name: name,
        barcode: barcode,
        price: price,
        unit: unit,
        updatedAt: cachedAt,
      );
}

extension ProductX on Product {
  ProductsTableCompanion toCompanion() => ProductsTableCompanion(
        id: Value(id),
        storeId: Value(storeId),
        name: Value(name),
        barcode: Value(barcode),
        price: Value(price),
        unit: Value(unit),
        cachedAt: Value(DateTime.now()),
      );
}
