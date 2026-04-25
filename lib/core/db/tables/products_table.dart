import 'package:drift/drift.dart';

class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get name => text()();
  TextColumn get barcode => text().nullable()();
  RealColumn get price => real()();
  TextColumn get unit => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
