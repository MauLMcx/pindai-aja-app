import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/outbox_writer.dart';
import 'package:petshop_pos/core/store/local_store.dart';
import 'package:petshop_pos/core/sync/sync_engine.dart';

import '../../support/fake_sync_server.dart';

void main() {
  late AppDatabase db;
  late Store store;
  late FakeSyncServer server;
  late SyncEngine engine;

  setUp(() async {
    db = AppDatabase.memory();
    store = await ensureLocalStore(db);
    server = FakeSyncServer(storeId: store.id);
    engine = SyncEngine(db: db, api: server);
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'S1/S2: semua outbox terkirim dan kirim ulang tidak menggandakan',
    () async {
      for (var i = 1; i <= 3; i++) {
        await _insertProduct(db, store.id, 'p$i', 'Pakan $i');
      }

      final first = await engine.syncNow(force: true);
      expect(first.error, isNull);
      expect(first.failed, 0);
      expect(server.rowsOf('products'), hasLength(3));

      final outbox = await db.select(db.outbox).get();
      expect(outbox.every((row) => row.syncedAt != null), isTrue);

      // Kirim ulang seluruh antrean yang sama (S2).
      await (db.update(db.outbox))
          .write(const OutboxCompanion(syncedAt: Value(null)));

      final second = await engine.syncNow(force: true);
      expect(second.error, isNull);
      expect(second.duplicates, outbox.length);
      expect(server.rowsOf('products'), hasLength(3));
    },
  );

  test(
    'S3: dua HP offline menjual produk yang sama, stok akhir = jumlah',
    () async {
      final other = AppDatabase.memory();
      addTearDown(other.close);
      final otherStore = await ensureLocalStore(other);
      final otherServer = server;
      final otherEngine = SyncEngine(db: other, api: otherServer);

      await _insertMovement(db, store.id, 'mA', 10, 'initial');
      await _insertMovement(other, otherStore.id, 'mB', -3, 'sale_out');

      await engine.syncNow(force: true);
      await otherEngine.syncNow(force: true);

      // Keduanya menarik mutasi milik perangkat lain.
      await engine.syncNow(force: true);
      await otherEngine.syncNow(force: true);

      expect(server.rowsOf('stock_movements'), hasLength(2));
      expect(await db.stockBase('p1'), 7);
      expect(await other.stockBase('p1'), 7);
    },
  );

  test(
    'S4: barcode ganda ditolak dan masuk antrean perlu diselesaikan',
    () async {
      final other = AppDatabase.memory();
      addTearDown(other.close);
      final otherStore = await ensureLocalStore(other);
      final otherEngine = SyncEngine(db: other, api: server);

      await _insertUnit(db, store.id, 'uA', 'p1', '1234567890123');
      await _insertUnit(other, otherStore.id, 'uB', 'p1', '1234567890123');

      final first = await engine.syncNow(force: true);
      expect(first.error, isNull);

      final second = await otherEngine.syncNow(force: true);
      expect(second.failed, 1);

      // Catatan: antrean ada di DB kedua.
      final bOutbox = await other.select(other.outbox).get();
      expect(bOutbox, isNotEmpty);
      final failedUnit = bOutbox.singleWhere(
        (row) => row.targetTable == 'product_units',
      );
      expect(failedUnit.syncedAt, isNull);
      expect(failedUnit.lastError, startsWith('Bentrok'));

      expect(
        server.rowsOf('product_units').map((row) => row['id']),
        contains('uA'),
      );
      expect(
        server.rowsOf('product_units').map((row) => row['id']),
        isNot(contains('uB')),
      );

      // Baris dari server yang bentrok dengan barcode lokal dicatat terpisah.
      final conflicts = await (other.select(
        other.syncState,
      )..where((t) => t.key.like('conflict:%'))).get();
      expect(conflicts, isNotEmpty);
    },
  );

  test('S6: perubahan harga dari dua HP memakai updated_at terbaru', () async {
    final other = AppDatabase.memory();
    addTearDown(other.close);
    final otherStore = await ensureLocalStore(other);
    final otherEngine = SyncEngine(db: other, api: server);

    final older = DateTime.utc(2026, 11, 19, 8);
    final newer = DateTime.utc(2026, 11, 19, 9);

    await _insertProduct(db, store.id, 'p1', 'Harga Lama', updatedAt: older);
    await _insertProduct(
      other,
      otherStore.id,
      'p1',
      'Harga Baru',
      updatedAt: newer,
    );

    await engine.syncNow(force: true);
    await otherEngine.syncNow(force: true);

    // Perangkat pertama menarik nilai terbaru.
    await engine.syncNow(force: true);
    final product = await (db.select(
      db.products,
    )..where((t) => t.id.equals('p1'))).getSingle();
    expect(product.name, 'Harga Baru');

    // Yang lebih tua tidak boleh menimpa server.
    await _insertProduct(
      db,
      store.id,
      'p1',
      'Harga Sangat Lama',
      updatedAt: older.subtract(const Duration(hours: 1)),
    );
    await engine.syncNow(force: true);
    expect(server.row('products', 'p1')?['name'], 'Harga Baru');
  });

  test(
    'S7: jaringan putus di tengah pull, lanjut dari posisi terakhir',
    () async {
      await _insertProduct(db, store.id, 'p1', 'Pakan 1');
      await _insertProduct(db, store.id, 'p2', 'Pakan 2');
      await engine.syncNow(force: true);

      final fresh = AppDatabase.memory();
      addTearDown(fresh.close);
      await ensureLocalStore(fresh);
      final freshEngine = SyncEngine(db: fresh, api: server);

      // Panggilan pull ke-1 gagal (call 0 = stores sudah berhasil).
      server.pullCalls = 0;
      server.failPullAtCall = 1;
      final interrupted = await freshEngine.syncNow(force: true);
      expect(interrupted.error, isNotNull);

      final cursors = await fresh.select(fresh.syncState).get();
      expect(cursors.any((row) => row.key == 'last_pulled_seq:stores'), isTrue);

      server.failPullAtCall = -1;
      final resumed = await freshEngine.syncNow(force: true);
      expect(resumed.error, isNull);

      final products = await fresh.select(fresh.products).get();
      expect(products, hasLength(2));
    },
  );
}

Future<void> _insertProduct(
  AppDatabase db,
  String storeId,
  String id,
  String name, {
  DateTime? updatedAt,
}) async {
  final now = updatedAt ?? DateTime.utc(2026, 11, 19, 8);
  await db.transaction(() async {
    await db
        .into(db.products)
        .insertOnConflictUpdate(
          ProductsCompanion.insert(
            id: id,
            storeId: storeId,
            name: name,
            baseUnit: 'pcs',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await enqueueOutbox(
      db,
      table: 'products',
      rowId: id,
      op: 'insert',
      payload: {
        'id': id,
        'store_id': storeId,
        'name': name,
        'base_unit': 'pcs',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      at: now,
    );
  });
}

Future<void> _insertUnit(
  AppDatabase db,
  String storeId,
  String id,
  String productId,
  String barcode,
) async {
  final now = DateTime.utc(2026, 11, 19, 8);
  await db.transaction(() async {
    await db
        .into(db.productUnits)
        .insert(
          ProductUnitsCompanion.insert(
            id: id,
            storeId: storeId,
            productId: productId,
            unitName: 'pcs',
            factorToBase: 1,
            barcode: Value(barcode),
            barcodeSource: const Value(BarcodeSource.factory),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await enqueueOutbox(
      db,
      table: 'product_units',
      rowId: id,
      op: 'insert',
      payload: {
        'id': id,
        'store_id': storeId,
        'product_id': productId,
        'unit_name': 'pcs',
        'factor_to_base': 1,
        'barcode': barcode,
        'barcode_source': 'factory',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      at: now,
    );
  });
}

Future<void> _insertMovement(
  AppDatabase db,
  String storeId,
  String id,
  int delta,
  String type,
) async {
  final now = DateTime.utc(2026, 11, 19, 10);
  await db.transaction(() async {
    await db
        .into(db.stockMovements)
        .insert(
          StockMovementsCompanion.insert(
            id: id,
            storeId: storeId,
            productId: 'p1',
            qtyBaseDelta: delta,
            type: MovementType.initial,
            occurredAt: now,
          ),
        );
    await enqueueOutbox(
      db,
      table: 'stock_movements',
      rowId: id,
      op: 'insert',
      payload: {
        'id': id,
        'store_id': storeId,
        'product_id': 'p1',
        'qty_base_delta': delta,
        'type': type,
        'occurred_at': now.toIso8601String(),
      },
      at: now,
    );
  });
}
