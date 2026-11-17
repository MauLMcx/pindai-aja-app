import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'enums.dart';
import 'tables.dart';

export 'enums.dart';
export 'tables.dart';

part 'app_database.g.dart';

/// Database lokal SQLite (Drift). Sumber kebenaran saat offline (SPEC P1).
@DriftDatabase(
  tables: [
    Stores,
    Profiles,
    Devices,
    Suppliers,
    Categories,
    Products,
    ProductUnits,
    PriceHistory,
    Purchases,
    PurchaseItems,
    StockMovements,
    PutawayLog,
    Customers,
    DebtLedger,
    Sales,
    SaleItems,
    Payments,
    Returns,
    ReturnItems,
    StockOpnames,
    StockOpnameItems,
    Expenses,
    AppSettings,
    Outbox,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Database di memori untuk tes.
  AppDatabase.memory()
    : super(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Stok saat ini = jumlah seluruh mutasi (SPEC P2). Tidak pernah ditimpa.
  Future<int> stockBase(String productId) async {
    final total = stockMovements.qtyBaseDelta.sum();
    final query = selectOnly(stockMovements)
      ..addColumns([total])
      ..where(stockMovements.productId.equals(productId));
    final row = await query.getSingle();
    return row.read(total) ?? 0;
  }
}

/// Membuka database aplikasi di folder dokumen aplikasi.
LazyDatabase openAppDatabaseConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'petshop.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
