import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';
import 'stock_math.dart';
import 'stock_queries.dart';

String _iso(DateTime value) => value.toUtc().toIso8601String();

class OpnameItemRow {
  const OpnameItemRow({
    required this.productId,
    required this.productName,
    required this.baseUnit,
    required this.countedBase,
    this.expectedBase,
    this.diffBase,
  });

  final String productId;
  final String productName;
  final String baseUnit;
  final int countedBase;
  final int? expectedBase;
  final int? diffBase;
}

class OpnameDiffRow {
  const OpnameDiffRow({
    required this.productId,
    required this.productName,
    required this.baseUnit,
    required this.expectedBase,
    required this.countedBase,
    required this.valueRupiah,
  });

  final String productId;
  final String productName;
  final String baseUnit;
  final int expectedBase;
  final int countedBase;
  final int valueRupiah;

  int get diffBase => countedBase - expectedBase;
}

class OpnameFinishResult {
  const OpnameFinishResult({
    required this.opnameId,
    required this.finishedAt,
    required this.rows,
  });

  final String opnameId;
  final DateTime finishedAt;

  /// Hanya baris yang selisihnya tidak nol.
  final List<OpnameDiffRow> rows;

  int get adjustedCount => rows.length;
  int get totalValueRupiah =>
      rows.fold<int>(0, (sum, row) => sum + row.valueRupiah);
}

