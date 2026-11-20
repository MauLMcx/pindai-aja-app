import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/ledger.dart';
import 'package:petshop_pos/core/store/local_identity.dart';
import 'package:petshop_pos/core/sync/sync_api.dart';
import 'package:petshop_pos/core/sync/sync_service.dart';
import 'package:petshop_pos/features/purchasing/purchase_service.dart';
import 'package:petshop_pos/features/sales/sale_service.dart';

import '../test/support/db_fixture.dart';

/// Transport palsu: tes perangkat tidak menyentuh jaringan atau server nyata.
class FakeSyncApi implements SyncApi {
  final List<SyncOp> pushed = [];
  final Map<String, List<Map<String, dynamic>>> remote = {};
  bool failNetwork = false;

  @override
  Future<List<PushOutcome>> push(List<SyncOp> ops) async {
    if (failNetwork) throw StateError('offline');
    pushed.addAll(ops);
    return [
      for (final op in ops) PushOutcome(opId: op.opId, status: 'applied'),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> pull(
    String table,
    int sinceSeq,
    int limit,
  ) async {
    final rows = [...?remote[table]]
      ..sort((a, b) => (a['server_seq'] as int).compareTo(b['server_seq'] as int));
    return rows
        .where((row) => (row['server_seq'] as int) > sinceSeq)
        .take(limit)
        .toList();
  }
}

Map<String, dynamic> productRow({
  required String id,
  required String name,
  required int serverSeq,
}) {
  return {
    'id': id,
    'store_id': storeId,
    'name': name,
    'brand': null,
    'variant': null,
    'category_id': null,
    'base_unit': 'pcs',
    'min_stock_base': 0,
    'shelf_location': null,
    'main_supplier_id': null,
    'needs_price_review': false,
    'is_active': true,
    'note': null,
    'created_at': '2026-11-18T09:00:00Z',
    'updated_at': '2026-11-18T09:00:00Z',
    'deleted_at': null,
    'device_id': null,
    'server_seq': serverSeq,
  };
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory documents;
  late File dbFile;
  AppDatabase? db;

  Future<AppDatabase> open() async {
    final opened = AppDatabase(NativeDatabase.createInBackground(dbFile));
    db = opened;
    return opened;
  }

  Future<void> closeAndDelete() async {
    await db?.close();
    db = null;
    for (final suffix in ['', '-wal', '-shm']) {
      final file = File('${dbFile.path}$suffix');
      if (await file.exists()) await file.delete();
    }
  }

  setUpAll(() async {
    documents = await getApplicationDocumentsDirectory();
    dbFile = File(p.join(documents.path, 'petshop_device_test.sqlite'));
  });

  setUp(() async {
    await closeAndDelete();
  });

  tearDown(() async {
    await closeAndDelete();
  });

  test('database file nyata dibuat di perangkat dan data bertahan setelah dibuka ulang', () async {
    final first = await open();
    await seedTestDb(first);

    expect(await first.stockBase(productA), 0);
    expect((await first.select(first.products).get()), hasLength(2));
    expect(await dbFile.exists(), isTrue);

    final foreignKeys = await first
        .customSelect('PRAGMA foreign_keys')
        .getSingle();
    expect(foreignKeys.data.values.first, 1);

    final purchases = PurchaseService(
      first,
      storeId: storeId,
      deviceId: deviceId,
    );
    await purchases.create(
      items: const [
        PurchaseItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 10,
          unitCost: 6000,
        ),
      ],
      purchasedAt: testNow,
    );

    final sales = SaleService(
      first,
      storeId: storeId,
      deviceId: deviceId,
      deviceCode: deviceCode,
    );
    await sales.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 3,
          unitPrice: 10000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 30000),
      ],
      soldAt: testNow,
    );

    expect(await first.stockBase(productA), 7);
    expect(await averageCostBaseOf(first, productA), 6000);
    await first.close();
    db = null;

