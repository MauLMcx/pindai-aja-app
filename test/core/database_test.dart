import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 11, 17, 10);

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertProduct(String id) {
    return db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            id: id,
            storeId: 'store-1',
            name: 'Pakan Uji',
            baseUnit: 'pcs',
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> insertMovement(String id, int delta, MovementType type) {
    return db
        .into(db.stockMovements)
        .insert(
          StockMovementsCompanion.insert(
            id: id,
            storeId: 'store-1',
            productId: 'p1',
            qtyBaseDelta: delta,
            type: type,
            occurredAt: now,
          ),
        );
  }

  test('stok adalah jumlah ledger, bukan angka yang ditimpa', () async {
    await insertProduct('p1');
    await insertMovement('m1', 10, MovementType.initial);
    await insertMovement('m2', -3, MovementType.saleOut);
    await insertMovement('m3', 2, MovementType.returnIn);

    expect(await db.stockBase('p1'), 9);
  });

  test('stok boleh minus (penjualan saat stok belum tercatat)', () async {
    await insertProduct('p1');
    await insertMovement('m1', -2, MovementType.saleOut);

    expect(await db.stockBase('p1'), -2);
  });

  test('produk dan outbox tersimpan dalam satu transaksi', () async {
    await db.transaction(() async {
      await insertProduct('p1');
      await db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              opId: 'op-1',
              targetTable: 'products',
              rowId: 'p1',
              op: 'insert',
              payload: '{"id":"p1"}',
              createdAt: now,
            ),
          );
    });

    final products = await db.select(db.products).get();
    final outbox = await db.select(db.outbox).get();
    expect(products, hasLength(1));
    expect(outbox, hasLength(1));
    expect(outbox.single.syncedAt, isNull);
  });

  test('transaksi yang gagal tidak meninggalkan data setengah jadi', () async {
    await expectLater(
      db.transaction(() async {
        await insertProduct('p1');
        throw StateError('dibatalkan');
      }),
      throwsStateError,
    );

    expect(await db.select(db.products).get(), isEmpty);
  });
}
