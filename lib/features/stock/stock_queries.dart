import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import 'stock_math.dart';

/// Satu baris daftar stok: produk + stok buku + stok minimum + rak.
class StockRow {
  const StockRow({
    required this.productId,
    required this.name,
    required this.baseUnit,
    required this.stockBase,
    required this.minStockBase,
    this.brand,
    this.variant,
    this.shelfLocation,
    this.supplierId,
    this.supplierName,
    this.barcodes = const [],
  });

  final String productId;
  final String name;
  final String baseUnit;
  final int stockBase;
  final int minStockBase;
  final String? brand;
  final String? variant;
  final String? shelfLocation;
  final String? supplierId;
  final String? supplierName;

  /// Barcode semua satuan aktif, untuk pencarian di layar stok.
  final List<String> barcodes;

  bool get isLow => minStockBase > 0 && stockBase < minStockBase;
  int get shortfallBase => isLow ? minStockBase - stockBase : 0;

  String get displayName => variant == null ? name : '$name ($variant)';
}

/// Produk di bawah stok minimum, dikelompokkan per pemasok utama (SPEC §6.7).
class LowStockGroup {
  const LowStockGroup({
    required this.supplierId,
    required this.supplierName,
    required this.rows,
  });

  final String? supplierId;
  final String supplierName;
  final List<StockRow> rows;
}

class UnitChoice {
  const UnitChoice({
    required this.id,
    required this.name,
    required this.factorToBase,
    required this.isDefaultSale,
    required this.isDefaultPurchase,
    this.sellPrice,
    this.barcode,
  });

  final String id;
  final String name;
  final int factorToBase;
  final bool isDefaultSale;
  final bool isDefaultPurchase;
  final int? sellPrice;
  final String? barcode;
}

class ProductChoice {
  const ProductChoice({
    required this.id,
    required this.name,
    required this.baseUnit,
    required this.stockBase,
    required this.minStockBase,
    required this.units,
    this.brand,
    this.variant,
    this.shelfLocation,
  });

  final String id;
  final String name;
  final String baseUnit;
  final int stockBase;
  final int minStockBase;
  final List<UnitChoice> units;
  final String? brand;
  final String? variant;
  final String? shelfLocation;

  String get displayName => variant == null ? name : '$name ($variant)';

  UnitChoice? get defaultPurchaseUnit {
    for (final unit in units) {
      if (unit.isDefaultPurchase) return unit;
    }
    return units.isEmpty ? null : units.last;
  }

  UnitChoice? get defaultSaleUnit {
    for (final unit in units) {
      if (unit.isDefaultSale) return unit;
    }
    return units.isEmpty ? null : units.first;
  }
}

class PriceHistoryRow {
  const PriceHistoryRow({
    required this.id,
    required this.unitName,
    required this.kind,
    required this.price,
    required this.effectiveAt,
    this.sourceRef,
  });

  final String id;
  final String unitName;
  final PriceKind kind;
  final int price;
  final DateTime effectiveAt;
  final String? sourceRef;
}

class PurchaseSummary {
  const PurchaseSummary({
    required this.id,
    required this.purchasedAt,
    required this.total,
    this.docNo,
    this.supplierName,
  });

  final String id;
  final DateTime purchasedAt;
  final int total;
  final String? docNo;
  final String? supplierName;

  String get label {
    final parts = [?docNo, ?supplierName];
    final head = parts.isEmpty ? 'Pembelian' : parts.join(' • ');
    return '$head • ${purchasedAt.toLocal().toString().substring(0, 16)}';
  }
}

class SaleSummary {
  const SaleSummary({
    required this.id,
    required this.receiptNo,
    required this.soldAt,
    required this.total,
  });

  final String id;
  final String receiptNo;
  final DateTime soldAt;
  final int total;

  String get label =>
      '$receiptNo • ${soldAt.toLocal().toString().substring(0, 16)}';
}

class OpnameSummary {
  const OpnameSummary({
    required this.id,
    required this.startedAt,
    required this.status,
    required this.itemCount,
    this.finishedAt,
    this.scope,
  });