    final second = await open();
    expect(
      (await second.select(second.sales).get()).single.receiptNo,
      'T1-20261118-0001',
    );
    expect(await second.stockBase(productA), 7);
    expect(
      (await second.select(second.stockMovements).get()).where(
        (m) => m.refType == 'sale',
      ),
      hasLength(1),
    );
  });

  test('satu transaksi menulis baris, ledger, dan outbox sekaligus', () async {
    final deviceDb = await open();
    await seedTestDb(deviceDb);

    final sales = SaleService(
      deviceDb,
      storeId: storeId,
      deviceId: deviceId,
      deviceCode: deviceCode,
    );
    final result = await sales.create(
      cashierId: staffId,
      customerId: customerId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 2,
          unitPrice: 10000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 5000),
      ],
      soldAt: testNow,
    );

    expect(result.debtAmount, 15000);
    expect(await debtBalanceOf(deviceDb, customerId), 15000);
    expect(await deviceDb.stockBase(productA), -2);

    final outbox = await deviceDb.select(deviceDb.outbox).get();
    final tables = outbox.map((row) => row.targetTable).toSet();
    expect(
      tables,
      containsAll(<String>[
        'sales',
        'sale_items',
        'payments',
        'stock_movements',
        'debt_ledger',
      ]),
    );
    expect(outbox.every((row) => row.syncedAt == null), isTrue);
    for (final row in outbox) {
      final decoded = jsonDecode(row.payload);
      expect(decoded, isA<Map<String, dynamic>>());
      expect((decoded as Map)['id'], isNotNull);
    }
  });

  test('push menandai outbox dan pull memperbarui produk dari server', () async {
    final deviceDb = await open();
    await seedTestDb(deviceDb);

    final purchases = PurchaseService(
      deviceDb,
      storeId: storeId,
      deviceId: deviceId,
    );
    await purchases.create(
      items: const [
        PurchaseItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 5,
          unitCost: 6000,
        ),
      ],
      purchasedAt: testNow,
    );

    final api = FakeSyncApi();
    final sync = SyncService(deviceDb, api);

    final pushReport = await sync.pushOutbox();
    expect(pushReport.failed, 0);
    expect(pushReport.applied, greaterThan(0));
    expect(api.pushed.map((op) => op.table), contains('stock_movements'));
    expect(
      (await deviceDb.select(deviceDb.outbox).get()).every(
        (row) => row.syncedAt != null,
      ),
      isTrue,
    );

    api.remote['products'] = [
      productRow(id: productA, name: 'Pakan A dari Server', serverSeq: 42),
    ];
    final pulled = await sync.pullTable('products');
    expect(pulled, 1);

    final product = await (deviceDb.select(deviceDb.products)
          ..where((t) => t.id.equals(productA)))
        .getSingle();
    expect(product.name, 'Pakan A dari Server');
    expect(await deviceDb.stockBase(productA), 5);

    final state = await (deviceDb.select(deviceDb.syncState)
          ..where((t) => t.key.equals('last_seq:products')))
        .getSingle();
    expect(state.value, '42');
  });

  test('jaringan mati tidak menghilangkan antrean outbox', () async {
    final deviceDb = await open();
    await seedTestDb(deviceDb);

    await purchasesForTest(deviceDb);
    final api = FakeSyncApi()..failNetwork = true;
    final sync = SyncService(deviceDb, api);

    final report = await sync.pushOutbox();
    expect(report.ok, isFalse);
    expect(report.failed, greaterThan(0));

    final outbox = await deviceDb.select(deviceDb.outbox).get();
    expect(outbox, isNotEmpty);
    expect(outbox.every((row) => row.syncedAt == null), isTrue);
    expect(outbox.every((row) => row.attempts == 1), isTrue);
  });

  test('identitas perangkat lokal dibuat sekali dan bertahan setelah dibuka ulang', () async {
    final first = await open();
    await seedTestDb(first);

    final identity = await ensureLocalIdentity(first, storeId: storeId);
    expect(identity.deviceCode, matches(RegExp(r'^HP[0-9A-F]{6}$')));
    expect(identity.profile.role, UserRole.owner);

    final again = await ensureLocalIdentity(first, storeId: storeId);
    expect(again.deviceId, identity.deviceId);

    await first.close();
    db = null;

    final second = await open();
    final reopened = await ensureLocalIdentity(second, storeId: storeId);
    expect(reopened.deviceId, identity.deviceId);
    expect(reopened.deviceCode, identity.deviceCode);
    expect(await second.select(second.devices).get(), hasLength(1));

    final deviceOps = (await second.select(second.outbox).get())
        .where((row) => row.targetTable == 'devices')
        .toList();
    expect(deviceOps, hasLength(1));
  });

  test('10 transaksi kasir offline: nomor struk naik, stok turun, outbox lengkap', () async {
    final deviceDb = await open();
    await seedTestDb(deviceDb);
    final identity = await ensureLocalIdentity(deviceDb, storeId: storeId);

    final purchases = PurchaseService(
      deviceDb,
      storeId: storeId,
      deviceId: identity.deviceId,
    );
    await purchases.create(
      items: const [
        PurchaseItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 20,
          unitCost: 6000,
        ),
      ],
      purchasedAt: testNow,
    );

    final api = FakeSyncApi()..failNetwork = true;
    final sales = SaleService(
      deviceDb,
      storeId: storeId,
      deviceId: identity.deviceId,
      deviceCode: identity.deviceCode,
    );

    final receiptNos = <String>[];
    for (var index = 0; index < 10; index++) {
      final result = await sales.create(
        cashierId: identity.cashierId,
        items: const [
          SaleDraftItem(
            productId: productA,
            unitId: unitPcsA,
            qty: 1,
            unitPrice: 10000,
          ),
        ],
        payments: const [
          SalePaymentInput(method: PayMethod.cash, amount: 10000),
        ],
        soldAt: testNow,
      );
      receiptNos.add(result.sale.receiptNo);
      expect(result.changeAmount, 0);
    }

    expect(
      receiptNos,
      [
        for (var index = 1; index <= 10; index++)
          '${identity.deviceCode}-20261118-${index.toString().padLeft(4, '0')}',
      ],
    );
    expect(receiptNos.toSet(), hasLength(10));
    expect(await deviceDb.stockBase(productA), 10);

    final saleOutbox = (await deviceDb.select(deviceDb.outbox).get())
        .where((row) => row.targetTable == 'sales')
        .toList();
    expect(saleOutbox, hasLength(10));
    expect(saleOutbox.map((row) => row.opId).toSet(), hasLength(10));
    expect(saleOutbox.every((row) => row.syncedAt == null), isTrue);

    // Semua transaksi tetap tersimpan walau antrean belum bisa dikirim.
    final report = await SyncService(deviceDb, api).pushOutbox();
    expect(report.ok, isFalse);
    expect(await deviceDb.select(deviceDb.sales).get(), hasLength(10));
  });
}

Future<void> purchasesForTest(AppDatabase db) {
  return PurchaseService(db, storeId: storeId, deviceId: deviceId).create(
    items: const [
      PurchaseItemInput(
        productId: productA,
        unitId: unitPcsA,
        qty: 4,
        unitCost: 6000,
      ),
    ],
    purchasedAt: testNow,
  );
}
