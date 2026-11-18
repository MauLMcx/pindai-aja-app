import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/stock/opname_service.dart';
import 'package:petshop_pos/features/stock/purchase_service.dart';

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

  test('opname mencatat selisih terhadap stok buku saat selesai', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Meo Ikan');
    // Stok buku 20.000 gram @ Rp 15/gram.
    await recordPurchase(
      db,
      storeId: store.id,
      purchasedAt: DateTime.utc(2026, 11, 10, 9),
      lines: [
        PurchaseLineInput(
          productId: product.productId,
          unitId: product.purchaseUnitId,
          qty: 2,
          unitCost: 150000,
        ),
      ],
    );

    final opnameId = await startOpname(
      db,
      storeId: store.id,
      scope: 'Seluruh toko',
      at: DateTime.utc(2026, 11, 13, 8),
    );
    await setOpnameCount(
      db,
      storeId: store.id,
      opnameId: opnameId,
      productId: product.productId,
      countedBase: 19500,
      at: DateTime.utc(2026, 11, 13, 8, 5),
    );

    final result = await finishOpname(
      db,
      storeId: store.id,
      opnameId: opnameId,
      at: DateTime.utc(2026, 11, 13, 9),
    );

    expect(result.adjustedCount, 1);
    expect(result.rows.single.diffBase, -500);
    expect(result.rows.single.valueRupiah, -7500);
    expect(await db.stockBase(product.productId), 19500);

    final adjust = await (db.select(
      db.stockMovements,
    )..where((t) => t.type.equalsValue(MovementType.opnameAdjust))).get();
    expect(adjust, hasLength(1));
    expect(adjust.single.qtyBaseDelta, -500);
    expect(adjust.single.refType, 'stock_opname');
    expect(adjust.single.refId, opnameId);

    final items = await loadOpnameItems(db, opnameId);
    expect(items.single.expectedBase, 20000);
    expect(items.single.diffBase, -500);

    final opname = await (db.select(
      db.stockOpnames,
    )..where((t) => t.id.equals(opnameId))).getSingle();
    expect(opname.status.name, 'finished');
    expect(opname.finishedAt, isNotNull);
  });

  test(
    'opname pertama pada produk tanpa stok menjadi stok awal (S10)',
    () async {
      final product = await addProduct(
        db,
        storeId: store.id,
        name: 'Pasir Baru',
      );

      final opnameId = await startOpname(db, storeId: store.id);
      await setOpnameCount(
        db,
        storeId: store.id,
        opnameId: opnameId,
        productId: product.productId,
        countedBase: 5000,
      );
      await finishOpname(db, storeId: store.id, opnameId: opnameId);

      expect(await db.stockBase(product.productId), 5000);
    },
  );

  test(
    'sesi selesai tidak bisa diubah (append-only lewat sesi baru)',
    () async {
      final product = await addProduct(db, storeId: store.id, name: 'Whiskas');

      final opnameId = await startOpname(db, storeId: store.id);
      await setOpnameCount(
        db,
        storeId: store.id,
        opnameId: opnameId,
        productId: product.productId,
        countedBase: 10,
      );
      await finishOpname(db, storeId: store.id, opnameId: opnameId);

      await expectLater(
        setOpnameCount(
          db,
          storeId: store.id,
          opnameId: opnameId,
          productId: product.productId,
          countedBase: 20,
        ),
        throwsStateError,
      );
      await expectLater(
        finishOpname(db, storeId: store.id, opnameId: opnameId),
        throwsStateError,
      );

      expect(await db.stockBase(product.productId), 10);
    },
  );

  test(
    'menghitung ulang produk yang sama menimpa angka, bukan menambah',
    () async {
      final product = await addProduct(db, storeId: store.id, name: 'Aice');

      final opnameId = await startOpname(db, storeId: store.id);
      await setOpnameCount(
        db,
        storeId: store.id,
        opnameId: opnameId,
        productId: product.productId,
        countedBase: 7,
      );
      await setOpnameCount(
        db,
        storeId: store.id,
        opnameId: opnameId,
        productId: product.productId,
        countedBase: 9,
      );

      expect(await db.select(db.stockOpnameItems).get(), hasLength(1));

      await finishOpname(db, storeId: store.id, opnameId: opnameId);
      expect(await db.stockBase(product.productId), 9);
    },
  );

  test('jumlah fisik negatif ditolak', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Royal');

    final opnameId = await startOpname(db, storeId: store.id);
    await expectLater(
      setOpnameCount(
        db,
        storeId: store.id,
        opnameId: opnameId,
        productId: product.productId,
        countedBase: -1,
      ),
      throwsArgumentError,
    );
  });

  test('opname tanpa selisih tidak menulis mutasi', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Life Cat');
    await addMovement(
      db,
      storeId: store.id,
      productId: product.productId,
      qtyBaseDelta: 400,
      type: MovementType.initial,
    );

    final opnameId = await startOpname(db, storeId: store.id);
    await setOpnameCount(
      db,
      storeId: store.id,
      opnameId: opnameId,
      productId: product.productId,
      countedBase: 400,
    );
    final result = await finishOpname(
      db,
      storeId: store.id,
      opnameId: opnameId,
    );

    expect(result.rows, isEmpty);
    expect(await db.stockBase(product.productId), 400);
  });
}