  final String id;
  final DateTime startedAt;
  final OpnameStatus status;
  final int itemCount;
  final DateTime? finishedAt;
  final String? scope;

  bool get isOpen => status == OpnameStatus.open;
}

/// Satu baris riwayat penataan barang, untuk ditampilkan di layar Susun Barang.
class PutawayHistoryRow {
  const PutawayHistoryRow({
    required this.productName,
    required this.occurredAt,
    this.fromLocation,
    this.toLocation,
  });

  final String productName;
  final DateTime occurredAt;
  final String? fromLocation;
  final String? toLocation;
}

/// Satu baris dokumen yang bisa diretur, beserta sisa jumlah yang belum diretur.
class ReturnableLine {
  const ReturnableLine({
    required this.productId,
    required this.productName,
    required this.unitId,
    required this.unitName,
    required this.qty,
    required this.qtyBase,
    required this.unitPrice,
    required this.docAmount,
    required this.returnedBase,
    this.costPerBase,
  });

  final String productId;
  final String productName;
  final String unitId;
  final String unitName;
  final int qty;
  final int qtyBase;

  /// Harga per satuan pada dokumen asal (pembelian: harga beli; penjualan:
  /// harga jual rata-rata baris).
  final int unitPrice;

  /// Nilai uang baris pada dokumen asal. Dipakai sebagai dasar nominal refund.
  final int docAmount;

  final int returnedBase;

  /// Snapshot HPP per satuan dasar (dari baris penjualan/pembelian asal).
  final double? costPerBase;

  int get remainingBase => qtyBase - returnedBase;
  bool get canReturn => remainingBase > 0;
}

StockRow _mapStockRow(QueryRow row) => StockRow(
  productId: row.read<String>('product_id'),
  name: row.read<String>('name'),
  baseUnit: row.read<String>('base_unit'),
  stockBase: row.read<int>('stock_base'),
  minStockBase: row.read<int>('min_stock_base'),
  brand: row.readNullable<String>('brand'),
  variant: row.readNullable<String>('variant'),
  shelfLocation: row.readNullable<String>('shelf_location'),
  supplierId: row.readNullable<String>('supplier_id'),
  supplierName: row.readNullable<String>('supplier_name'),
  barcodes: (row.readNullable<String>('barcodes') ?? '')
      .split('|')
      .where((barcode) => barcode.trim().isNotEmpty)
      .toList(),
);

const _stockSelect = '''
select p.id as product_id,
       p.name as name,
       p.brand as brand,
       p.variant as variant,
       p.base_unit as base_unit,
       p.min_stock_base as min_stock_base,
       p.shelf_location as shelf_location,
       p.main_supplier_id as supplier_id,
       s.name as supplier_name,
       (select group_concat(u.barcode, '|') from product_units u
         where u.product_id = p.id and u.deleted_at is null) as barcodes,
       coalesce(sum(m.qty_base_delta), 0) as stock_base
from products p
left join stock_movements m on m.product_id = p.id
left join suppliers s on s.id = p.main_supplier_id
where p.deleted_at is null and p.is_active = 1
''';

