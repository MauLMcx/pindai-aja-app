import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/store/local_store.dart';
import 'package:petshop_pos/features/import/product_importer.dart';

const _header =
    'supplier,brand,name,variant,category,size_text,size_base_value,'
    'size_base_unit,pack_qty,buy_price_idr,old_price_idr,needs_price_review,'
    'review_reasons,source_sheet,source_row,notes';

List<String> _row({
  required String name,
  String sizeText = '',
  String sizeValue = '',
  String sizeUnit = '',
  String packQty = '',
  String price = '',
  String needsReview = 'False',
  String category = 'Pasir',
  String sourceRow = '1',
}) => [
  'Bintang Petshop',
  '',
  name,
  '',
  category,
  sizeText,
  sizeValue,
  sizeUnit,
  packQty,
  price,
  '',
  needsReview,
  '',
  'Bintang Petshop',
  sourceRow,
  '',
];

String _csv() => [
  _header,
  _row(
    name: 'Tayo',
    sizeText: '3 liter, isi 10',
    sizeValue: '3000',
    sizeUnit: 'ml',
    packQty: '10',
    price: '140000',
    needsReview: 'True',
    sourceRow: '12',
  ).map((value) => value.contains(',') ? '"$value"' : value).join(','),
  _row(name: 'Aice Adult', sourceRow: '13').join(','),
].join('\r\n');

void main() {
  late AppDatabase db;
  late Store store;

  setUp(() async {
    db = AppDatabase.memory();
    store = await ensureLocalStore(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('impor menyimpan produk, satuan, harga beli, dan outbox', () async {
    final outcome = await importProductCsvText(
      db,
      storeId: store.id,
      csv: _csv(),
      at: DateTime.utc(2026, 11, 17, 10),
    );

    expect(outcome.inserted, 2);
    expect(outcome.skippedExisting, 0);
    expect(outcome.needsReview, 2);
    expect(outcome.newSuppliers, 1);
    expect(outcome.newCategories, 1);
    expect(outcome.problems, isEmpty);

    expect(await db.select(db.products).get(), hasLength(2));
    expect(await db.select(db.suppliers).get(), hasLength(1));
    expect(await db.select(db.categories).get(), hasLength(1));

    final tayo = await (db.select(
      db.products,
    )..where((t) => t.name.equals('Tayo'))).getSingle();
    expect(tayo.baseUnit, 'ml');
    expect(tayo.needsPriceReview, isTrue);

    final units = await (db.select(
      db.productUnits,
    )..where((t) => t.productId.equals(tayo.id))).get();
    expect(units, hasLength(2));

    final sell = units.singleWhere((u) => u.isDefaultSale);
    expect(sell.unitName, 'pcs');
    expect(sell.factorToBase, 3000);

    final buy = units.singleWhere((u) => u.isDefaultPurchase);
    expect(buy.unitName, 'dus isi 10');
    expect(buy.factorToBase, 30000);

    final price = await (db.select(
      db.priceHistory,
    )..where((t) => t.productUnitId.equals(buy.id))).getSingle();
    expect(price.kind, PriceKind.buy);
    expect(price.price, 140000);

    // Stok tidak diambil dari file harga (SPEC §14.9).
    expect(await db.stockBase(tayo.id), 0);

    final outbox = await db.select(db.outbox).get();
    expect(outbox, isNotEmpty);
    expect(outbox.every((row) => row.syncedAt == null), isTrue);
  });

  test(
    'impor kedua tidak membuat duplikat dan tidak menambah outbox',
    () async {
      final first = await importProductCsvText(
        db,
        storeId: store.id,
        csv: _csv(),
      );
      final outboxAfterFirst = (await db.select(db.outbox).get()).length;
      final productsAfterFirst = (await db.select(db.products).get()).length;
      final unitsAfterFirst = (await db.select(db.productUnits).get()).length;

      final second = await importProductCsvText(
        db,
        storeId: store.id,
        csv: _csv(),
      );

      expect(first.inserted, 2);
      expect(second.inserted, 0);
      expect(second.skippedExisting, 2);
      expect(
        (await db.select(db.products).get()),
        hasLength(productsAfterFirst),
      );
      expect(
        (await db.select(db.productUnits).get()),
        hasLength(unitsAfterFirst),
      );
      expect((await db.select(db.outbox).get()).length, outboxAfterFirst);
    },
  );

  test('baris bermasalah dilaporkan tanpa membatalkan baris lain', () async {
    final csv = [
      _header,
      _row(name: 'Tayo').join(','),
      _row(name: '').join(','),
    ].join('\r\n');

    final outcome = await importProductCsvText(db, storeId: store.id, csv: csv);

    expect(outcome.inserted, 1);
    expect(outcome.problems, hasLength(1));
    expect(await db.select(db.products).get(), hasLength(1));
  });
}
