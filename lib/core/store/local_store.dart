import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../db/outbox_writer.dart';
import '../ids.dart';

/// Toko bawaan perangkat sebelum login tersedia.
///
/// Login dan peran baru masuk di Tahap 3. Sampai saat itu aplikasi memakai satu
/// toko lokal dengan ID deterministik, sehingga dua perangkat yang menyala
/// offline tetap memakai baris toko yang sama saat sinkron pertama.
Future<Store> ensureLocalStore(AppDatabase db) async {
  final existing =
      await (db.select(db.stores)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) return existing;

  return db.transaction(() async {
    final raced =
        await (db.select(db.stores)
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (raced != null) return raced;

    final id = stableId('store', 'utama');
    final now = DateTime.now().toUtc();
    final row = StoresCompanion.insert(
      id: id,
      name: 'Toko Utama',
      code2: '01',
      createdAt: now,
      updatedAt: now,
    );
    await db.into(db.stores).insert(row);
    await enqueueOutbox(
      db,
      table: 'stores',
      rowId: id,
      op: 'insert',
      payload: {
        'id': id,
        'name': 'Toko Utama',
        'code2': '01',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      at: now,
    );
    return (await (db.select(db.stores)..limit(1)).getSingle());
  });
}