/// Daftar stok semua produk aktif. `search` mencocokkan nama, merek, varian,
/// atau barcode satuan. Bisa dibatasi per lokasi rak atau nama kategori
/// (dipakai cakupan opname, SPEC §6.8).
Future<List<StockRow>> loadStockRows(
  AppDatabase db, {
  String? search,
  bool lowOnly = false,
  String? shelfLocation,
  String? categoryName,
}) async {
  final term = search?.trim() ?? '';
  final variables = <Variable<Object>>[];
  var where = '';

  if (term.isNotEmpty) {
    final like = '%$term%';
    where = '''
  and (p.name like ? or coalesce(p.brand, '') like ? or coalesce(p.variant, '') like ?
       or exists (select 1 from product_units u
                  where u.product_id = p.id and u.deleted_at is null
                    and coalesce(u.barcode, '') like ?))
''';
    variables.addAll(List<Variable<Object>>.filled(4, Variable<String>(like)));
  }

  final shelf = shelfLocation?.trim() ?? '';
  if (shelf.isNotEmpty) {
    where += '\n  and p.shelf_location = ? ';
    variables.add(Variable<String>(shelf));
  }

  final category = categoryName?.trim() ?? '';
  if (category.isNotEmpty) {
    where += '''
  and p.category_id in (select c.id from categories c
                        where c.deleted_at is null and c.name = ?)
''';
    variables.add(Variable<String>(category));
  }

  final having = lowOnly
      ? 'having p.min_stock_base > 0 '
            'and coalesce(sum(m.qty_base_delta), 0) < p.min_stock_base '
      : '';

  final rows = await db
      .customSelect(
        '$_stockSelect$where'
        'group by p.id\n'
        '$having'
        'order by ${lowOnly ? 'supplier_name, ' : ''}p.name collate nocase',
        variables: variables,
        readsFrom: {
          db.products,
          db.stockMovements,
          db.suppliers,
          db.productUnits,
        },
      )
      .get();

  return rows.map(_mapStockRow).toList();
}

/// Produk di bawah stok minimum, dikelompokkan per pemasok utama.
Future<List<LowStockGroup>> loadLowStockGroups(AppDatabase db) async {
  final rows = await loadStockRows(db, lowOnly: true);
  final groups = <String, List<StockRow>>{};
  for (final row in rows) {
    groups.putIfAbsent(row.supplierId ?? '', () => []).add(row);
  }

  final result = <LowStockGroup>[];
  for (final entry in groups.entries) {
    final items = entry.value;
    result.add(
      LowStockGroup(
        supplierId: entry.key.isEmpty ? null : entry.key,
        supplierName: items.first.supplierName ?? 'Tanpa pemasok',
        rows: items,
      ),
    );
  }
  result.sort((a, b) => a.supplierName.compareTo(b.supplierName));
  return result;
}

/// HPP rata-rata bergerak saat ini, dihitung ulang dari ledger (SPEC §6.2).
Future<double> movingAverageCostBase(AppDatabase db, String productId) async {
  final rows = await db
      .customSelect(
        'select qty_base_delta, type, cost_per_base from stock_movements '
        'where product_id = ? order by occurred_at asc, rowid asc',
        variables: [Variable<String>(productId)],
        readsFrom: {db.stockMovements},
      )
      .get();

  final movements = rows.map(
    (row) => CostMovement(
      qtyBaseDelta: row.read<int>('qty_base_delta'),
      type: const MovementTypeConverter().fromSql(row.read<String>('type')),
      costPerBase: row.readNullable<double>('cost_per_base'),
    ),
  );

  return replayMovingAverage(movements).avgCostPerBase;
}

/// Nilai persediaan seluruh produk aktif, memakai HPP rata-rata per produk.
Future<int> totalInventoryValue(AppDatabase db) async {
  final balances = await db
      .customSelect(
        'select product_id, sum(qty_base_delta) as qty_base '
        'from stock_movements group by product_id',
        readsFrom: {db.stockMovements},
      )
      .get();

  var total = 0;
  for (final row in balances) {
    final qty = row.read<int>('qty_base');
    if (qty <= 0) continue;
    final avg = await movingAverageCostBase(db, row.read<String>('product_id'));
    total += inventoryValueRupiah(qty, avg);
  }
  return total;
}

