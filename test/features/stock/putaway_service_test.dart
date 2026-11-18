import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/stock/putaway_service.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase db;
  late Store store;

  setUp(() async {
    db = AppDatabase.memory();
    store = await seedStore(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<Product> readProduct(String id) =>
      (db.select(db.products)..where((t) => t.id.equals(id))).getSingle();

  test('susun barang mengubah rak dan menulis riwayat putaway', () async {
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Royal Canin',
    );

    final moved = await moveProductToShelf(
      db,
      storeId: store.id,
      productId: product.productId,
      location: '  Rak A-3  ',
      at: DateTime.utc(2026, 11, 12, 8),
    );

    expect(moved, isTrue);
    expect((await readProduct(product.productId)).shelfLocation, 'Rak A-3');

    final log = await db.select(db.putawayLog).getSingle();
    expect(log.fromLocation, isNull);
    expect(log.toLocation, 'Rak A-3');
    expect(log.productId, product.productId);

    final outbox = await db.select(db.outbox).get();
    expect(
      outbox.map((row) => '${row.targetTable}:${row.op}').toSet(),
      containsAll(<String>['products:update', 'putaway_log:insert']),
    );
  });

  test('rak yang sama tidak menulis riwayat baru', () async {
    await clearOutbox(db);
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Life Cat',
      shelfLocation: 'Rak B-1',
    );

    final moved = await moveProductToShelf(
      db,
      storeId: store.id,
      productId: product.productId,
      location: 'Rak B-1',
    );

    expect(moved, isFalse);
    expect(await db.select(db.putawayLog).get(), isEmpty);
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('lokasi kosong menghapus rak dan tercatat di riwayat', () async {
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Tayo',
      shelfLocation: 'Rak C-2',
    );

    final moved = await moveProductToShelf(
      db,
      storeId: store.id,
      productId: product.productId,
      location: '   ',
    );

    expect(moved, isTrue);
    expect((await readProduct(product.productId)).shelfLocation, isNull);
    final log = await db.select(db.putawayLog).getSingle();
    expect(log.fromLocation, 'Rak C-2');
    expect(log.toLocation, isNull);
  });

  test('produk tidak dikenal ditolak', () async {
    await expectLater(
      moveProductToShelf(
        db,
        storeId: store.id,
        productId: 'tidak-ada',
        location: 'Rak Z',
      ),
      throwsArgumentError,
    );
  });
}
