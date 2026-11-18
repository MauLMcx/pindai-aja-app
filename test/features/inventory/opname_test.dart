import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/ledger.dart';
import 'package:petshop_pos/features/inventory/opname_service.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;
  late OpnameService service;

  setUp(() async {
    db = await makeTestDb();
    service = OpnameService(db, storeId: storeId, deviceId: deviceId);
    await addStockMovement(
      db,
      id: 'initial-a',
      storeId: storeId,
      productId: productA,
      qtyBaseDelta: 10,
      type: MovementType.initial,
      occurredAt: testNow,
      costPerBase: 6000,
      deviceId: deviceId,
    );
  });

  tearDown(() => db.close());

  test('selisih opname dicatat sebagai mutasi penyesuaian', () async {
    final opname = await service.start(startedAt: testNow);
    await service.recordCount(
      opnameId: opname.id,
      productId: productA,
      countedBase: 7,
      at: testNow,
    );

    final result = await service.finish(
      opnameId: opname.id,
      finishedAt: testNow.add(const Duration(hours: 1)),
    );

    expect(result.totalDiffBase, -3);
    expect(result.adjustedValue, -18000);
    expect(result.opname.status, OpnameStatus.finished);
    expect(await db.stockBase(productA), 7);

    final adjustments = await (db.select(db.stockMovements)
          ..where((t) => t.type.equalsValue(MovementType.opnameAdjust)))
        .get();
    expect(adjustments, hasLength(1));
    expect(adjustments.single.qtyBaseDelta, -3);
  });

  test('menghitung ulang item yang sama tidak membuat baris ganda', () async {
    final opname = await service.start(startedAt: testNow);
    await service.recordCount(
      opnameId: opname.id,
      productId: productA,
      countedBase: 9,
      at: testNow,
    );
    await service.recordCount(
      opnameId: opname.id,
      productId: productA,
      countedBase: 8,
      at: testNow,
    );

    final items = await db.select(db.stockOpnameItems).get();
    expect(items, hasLength(1));
    expect(items.single.countedBase, 8);
  });

  test('opname selesai tidak bisa diubah lagi', () async {
    final opname = await service.start(startedAt: testNow);
    await service.recordCount(
      opnameId: opname.id,
      productId: productA,
      countedBase: 10,
      at: testNow,
    );
    await service.finish(opnameId: opname.id, finishedAt: testNow);

    await expectLater(
      service.recordCount(
        opnameId: opname.id,
        productId: productA,
        countedBase: 5,
      ),
      throwsStateError,
    );
    await expectLater(
      service.finish(opnameId: opname.id),
      throwsStateError,
    );
  });

  test('opname tanpa item tidak bisa diselesaikan', () async {
    final opname = await service.start(startedAt: testNow);
    await expectLater(service.finish(opnameId: opname.id), throwsStateError);
  });
}