/// Produk + satuannya, untuk pemilih produk di layar transaksi.
Future<List<ProductChoice>> loadProductChoices(
  AppDatabase db, {
  String? search,
  int limit = 300,
  String? shelfLocation,
  String? categoryName,
}) async {
  final rows = await loadStockRows(
    db,
    search: search,
    shelfLocation: shelfLocation,
    categoryName: categoryName,
  );
  final selected = rows.take(limit).toList();
  if (selected.isEmpty) return const [];

  final ids = {for (final row in selected) row.productId};
  final unitRows = await db
      .customSelect(
        'select id, product_id, unit_name, factor_to_base, sell_price, '
        'is_default_sale, is_default_purchase, barcode '
        'from product_units where deleted_at is null '
        'order by factor_to_base asc, unit_name collate nocase',
        readsFrom: {db.productUnits},
      )
      .get();

  final unitsByProduct = <String, List<UnitChoice>>{};
  for (final row in unitRows) {
    final productId = row.read<String>('product_id');
    if (!ids.contains(productId)) continue;
    unitsByProduct
        .putIfAbsent(productId, () => [])
        .add(
          UnitChoice(
            id: row.read<String>('id'),
            name: row.read<String>('unit_name'),
            factorToBase: row.read<int>('factor_to_base'),
            isDefaultSale: row.read<int>('is_default_sale') != 0,
            isDefaultPurchase: row.read<int>('is_default_purchase') != 0,
            sellPrice: row.readNullable<int>('sell_price'),
            barcode: row.readNullable<String>('barcode'),
          ),
        );
  }

  return selected
      .map(
        (row) => ProductChoice(
          id: row.productId,
          name: row.name,
          baseUnit: row.baseUnit,
          stockBase: row.stockBase,
          minStockBase: row.minStockBase,
          brand: row.brand,
          variant: row.variant,
          shelfLocation: row.shelfLocation,
          units: unitsByProduct[row.productId] ?? const [],
        ),
      )
      .toList();
}

/// Riwayat harga satu produk, terbaru di atas (SPEC §6.2).
Future<List<PriceHistoryRow>> loadPriceHistory(
  AppDatabase db,
  String productId,
) async {
  final rows = await db
      .customSelect(
        'select ph.id, ph.kind, ph.price, ph.effective_at, ph.source_ref, '
        'pu.unit_name '
        'from price_history ph '
        'join product_units pu on pu.id = ph.product_unit_id '
        'where pu.product_id = ? '
        'order by ph.effective_at desc, ph.created_at desc',
        variables: [Variable<String>(productId)],
        readsFrom: {db.priceHistory, db.productUnits},
      )
      .get();

  return rows
      .map(
        (row) => PriceHistoryRow(
          id: row.read<String>('id'),
          unitName: row.read<String>('unit_name'),
          kind: PriceKind.values.byName(row.read<String>('kind')),
          price: row.read<int>('price'),
          effectiveAt: row.read<DateTime>('effective_at'),
          sourceRef: row.readNullable<String>('source_ref'),
        ),
      )
      .toList();
}

/// Harga beli terakhir yang tercatat untuk satu satuan.
Future<int?> lastBuyPrice(AppDatabase db, String unitId) async {
  final row =
      await (db.select(db.priceHistory)
            ..where(
              (t) =>
                  t.productUnitId.equals(unitId) &
                  t.kind.equalsValue(PriceKind.buy),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.effectiveAt)])
            ..limit(1))
          .getSingleOrNull();
  return row?.price;
}

/// Daftar pembelian terakhir, untuk dokumen sumber retur pembelian.
Future<List<PurchaseSummary>> loadPurchaseSummaries(
  AppDatabase db, {
  int limit = 100,
}) async {
  final rows = await db
      .customSelect(
        'select pu.id, pu.purchased_at, pu.total, pu.doc_no, s.name as supplier_name '
        'from purchases pu '
        'left join suppliers s on s.id = pu.supplier_id '
        'where pu.deleted_at is null '
        'order by pu.purchased_at desc limit ?',
        variables: [Variable<int>(limit)],
        readsFrom: {db.purchases, db.suppliers},
      )
      .get();

  return rows
      .map(
        (row) => PurchaseSummary(
          id: row.read<String>('id'),
          purchasedAt: row.read<DateTime>('purchased_at'),
          total: row.read<int>('total'),
          docNo: row.readNullable<String>('doc_no'),
          supplierName: row.readNullable<String>('supplier_name'),
        ),
      )
      .toList();
}

