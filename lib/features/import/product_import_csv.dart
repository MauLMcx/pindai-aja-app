/// Pembacaan CSV hasil `tools/import_excel.py` (SPEC §14).
///
/// CSV ini sudah dikoreksi manual oleh pemilik sebelum dimuat ke app. Parser
/// tidak menebak: baris tanpa nama dilewati dan dilaporkan.
library;

/// Satu baris produk hasil impor Excel.
class ProductImportRow {
  const ProductImportRow({
    required this.supplier,
    required this.brand,
    required this.name,
    required this.variant,
    required this.category,
    required this.sizeText,
    required this.sizeBaseValue,
    required this.sizeBaseUnit,
    required this.packQty,
    required this.buyPrice,
    required this.oldPrice,
    required this.needsPriceReview,
    required this.reviewReasons,
    required this.sourceSheet,
    required this.sourceRow,
    required this.notes,
  });

  final String supplier;
  final String brand;
  final String name;
  final String variant;
  final String category;
  final String sizeText;
  final int? sizeBaseValue;
  final String sizeBaseUnit;
  final int? packQty;
  final int? buyPrice;
  final int? oldPrice;
  final bool needsPriceReview;
  final String reviewReasons;
  final String sourceSheet;
  final int sourceRow;
  final String notes;

  /// Satuan dasar (SPEC P5): gram, ml, atau pcs bila ukuran tidak diketahui.
  String get baseUnit => sizeBaseUnit.isNotEmpty ? sizeBaseUnit : 'pcs';

  /// Pembelian per dus hanya bila ada ukuran dasar dan isi lebih dari satu.
  bool get buyByPack => (packQty ?? 1) > 1 && sizeBaseValue != null;

  /// Nama satuan yang dipakai saat membeli (dus/pack/satuan ukuran).
  String get purchaseUnitName {
    if (buyByPack) return 'dus isi $packQty';
    if (sizeText.isNotEmpty) return sizeText;
    if (sizeBaseValue != null) return '$sizeBaseValue $baseUnit';
    return baseUnit;
  }

  /// Faktor satuan beli terhadap satuan dasar.
  int get purchaseFactor {
    if (buyByPack) return sizeBaseValue! * packQty!;
    return sizeBaseValue ?? 1;
  }

  /// Satuan jual: eceran per pcs bila dibeli per dus, selain itu satuan beli.
  String get sellUnitName => buyByPack ? 'pcs' : purchaseUnitName;

  /// Faktor satuan jual terhadap satuan dasar.
  int get sellFactor => buyByPack ? sizeBaseValue! : purchaseFactor;

  bool get hasPrice => buyPrice != null;
}

/// Hasil pembacaan satu file CSV.
class ProductCsvResult {
  ProductCsvResult({required this.rows, required this.problems});

  final List<ProductImportRow> rows;

  /// Baris yang dilewati, dalam bahasa sederhana untuk pemilik.
  final List<String> problems;

  int get needsReviewCount =>
      rows.where((r) => r.needsPriceReview || !r.hasPrice).length;
}

/// Membaca CSV menjadi baris produk. Melempar [FormatException] bila kolom
/// wajib (`name`) tidak ada.
ProductCsvResult parseProductCsv(String csv) {
  final records = _splitCsv(csv);
  if (records.isEmpty) {
    throw const FormatException('File CSV kosong.');
  }

  final header = <String, int>{};
  for (var i = 0; i < records.first.length; i++) {
    final key = records.first[i].replaceAll('\uFEFF', '').trim().toLowerCase();
    if (key.isNotEmpty) header.putIfAbsent(key, () => i);
  }
  if (!header.containsKey('name')) {
    throw const FormatException(
      'Kolom "name" tidak ditemukan. Pastikan file berasal dari tools/import_excel.py.',
    );
  }

  final rows = <ProductImportRow>[];
  final problems = <String>[];

  for (var i = 1; i < records.length; i++) {
    final record = records[i];
    String cell(String column) {
      final index = header[column];
      if (index == null || index >= record.length) return '';
      return record[index].trim();
    }

    if (record.every((value) => value.trim().isEmpty)) continue;

    final name = cell('name');
    if (name.isEmpty) {
      problems.add('Baris ${i + 1} dilewati: nama produk kosong.');
      continue;
    }

    final row = ProductImportRow(
      supplier: cell('supplier'),
      brand: cell('brand'),
      name: name,
      variant: cell('variant'),
      category: cell('category'),
      sizeText: cell('size_text'),
      sizeBaseValue: _parseInt(cell('size_base_value')),
      sizeBaseUnit: cell('size_base_unit'),
      packQty: _parseInt(cell('pack_qty')),
      buyPrice: _parseInt(cell('buy_price_idr')),
      oldPrice: _parseInt(cell('old_price_idr')),
      needsPriceReview:
          _parseBool(cell('needs_price_review')) ||
          _parseInt(cell('buy_price_idr')) == null,
      reviewReasons: cell('review_reasons'),
      sourceSheet: cell('source_sheet'),
      sourceRow: _parseInt(cell('source_row')) ?? 0,
      notes: cell('notes'),
    );

    if (row.purchaseFactor <= 0) {
      problems.add(
        'Baris ${i + 1} (${row.name}) dilewati: faktor satuan tidak masuk akal.',
      );
      continue;
    }
    rows.add(row);
  }

  return ProductCsvResult(rows: rows, problems: problems);
}

int? _parseInt(String raw) {
  final cleaned = raw.replaceAll(RegExp(r'[^0-9-]'), '');
  if (cleaned.isEmpty || cleaned == '-') return null;
  return int.tryParse(cleaned);
}

bool _parseBool(String raw) {
  final value = raw.trim().toLowerCase();
  return value == 'true' || value == '1' || value == 'ya';
}

/// Pemisah CSV RFC 4180 sederhana: dukung tanda kutip, koma, dan baris baru di
/// dalam sel. Baris kosong di akhir file diabaikan.
List<List<String>> _splitCsv(String input) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;

  void endField() {
    row.add(field.toString());
    field.clear();
  }

  void endRow() {
    endField();
    rows.add(row);
    row = <String>[];
  }

  var i = 0;
  while (i < input.length) {
    final char = input[i];
    if (inQuotes) {
      if (char == '"') {
        if (i + 1 < input.length && input[i + 1] == '"') {
          field.write('"');
          i += 2;
          continue;
        }
        inQuotes = false;
        i++;
        continue;
      }
      field.write(char);
      i++;
      continue;
    }

    switch (char) {
      case '"':
        inQuotes = true;
        break;
      case ',':
        endField();
        break;
      case '\r':
        break;
      case '\n':
        endRow();
        break;
      default:
        field.write(char);
    }
    i++;
  }

  if (field.isNotEmpty || row.isNotEmpty) endRow();
  return rows;
}