/// Membuat sesi opname baru (SPEC §6.8). `scope` hanya catatan bebas,
/// misalnya "Seluruh toko" atau "Rak A".
Future<String> startOpname(
  AppDatabase db, {
  required String storeId,
  String? scope,
  String? note,
  DateTime? at,
}) async {
  final now = (at ?? DateTime.now()).toUtc();
  final opnameId = newId();

  await db.transaction(() async {
    await db
        .into(db.stockOpnames)
        .insert(
          StockOpnamesCompanion.insert(
            id: opnameId,
            storeId: storeId,
            startedAt: now,
            scope: Value(scope),
            note: Value(note),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await enqueueOutbox(
      db,
      table: 'stock_opnames',
      rowId: opnameId,
      op: 'insert',
      payload: {
        'id': opnameId,
        'store_id': storeId,
        'started_at': _iso(now),
        'finished_at': null,
        'status': 'open',
        'scope': scope,
        'note': note,
        'created_at': _iso(now),
        'updated_at': _iso(now),
      },
      at: now,
    );
  });

  return opnameId;
}

/// Menyimpan jumlah fisik satu produk pada sesi opname yang masih terbuka.
Future<void> setOpnameCount(
  AppDatabase db, {
  required String storeId,
  required String opnameId,
  required String productId,
  required int countedBase,
  DateTime? at,
}) async {
  if (countedBase < 0) {
    throw ArgumentError('Jumlah fisik tidak boleh negatif.');
  }

  final now = (at ?? DateTime.now()).toUtc();

  await db.transaction(() async {
    final opname = await (db.select(
      db.stockOpnames,
    )..where((t) => t.id.equals(opnameId))).getSingleOrNull();
    if (opname == null) {
      throw ArgumentError('Sesi opname tidak ditemukan.');
    }
    if (opname.status == OpnameStatus.finished) {
      throw StateError(
        'Sesi opname sudah selesai. Buat sesi baru untuk mengoreksi stok.',
      );
    }

    final existing =
        await (db.select(db.stockOpnameItems)..where(
              (t) =>
                  t.opnameId.equals(opnameId) & t.productId.equals(productId),
            ))
            .getSingleOrNull();

    if (existing == null) {
      final itemId = newId();
      await db
          .into(db.stockOpnameItems)
          .insert(
            StockOpnameItemsCompanion.insert(
              id: itemId,
              storeId: storeId,
              opnameId: opnameId,
              productId: productId,
              countedBase: countedBase,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await enqueueOutbox(
        db,
        table: 'stock_opname_items',
        rowId: itemId,
        op: 'insert',
        payload: {
          'id': itemId,
          'store_id': storeId,
          'opname_id': opnameId,
          'product_id': productId,
          'expected_base': null,
          'counted_base': countedBase,
          'diff_base': null,
          'created_at': _iso(now),
          'updated_at': _iso(now),
        },
        at: now,
      );
      return;
    }

    await (db.update(
      db.stockOpnameItems,
    )..where((t) => t.id.equals(existing.id))).write(
      StockOpnameItemsCompanion(
        countedBase: Value(countedBase),
        updatedAt: Value(now),
      ),
    );
    await enqueueOutbox(
      db,
      table: 'stock_opname_items',
      rowId: existing.id,
      op: 'update',
      payload: {
        'id': existing.id,
        'store_id': storeId,
        'opname_id': opnameId,
        'product_id': productId,
        'counted_base': countedBase,
        'updated_at': _iso(now),
      },
      at: now,
    );
  });
}

/// Menutup sesi opname: selisih dihitung terhadap stok buku saat selesai,
/// lalu dicatat sebagai mutasi `opname_adjust` (SPEC §6.8).
///
/// Setelah selesai, sesi tidak bisa diubah lagi.
Future<OpnameFinishResult> finishOpname(
  AppDatabase db, {
  required String storeId,
  required String opnameId,
  DateTime? at,
}) async {
  final now = (at ?? DateTime.now()).toUtc();
  final rows = <OpnameDiffRow>[];

  await db.transaction(() async {
    final opname = await (db.select(
      db.stockOpnames,
    )..where((t) => t.id.equals(opnameId))).getSingleOrNull();
    if (opname == null) {
      throw ArgumentError('Sesi opname tidak ditemukan.');
    }
    if (opname.status == OpnameStatus.finished) {
      throw StateError('Sesi opname ini sudah selesai.');
    }

    final items = await (db.select(
      db.stockOpnameItems,
    )..where((t) => t.opnameId.equals(opnameId) & t.deletedAt.isNull())).get();

    for (final item in items) {
      final expected = await db.stockBase(item.productId);
      final diff = opnameDiffBase(
        countedBase: item.countedBase,
        expectedBase: expected,
      );

      final product = await (db.select(
        db.products,
      )..where((t) => t.id.equals(item.productId))).getSingleOrNull();

      await (db.update(
        db.stockOpnameItems,
      )..where((t) => t.id.equals(item.id))).write(
        StockOpnameItemsCompanion(
          expectedBase: Value(expected),
          diffBase: Value(diff),
          updatedAt: Value(now),
        ),
      );
      await enqueueOutbox(
        db,
        table: 'stock_opname_items',
        rowId: item.id,
        op: 'update',
        payload: {
          'id': item.id,
          'store_id': storeId,
          'expected_base': expected,
          'diff_base': diff,
          'updated_at': _iso(now),
        },
        at: now,
      );

      if (diff == 0) continue;

      final avg = await movingAverageCostBase(db, item.productId);
      final movementId = newId();
      await db
          .into(db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: movementId,
              storeId: storeId,
              productId: item.productId,
              qtyBaseDelta: diff,
              type: MovementType.opnameAdjust,
              refType: const Value('stock_opname'),
              refId: Value(opnameId),
              costPerBase: Value(avg),
              occurredAt: now,
              note: Value(opname.note),
            ),
          );
      await enqueueOutbox(
        db,
        table: 'stock_movements',
        rowId: movementId,
        op: 'insert',
        payload: {
          'id': movementId,
          'store_id': storeId,
          'product_id': item.productId,
          'qty_base_delta': diff,
          'type': 'opname_adjust',
          'ref_type': 'stock_opname',
          'ref_id': opnameId,
          'cost_per_base': avg,
          'occurred_at': _iso(now),
          'note': opname.note,
        },
        at: now,
      );

      rows.add(
        OpnameDiffRow(
          productId: item.productId,
          productName: product?.name ?? item.productId,
          baseUnit: product?.baseUnit ?? '',
          expectedBase: expected,
          countedBase: item.countedBase,
          valueRupiah: (diff * avg).round(),
        ),
      );
    }

    await (db.update(
      db.stockOpnames,
    )..where((t) => t.id.equals(opnameId))).write(
      StockOpnamesCompanion(
        status: const Value(OpnameStatus.finished),
        finishedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await enqueueOutbox(
      db,
      table: 'stock_opnames',
      rowId: opnameId,
      op: 'update',
      payload: {
        'id': opnameId,
        'store_id': storeId,
        'status': 'finished',
        'finished_at': _iso(now),
        'updated_at': _iso(now),
      },
      at: now,
    );
  });

  return OpnameFinishResult(opnameId: opnameId, finishedAt: now, rows: rows);
}

/// Baris yang sudah dihitung pada satu sesi opname.
Future<List<OpnameItemRow>> loadOpnameItems(
  AppDatabase db,
  String opnameId,
) async {
  final rows = await db
      .customSelect(
        'select i.product_id, p.name as product_name, p.base_unit, '
        'i.counted_base, i.expected_base, i.diff_base '
        'from stock_opname_items i '
        'join products p on p.id = i.product_id '
        'where i.opname_id = ? and i.deleted_at is null '
        'order by p.name collate nocase',
        variables: [Variable<String>(opnameId)],
        readsFrom: {db.stockOpnameItems, db.products},
      )
      .get();

  return rows
      .map(
        (row) => OpnameItemRow(
          productId: row.read<String>('product_id'),
          productName: row.read<String>('product_name'),
          baseUnit: row.read<String>('base_unit'),
          countedBase: row.read<int>('counted_base'),
          expectedBase: row.readNullable<int>('expected_base'),
          diffBase: row.readNullable<int>('diff_base'),
        ),
      )
      .toList();
}