/// Daftar penjualan selesai, untuk dokumen sumber retur penjualan.
Future<List<SaleSummary>> loadSaleSummaries(
  AppDatabase db, {
  int limit = 100,
}) async {
  final rows = await db
      .customSelect(
        "select id, receipt_no, sold_at, total from sales "
        "where deleted_at is null and status = 'completed' "
        'order by sold_at desc limit ?',
        variables: [Variable<int>(limit)],
        readsFrom: {db.sales},
      )
      .get();

  return rows
      .map(
        (row) => SaleSummary(
          id: row.read<String>('id'),
          receiptNo: row.read<String>('receipt_no'),
          soldAt: row.read<DateTime>('sold_at'),
          total: row.read<int>('total'),
        ),
      )
      .toList();
}

Future<List<OpnameSummary>> loadOpnameSummaries(AppDatabase db) async {
  final rows = await db
      .customSelect(
        'select o.id, o.started_at, o.finished_at, o.status, o.scope, '
        '(select count(*) from stock_opname_items i '
        ' where i.opname_id = o.id and i.deleted_at is null) as item_count '
        'from stock_opnames o '
        'where o.deleted_at is null '
        'order by o.started_at desc limit 50',
        readsFrom: {db.stockOpnames, db.stockOpnameItems},
      )
      .get();

  return rows
      .map(
        (row) => OpnameSummary(
          id: row.read<String>('id'),
          startedAt: row.read<DateTime>('started_at'),
          finishedAt: row.readNullable<DateTime>('finished_at'),
          status: OpnameStatus.values.byName(row.read<String>('status')),
          scope: row.readNullable<String>('scope'),
          itemCount: row.read<int>('item_count'),
        ),
      )
      .toList();
}

/// Baris pembelian yang masih bisa diretur ke pemasok.
Future<List<ReturnableLine>> loadReturnablePurchaseLines(
  AppDatabase db,
  String purchaseId,
) async {
  final rows = await db
      .customSelect(
        'select pi.product_id, p.name as product_name, pi.unit_id, '
        'pu.unit_name, pi.qty, pi.qty_base, pi.unit_cost, pi.cost_per_base, '
        'coalesce((select sum(ri.qty_base) from return_items ri '
        '  join returns r on r.id = ri.return_id '
        '  where r.purchase_id = ? and r.deleted_at is null '
        '    and ri.deleted_at is null '
        '    and ri.product_id = pi.product_id '
        '    and ri.unit_id = pi.unit_id), 0) as returned_base '
        'from purchase_items pi '
        'join products p on p.id = pi.product_id '
        'join product_units pu on pu.id = pi.unit_id '
        'where pi.purchase_id = ? and pi.deleted_at is null',
        variables: [Variable<String>(purchaseId), Variable<String>(purchaseId)],
        readsFrom: {
          db.purchaseItems,
          db.products,
          db.productUnits,
          db.returnItems,
          db.returns,
        },
      )
      .get();

  return rows
      .map(
        (row) => ReturnableLine(
          productId: row.read<String>('product_id'),
          productName: row.read<String>('product_name'),
          unitId: row.read<String>('unit_id'),
          unitName: row.read<String>('unit_name'),
          qty: row.read<int>('qty'),
          qtyBase: row.read<int>('qty_base'),
          unitPrice: row.read<int>('unit_cost'),
          docAmount: row.read<int>('qty') * row.read<int>('unit_cost'),
          returnedBase: row.read<int>('returned_base'),
          costPerBase: row.readNullable<double>('cost_per_base'),
        ),
      )
      .toList();
}

