import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/ledger.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';

class OpnameResult {
  const OpnameResult({
    required this.opname,
    required this.totalDiffBase,
    required this.adjustedValue,
  });

  final StockOpname opname;

  /// Jumlah selisih satuan dasar (fisik − buku) seluruh item.
  final int totalDiffBase;

  /// Perkiraan nilai rupiah penyesuaian memakai HPP rata-rata.
  final int adjustedValue;
}

/// Stok opname (SPEC §6.8). Selisih dihitung saat selesai dan dicatat sebagai
/// mutasi `opname_adjust`; sesi yang sudah selesai tidak bisa diubah.
class OpnameService {
  OpnameService(this.db, {required this.storeId, required this.deviceId});

  final AppDatabase db;
  final String storeId;
  final String deviceId;

  Future<StockOpname> start({
    String? scope,
    String? note,
    DateTime? startedAt,
  }) {
    return db.transaction(() async {
      final at = (startedAt ?? DateTime.now()).toUtc();
      final id = newId();
      await db
          .into(db.stockOpnames)
          .insert(
            StockOpnamesCompanion.insert(
              id: id,
              storeId: storeId,
              startedAt: at,
              scope: Value(scope),
              note: Value(note),
              createdAt: at,
              updatedAt: at,
              deviceId: Value(deviceId),
            ),
          );

      await enqueueOutbox(
        db,
        table: 'stock_opnames',
        rowId: id,
        op: 'insert',
        payload: {
          'id': id,
          'store_id': storeId,
          'started_at': at.toIso8601String(),
          'status': const OpnameStatusConverter().toSql(OpnameStatus.open),
          'scope': scope,
          'note': note,
          'created_at': at.toIso8601String(),
          'updated_at': at.toIso8601String(),
          'device_id': deviceId,
        },
        at: at,
      );

      return (await (db.select(
        db.stockOpnames,
      )..where((t) => t.id.equals(id))).getSingle());
    });
  }

  Future<void> recordCount({
    required String opnameId,
    required String productId,
    required int countedBase,
    DateTime? at,
  }) async {
    if (countedBase < 0) {
      throw ArgumentError('jumlah fisik tidak boleh negatif');
    }

    return db.transaction(() async {
      final opname = await _requireOpen(opnameId);
      final now = (at ?? DateTime.now()).toUtc();
      final existing =
          await (db.select(db.stockOpnameItems)..where(
                (t) =>
                    t.opnameId.equals(opnameId) & t.productId.equals(productId),
              ))
              .getSingleOrNull();

      if (existing == null) {
        final id = newId();
        await db
            .into(db.stockOpnameItems)
            .insert(
              StockOpnameItemsCompanion.insert(
                id: id,
                storeId: storeId,
                opnameId: opname.id,
                productId: productId,
                countedBase: countedBase,
                createdAt: now,
                updatedAt: now,
                deviceId: Value(deviceId),
              ),
            );
        await enqueueOutbox(
          db,
          table: 'stock_opname_items',
          rowId: id,
          op: 'insert',
          payload: {
            'id': id,
            'store_id': storeId,
            'opname_id': opname.id,
            'product_id': productId,
            'counted_base': countedBase,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
            'device_id': deviceId,
          },
          at: now,
        );
      } else {
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
            'opname_id': opname.id,
            'product_id': productId,
            'counted_base': countedBase,
            'updated_at': now.toIso8601String(),
            'device_id': deviceId,
          },
          at: now,
        );
      }
    });
  }

  Future<OpnameResult> finish({
    required String opnameId,
    DateTime? finishedAt,
  }) {
    return db.transaction(() async {
      final opname = await _requireOpen(opnameId);
      final items = await (db.select(
        db.stockOpnameItems,
      )..where((t) => t.opnameId.equals(opnameId))).get();
      if (items.isEmpty) {
        throw StateError('opname belum punya item yang dihitung');
      }

      final now = (finishedAt ?? DateTime.now()).toUtc();
      var totalDiff = 0;
      var adjustedValue = 0;

      for (final item in items) {
        final expected = await stockBaseOf(db, item.productId);
        final diff = item.countedBase - expected;
        totalDiff += diff;

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
            'opname_id': opnameId,
            'product_id': item.productId,
            'expected_base': expected,
            'counted_base': item.countedBase,
            'diff_base': diff,
            'updated_at': now.toIso8601String(),
            'device_id': deviceId,
          },
          at: now,
        );

        if (diff != 0) {
          final cost = await averageCostBaseOf(db, item.productId);
          if (cost != null) {
            adjustedValue += (diff * cost).round();
          }
          await addStockMovement(
            db,
            id: newId(),
            storeId: storeId,
            productId: item.productId,
            qtyBaseDelta: diff,
            type: MovementType.opnameAdjust,
            occurredAt: now,
            refType: 'opname',
            refId: opnameId,
            costPerBase: cost,
            note: 'opname',
            deviceId: deviceId,
          );
        }
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
          'started_at': opname.startedAt.toUtc().toIso8601String(),
          'finished_at': now.toIso8601String(),
          'status': const OpnameStatusConverter().toSql(OpnameStatus.finished),
          'scope': opname.scope,
          'note': opname.note,
          'updated_at': now.toIso8601String(),
          'device_id': deviceId,
        },
        at: now,
      );

      final finished = await (db.select(
        db.stockOpnames,
      )..where((t) => t.id.equals(opnameId))).getSingle();

      return OpnameResult(
        opname: finished,
        totalDiffBase: totalDiff,
        adjustedValue: adjustedValue,
      );
    });
  }

  Future<StockOpname> _requireOpen(String opnameId) async {
    final opname = await (db.select(
      db.stockOpnames,
    )..where((t) => t.id.equals(opnameId))).getSingleOrNull();
    if (opname == null) {
      throw StateError('opname tidak ditemukan');
    }
    if (opname.status != OpnameStatus.open) {
      throw StateError('opname sudah selesai dan tidak bisa diubah');
    }
    return opname;
  }
}
