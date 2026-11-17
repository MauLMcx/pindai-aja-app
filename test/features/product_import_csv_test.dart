import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/features/import/product_import_csv.dart';

const _header =
    'supplier,brand,name,variant,category,size_text,size_base_value,'
    'size_base_unit,pack_qty,buy_price_idr,old_price_idr,needs_price_review,'
    'review_reasons,source_sheet,source_row,notes';

String _line(List<String> fields) {
  final cells = fields.map((value) {
    if (value.contains(',') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  });
  return cells.join(',');
}

String _csv(List<List<String>> rows) =>
    [_header, ...rows.map(_line)].join('\r\n');

List<String> _row({
  String name = 'Tayo',
  String supplier = 'Bintang Petshop',
  String brand = '',
  String variant = '',
  String category = 'Pasir',
  String sizeText = '3 liter, isi 10',
  String sizeValue = '3000',
  String sizeUnit = 'ml',
  String packQty = '10',
  String price = '140000',
  String needsReview = 'True',
  String reasons = 'catatan: coret',
  String notes = 'baris "kutip"',
  String sourceRow = '12',
}) => [
  supplier,
  brand,
  name,
  variant,
  category,
  sizeText,
  sizeValue,
  sizeUnit,
  packQty,
  price,
  '',
  needsReview,
  reasons,
  'Bintang Petshop',
  sourceRow,
  notes,
];

void main() {
  test('membaca CSV: kutip, koma di dalam sel, dan baris baru CRLF', () {
    final result = parseProductCsv(_csv([_row()]));

    expect(result.problems, isEmpty);
    final row = result.rows.single;
    expect(row.name, 'Tayo');
    expect(row.category, 'Pasir');
    expect(row.sizeText, '3 liter, isi 10');
    expect(row.notes, 'baris "kutip"');
    expect(row.buyPrice, 140000);
    expect(row.needsPriceReview, isTrue);
  });

  test('satuan: dibeli per dus, dijual per pcs', () {
    final row = parseProductCsv(_csv([_row()])).rows.single;

    expect(row.baseUnit, 'ml');
    expect(row.buyByPack, isTrue);
    expect(row.purchaseUnitName, 'dus isi 10');
    expect(row.purchaseFactor, 30000);
    expect(row.sellUnitName, 'pcs');
    expect(row.sellFactor, 3000);
  });

  test('tanpa ukuran memakai satuan pcs dengan faktor 1', () {
    final row = parseProductCsv(
      _csv([
        _row(
          name: 'Aice Adult',
          category: 'Harga naik',
          sizeText: '',
          sizeValue: '',
          sizeUnit: '',
          packQty: '',
          price: '',
          needsReview: 'False',
          reasons: 'tulisan kurang jelas',
        ),
      ]),
    ).rows.single;

    expect(row.baseUnit, 'pcs');
    expect(row.buyByPack, isFalse);
    expect(row.purchaseUnitName, 'pcs');
    expect(row.purchaseFactor, 1);
    expect(row.hasPrice, isFalse);
    // Harga kosong tetap harus dicek walau kolom flag di CSV keliru.
    expect(row.needsPriceReview, isTrue);
  });

  test('baris tanpa nama dilewati dan dilaporkan', () {
    final result = parseProductCsv(
      _csv([_row(name: 'Tayo'), _row(name: '', sourceRow: '99')]),
    );

    expect(result.rows, hasLength(1));
    expect(result.problems.single, contains('nama produk kosong'));
  });

  test('header name wajib ada', () {
    expect(
      () => parseProductCsv('supplier,brand\r\nBintang,Tayo\r\n'),
      throwsA(isA<FormatException>()),
    );
  });

  test('BOM di awal file tidak merusak nama kolom', () {
    final result = parseProductCsv('\uFEFF${_csv([_row()])}');
    expect(result.rows.single.name, 'Tayo');
  });
}
