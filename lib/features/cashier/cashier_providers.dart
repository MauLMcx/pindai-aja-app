import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/store/local_identity.dart';
import '../products/products_providers.dart';

/// Identitas perangkat + pemilik lokal untuk transaksi sebelum login.
final localIdentityProvider = FutureProvider<LocalIdentity>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final store = await ref.watch(localStoreProvider.future);
  return ensureLocalIdentity(db, storeId: store.id);
});

/// Penjualan yang ditahan (status `hold`), terbaru dulu.
final heldSalesProvider = StreamProvider<List<Sale>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.sales)
        ..where((t) => t.status.equalsValue(SaleStatus.hold))
        ..orderBy([(t) => OrderingTerm.desc(t.soldAt)]))
      .watch();
});
