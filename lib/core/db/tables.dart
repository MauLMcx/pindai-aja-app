import 'package:drift/drift.dart';

import 'enums.dart';

/// Kolom konvensi SPEC §7 untuk tabel yang dapat diubah (bukan ledger).
mixin StoreScoped on Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Stores extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code2 => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Profiles extends Table {
  TextColumn get userId => text()();
  TextColumn get storeId => text()();
  TextColumn get role => text().map(const UserRoleConverter())();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

class Devices extends Table with StoreScoped {
  TextColumn get code => text()();
  TextColumn get name => text().nullable()();
}

class Suppliers extends Table with StoreScoped {
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get note => text().nullable()();
}

class Categories extends Table with StoreScoped {
  TextColumn get name => text()();
  RealColumn get defaultMarginPct => real().nullable()();
}

class Products extends Table with StoreScoped {
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get variant => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get baseUnit => text()();
  IntColumn get minStockBase => integer().withDefault(const Constant(0))();
  TextColumn get shelfLocation => text().nullable()();
  TextColumn get mainSupplierId => text().nullable()();
  BoolColumn get needsPriceReview =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get note => text().nullable()();
}

class ProductUnits extends Table with StoreScoped {
  TextColumn get productId => text()();
  TextColumn get unitName => text()();
  IntColumn get factorToBase => integer()();
  TextColumn get barcode => text().nullable()();
  TextColumn get barcodeSource =>
      text().map(const BarcodeSourceConverter()).nullable()();
  IntColumn get sellPrice => integer().nullable()();
  BoolColumn get isDefaultSale =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isDefaultPurchase =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {storeId, barcode},
  ];
}

/// Riwayat harga. APPEND-ONLY (SPEC §7).
class PriceHistory extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get productUnitId => text()();
  TextColumn get kind => text().map(const PriceKindConverter())();
  IntColumn get price => integer()();
  DateTimeColumn get effectiveAt => dateTime()();
  TextColumn get sourceRef => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Purchases extends Table with StoreScoped {
  TextColumn get supplierId => text().nullable()();
  TextColumn get docNo => text().nullable()();
  DateTimeColumn get purchasedAt => dateTime()();
  IntColumn get total => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
}

class PurchaseItems extends Table with StoreScoped {
  TextColumn get purchaseId => text()();
  TextColumn get productId => text()();
  TextColumn get unitId => text()();
  IntColumn get qty => integer()();
  IntColumn get unitCost => integer()();
  IntColumn get qtyBase => integer()();
  RealColumn get costPerBase => real()();
}

/// Ledger stok. APPEND-ONLY: stok = jumlah `qty_base_delta` (SPEC P2).
class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get productId => text()();
  IntColumn get qtyBaseDelta => integer()();
  TextColumn get type => text().map(const MovementTypeConverter())();
  TextColumn get refType => text().nullable()();
  TextColumn get refId => text().nullable()();
  RealColumn get costPerBase => real().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get deviceId => text().nullable()();
  IntColumn get serverSeq => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Riwayat penataan barang. APPEND-ONLY.
class PutawayLog extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get productId => text()();
  TextColumn get fromLocation => text().nullable()();
  TextColumn get toLocation => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Customers extends Table with StoreScoped {
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get creditLimit => integer().nullable()();
}

/// Ledger utang pelanggan. APPEND-ONLY: saldo = jumlah `delta` (SPEC §6.9).
class DebtLedger extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get customerId => text()();
  IntColumn get delta => integer()();
  TextColumn get type => text().map(const DebtTypeConverter())();
  TextColumn get refId => text().nullable()();
  TextColumn get method => text().map(const PayMethodConverter()).nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get deviceId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Sales extends Table with StoreScoped {
  TextColumn get receiptNo => text()();
  TextColumn get cashierId => text()();
  TextColumn get customerId => text().nullable()();
  DateTimeColumn get soldAt => dateTime()();
  IntColumn get subtotal => integer()();
  IntColumn get discountTotal => integer().withDefault(const Constant(0))();
  IntColumn get total => integer()();
  IntColumn get paidTotal => integer()();
  IntColumn get changeAmount => integer().withDefault(const Constant(0))();
  TextColumn get status => text()
      .map(const SaleStatusConverter())
      .withDefault(const Constant('completed'))();
  TextColumn get note => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {storeId, receiptNo},
  ];
}

class SaleItems extends Table with StoreScoped {
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  TextColumn get unitId => text()();
  IntColumn get qty => integer()();
  IntColumn get qtyBase => integer()();
  IntColumn get unitPrice => integer()();
  IntColumn get discount => integer().withDefault(const Constant(0))();
  IntColumn get lineTotal => integer()();

  /// Snapshot HPP per satuan dasar saat penjualan (SPEC §6.10).
  RealColumn get costPerBase => real().nullable()();
}

class Payments extends Table with StoreScoped {
  TextColumn get saleId => text()();
  TextColumn get method => text().map(const PayMethodConverter())();
  IntColumn get amount => integer()();
  TextColumn get status => text()
      .map(const PaymentStatusConverter())
      .withDefault(const Constant('confirmed'))();
  TextColumn get reference => text().nullable()();
  DateTimeColumn get paidAt => dateTime()();
}

class Returns extends Table with StoreScoped {
  TextColumn get kind => text().map(const ReturnKindConverter())();
  TextColumn get saleId => text().nullable()();
  TextColumn get purchaseId => text().nullable()();
  TextColumn get customerId => text().nullable()();
  DateTimeColumn get returnedAt => dateTime()();
  TextColumn get refundMethod =>
      text().map(const PayMethodConverter()).nullable()();
  IntColumn get refundTotal => integer().withDefault(const Constant(0))();
  TextColumn get reason => text().nullable()();
}

class ReturnItems extends Table with StoreScoped {
  TextColumn get returnId => text()();
  TextColumn get productId => text()();
  TextColumn get unitId => text()();
  IntColumn get qty => integer()();
  IntColumn get qtyBase => integer()();
  IntColumn get amount => integer()();
  RealColumn get costPerBase => real().nullable()();
}

class StockOpnames extends Table with StoreScoped {
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get status => text()
      .map(const OpnameStatusConverter())
      .withDefault(const Constant('open'))();
  TextColumn get scope => text().nullable()();
  TextColumn get note => text().nullable()();
}

class StockOpnameItems extends Table with StoreScoped {
  TextColumn get opnameId => text()();
  TextColumn get productId => text()();
  IntColumn get expectedBase => integer().nullable()();
  IntColumn get countedBase => integer()();
  IntColumn get diffBase => integer().nullable()();
}

class Expenses extends Table with StoreScoped {
  TextColumn get category => text()();
  IntColumn get amount => integer()();
  DateTimeColumn get spentAt => dateTime()();
  TextColumn get note => text().nullable()();
}

class AppSettings extends Table {
  TextColumn get storeId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {storeId, key};
}

/// Antrean sinkron lokal. Ditulis dalam transaksi yang sama dengan data (SPEC P1).
class Outbox extends Table {
  TextColumn get opId => text()();
  TextColumn get targetTable => text().named('table_name')();
  TextColumn get rowId => text()();
  TextColumn get op => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {opId};
}

class SyncState extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