/// Baris penjualan yang masih bisa diretur pelanggan.
Future<List<ReturnableLine>> loadReturnableSaleLines(
  AppDatabase db,
  String saleId,
) async {
  final rows = await db
      .customSelect(
        'select si.product_id, p.name as product_name, si.unit_id, '
        'pu.unit_name, si.qty, si.qty_base, si.line_total, si.cost_per_base, '
        'coalesce((select sum(ri.qty_base) from return_items ri '
        '  join returns r on r.id = ri.return_id '
        '  where r.sale_id = ? and r.deleted_at is null '
        '    and ri.deleted_at is null '
        '    and ri.product_id = si.product_id '
        '    and ri.unit_id = si.unit_id), 0) as returned_base '
        'from sale_items si '
        'join products p on p.id = si.product_id '
        'join product_units pu on pu.id = si.unit_id '
        'where si.sale_id = ? and si.deleted_at is null',
        variables: [Variable<String>(saleId), Variable<String>(saleId)],
        readsFrom: {
          db.saleItems,
          db.products,
          db.productUnits,
          db.returnItems,
          db.returns,
        },
      )
      .get();

  return rows
      .map(
        (row) => ReturnableLine(
          productId: row.read<String>('product_id'),
          productName: row.read<String>('product_name'),
          unitId: row.read<String>('unit_id'),
          unitName: row.read<String>('unit_name'),
          qty: row.read<int>('qty'),
          qtyBase: row.read<int>('qty_base'),
          unitPrice: row.read<int>('qty') == 0
              ? row.read<int>('line_total')
              : row.read<int>('line_total') ~/ row.read<int>('qty'),
          docAmount: row.read<int>('line_total'),
          returnedBase: row.read<int>('returned_base'),
          costPerBase: row.readNullable<double>('cost_per_base'),
        ),
      )
      .toList();
}

/// Riwayat penataan barang terbaru.
Future<List<PutawayHistoryRow>> loadPutawayHistory(
  AppDatabase db, {
  int limit = 20,
}) async {
  final rows = await db
      .customSelect(
        'select p.name as product_name, l.from_location, l.to_location, '
        'l.occurred_at '
        'from putaway_log l '
        'join products p on p.id = l.product_id '
        'order by l.occurred_at desc limit ?',
        variables: [Variable<int>(limit)],
        readsFrom: {db.putawayLog, db.products},
      )
      .get();

  return rows
      .map(
        (row) => PutawayHistoryRow(
          productName: row.read<String>('product_name'),
          fromLocation: row.readNullable<String>('from_location'),
          toLocation: row.readNullable<String>('to_location'),
          occurredAt: row.read<DateTime>('occurred_at'),
        ),
      )
      .toList();
}

/// Pilihan cakupan opname: seluruh toko, per rak, atau per kategori
/// (SPEC §6.8). Label disimpan apa adanya di `stock_opnames.scope`.
class OpnameScopeOption {
  const OpnameScopeOption(this.label, {this.shelfLocation, this.categoryName});

  final String label;
  final String? shelfLocation;
  final String? categoryName;

  bool get isWholeStore => shelfLocation == null && categoryName == null;
}

/// Daftar rak dan kategori yang bisa dipakai sebagai cakupan opname.
Future<List<OpnameScopeOption>> loadOpnameScopeOptions(AppDatabase db) async {
  final options = <OpnameScopeOption>[const OpnameScopeOption('Seluruh toko')];

  final shelves = await db
      .customSelect(
        'select distinct trim(shelf_location) as shelf from products '
        'where deleted_at is null and shelf_location is not null '
        "and trim(shelf_location) <> '' order by shelf collate nocase",
        readsFrom: {db.products},
      )
      .get();
  for (final row in shelves) {
    final shelf = row.read<String>('shelf');
    options.add(OpnameScopeOption(shelf, shelfLocation: shelf));
  }

  final categories =
      await (db.select(db.categories)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();
  for (final category in categories) {
    options.add(
      OpnameScopeOption(
        'Kategori ${category.name}',
        categoryName: category.name,
      ),
    );
  }

  return options;
}

/// Menerjemahkan teks cakupan tersimpan menjadi filter produk.
OpnameScopeOption parseOpnameScope(String? scope) {
  final text = scope?.trim() ?? '';
  if (text.startsWith('Rak ') && text.length > 4) {
    return OpnameScopeOption(text, shelfLocation: text);
  }
  if (text.startsWith('Kategori ')) {
    return OpnameScopeOption(text, categoryName: text.substring(9).trim());
  }
  return const OpnameScopeOption('Seluruh toko');
}
