import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/outbox_writer.dart';
import 'package:petshop_pos/core/sync/sync_api.dart';
import 'package:petshop_pos/core/sync/sync_service.dart';

import '../../support/db_fixture.dart';

class FakeSyncApi implements SyncApi {
  final List<SyncOp> pushed = [];
  final Map<String, List<Map<String, dynamic>>> remote = {};
  List<PushOutcome> Function(List<SyncOp> ops)? onPush;
  bool failNetwork = false;
  int pullCalls = 0;

  @override
  Future<List<PushOutcome>> push(List<SyncOp> ops) async {
    if (failNetwork) throw StateError('offline');
    pushed.addAll(ops);
    if (onPush != null) return onPush!(ops);
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
    pullCalls++;
    final rows = [...?remote[table]]
      ..sort(
        (a, b) => (a['server_seq'] as int).compareTo(b['server_seq'] as int),
      );
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
  late AppDatabase db;
  late FakeSyncApi api;
  late SyncService sync;

  setUp(() async {
    db = await makeTestDb();
    api = FakeSyncApi();
    sync = SyncService(db, api);
  });

  tearDown(() => db.close());

  Future<void> queue({
    String opId = 'op-1',
    String table = 'products',
    String rowId = productA,
    String op = 'update',
  }) {
    return enqueueOutbox(
      db,
      table: table,
      rowId: rowId,
      op: op,
      payload: {'id': rowId, 'store_id': storeId, 'name': 'Nama Baru'},
      at: testNow,
    );
  }

  test('push menandai outbox tersinkron', () async {
    await queue();

    final report = await sync.pushOutbox();

    expect(report.applied, 1);
    expect(report.failed, 0);
    expect(api.pushed.single.table, 'products');
    final row = (await db.select(db.outbox).get()).single;
    expect(row.syncedAt, isNotNull);
    expect(row.lastError, isNull);
  });

  test('op yang di-skip server tetap ditandai tersinkron', () async {
    await queue();
    api.onPush = (ops) => [
      for (final op in ops) PushOutcome(opId: op.opId, status: 'skipped'),
    ];

    final report = await sync.pushOutbox();

    expect(report.skipped, 1);
    expect((await db.select(db.outbox).get()).single.syncedAt, isNotNull);
  });

  test('op ditolak server tetap di antrean dan menambah percobaan', () async {
    await queue();
    api.onPush = (ops) => [
      for (final op in ops)
        PushOutcome(opId: op.opId, status: 'error', error: 'store tidak cocok'),
    ];

    final report = await sync.pushOutbox();

    expect(report.failed, 1);
    final row = (await db.select(db.outbox).get()).single;
    expect(row.syncedAt, isNull);
    expect(row.attempts, 1);
    expect(row.lastError, contains('store tidak cocok'));
  });

  test('gagal jaringan tidak menghilangkan antrean', () async {
    await queue();
    api.failNetwork = true;

    final report = await sync.pushOutbox();

    expect(report.failed, 1);
    expect(report.errors, isNotEmpty);
    final row = (await db.select(db.outbox).get()).single;
    expect(row.syncedAt, isNull);
    expect(row.attempts, 1);
  });

  test('hanya op tanpa synced_at yang dikirim', () async {
    await queue(opId: 'op-1');
    await sync.pushOutbox();
    await queue(opId: 'op-2', rowId: productB);

    final report = await sync.pushOutbox();

    expect(report.applied, 1);
    expect(api.pushed, hasLength(2));
    expect(api.pushed.last.rowId, productB);
  });

  test('pull menyisipkan baris baru dan menyimpan posisi terakhir', () async {
    api.remote['products'] = [
      productRow(id: 'prod-c', name: 'Produk C', serverSeq: 7),
    ];

    final pulled = await sync.pullTable('products');

    expect(pulled, 1);
    final product = await (db.select(
      db.products,
    )..where((t) => t.id.equals('prod-c'))).getSingle();
    expect(product.name, 'Produk C');

    final state = await (db.select(
      db.syncState,
    )..where((t) => t.key.equals('last_seq:products'))).getSingle();
    expect(state.value, '7');

    expect(await sync.pullTable('products'), 0);
  });

  test('pull memperbarui baris lama (last-write-wins)', () async {
    api.remote['products'] = [
      productRow(id: productA, name: 'Nama dari Server', serverSeq: 9),
    ];

    await sync.pullTable('products');

    final product = await (db.select(
      db.products,
    )..where((t) => t.id.equals(productA))).getSingle();
    expect(product.name, 'Nama dari Server');
  });

  test('pull app_settings memakai primary key gabungan', () async {
    api.remote['app_settings'] = [
      {
        'store_id': storeId,
        'key': 'printer',
        'value': 'BT-01',
        'updated_at': '2026-11-18T09:00:00Z',
        'server_seq': 3,
      },
    ];

    await sync.pullTable('app_settings');
    expect(
      (await (db.select(
        db.appSettings,
      )..where((t) => t.key.equals('printer'))).getSingle()).value,
      'BT-01',
    );
  });

  test('pullAll menarik semua tabel dan syncNow push lalu pull', () async {
    await queue();
    api.remote['products'] = [
      productRow(id: productA, name: 'Dari Server', serverSeq: 11),
    ];

    final report = await sync.syncNow();

    expect(report.applied, 1);
    expect(report.pulled, 1);
    expect(report.errors, isEmpty);
    expect(api.pullCalls, syncableTables.length);
    expect(
      (await (db.select(
        db.products,
      )..where((t) => t.id.equals(productA))).getSingle()).name,
      'Dari Server',
    );
  });

  test('tabel di luar daftar ditolak saat pull', () async {
    await expectLater(sync.pullTable('profiles'), throwsArgumentError);
  });
}
