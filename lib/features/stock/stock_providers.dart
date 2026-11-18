import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import 'opname_service.dart';
import 'stock_queries.dart';

/// Daftar stok seluruh produk aktif.
final stockRowsProvider = FutureProvider<List<StockRow>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return loadStockRows(db);
});

/// Produk di bawah stok minimum, dikelompokkan per pemasok.
final lowStockGroupsProvider = FutureProvider<List<LowStockGroup>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return loadLowStockGroups(db);
});

/// Nilai persediaan total memakai HPP rata-rata.
final inventoryValueProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return totalInventoryValue(db);
});

final suppliersProvider = FutureProvider<List<Supplier>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.suppliers)
        ..where((t) => t.deletedAt.isNull())
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .get();
});

final purchaseSummariesProvider = FutureProvider<List<PurchaseSummary>>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  return loadPurchaseSummaries(db);
});

final saleSummariesProvider = FutureProvider<List<SaleSummary>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return loadSaleSummaries(db);
});

final opnameSummariesProvider = FutureProvider<List<OpnameSummary>>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  return loadOpnameSummaries(db);
});

final returnablePurchaseLinesProvider =
    FutureProvider.family<List<ReturnableLine>, String>((
      ref,
      purchaseId,
    ) async {
      final db = ref.watch(appDatabaseProvider);
      return loadReturnablePurchaseLines(db, purchaseId);
    });

final returnableSaleLinesProvider =
    FutureProvider.family<List<ReturnableLine>, String>((ref, saleId) async {
      final db = ref.watch(appDatabaseProvider);
      return loadReturnableSaleLines(db, saleId);
    });

final opnameItemsProvider = FutureProvider.family<List<OpnameItemRow>, String>((
  ref,
  opnameId,
) async {
  final db = ref.watch(appDatabaseProvider);
  return loadOpnameItems(db, opnameId);
});

/// Riwayat penataan terakhir, untuk ditampilkan di layar Susun Barang.
final recentPutawayProvider = FutureProvider<List<PutawayHistoryRow>>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  return loadPutawayHistory(db);
});
