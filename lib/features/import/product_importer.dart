import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';
import 'product_import_csv.dart';

/// Ringkasan hasil impor, dalam angka yang bisa dibaca pemilik.
class ImportOutcome {
  const ImportOutcome({
    required this.inserted,
    required this.skippedExisting,
    required this.needsReview,
    required this.newSuppliers,
    required this.newCategories,
    required this.problems,
  });

  final int inserted;
  final int skippedExisting;
  final int needsReview;
  final int newSuppliers;
  final int newCategories;
  final List<String> problems;
}

/// Membaca CSV lalu menyimpannya ke database lokal.
Future<ImportOutcome> importProductCsvText(
  AppDatabase db, {
  required String storeId,
  required String csv,
  DateTime? at,
}) {
  return importProductRows(
    db,
    storeId: storeId,
    parsed: parseProductCsv(csv),
    at: at,
  );
}

/// Menyimpan baris produk dalam SATU transaksi bersama outbox (SPEC P1).
///
/// ID produk deterministik, jadi mengimpor file yang sama dua kali hanya
/// menghasilkan "dilewati" dan tidak membuat duplikat.
Future<ImportOutcome> importProductRows(
  AppDatabase db, {
  required String storeId,
  required ProductCsvResult parsed,
  DateTime? at,
}) async {
  final now = (at ?? DateTime.now()).toUtc();
  final problems = <String>[...parsed.problems];
  var inserted = 0;
  var skipped = 0;
  var needsReview = 0;
  var newSuppliers = 0;
  var newCategories = 0;

  await db.transaction(() async {
    for (final row in parsed.rows) {
      final productId = stableId(
        'product',
        '$storeId|${row.brand}|${row.name}|${row.variant}|${row.sizeText}|${row.category}',
      );

      final existing = await (db.select(
        db.products,
      )..where((t) => t.id.equals(productId))).getSingleOrNull();
      if (existing != null) {
        skipped++;
        continue;
      }

      final supplier = await _ensureSupplier(db, storeId, row.supplier, now);
      if (supplier.created) newSuppliers++;
      final category = await _ensureCategory(db, storeId, row.category, now);
      if (category.created) newCategories++;

      final reviewFlag = row.needsPriceReview || !row.hasPrice;
      final note = [
        row.notes,
        row.reviewReasons,
      ].where((text) => text.isNotEmpty).join(' • ');

      await db
          .into(db.products)
          .insert(
            ProductsCompanion.insert(
              id: productId,
              storeId: storeId,
              name: row.name,
              brand: Value(row.brand.isEmpty ? null : row.brand),
              variant: Value(row.variant.isEmpty ? null : row.variant),
              categoryId: Value(category.id),
              baseUnit: row.baseUnit,
              mainSupplierId: Value(supplier.id),
              needsPriceReview: Value(reviewFlag),
              note: Value(note.isEmpty ? null : note),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await enqueueOutbox(
        db,
        table: 'products',
        rowId: productId,
        op: 'insert',
        payload: {
          'id': productId,
          'store_id': storeId,
          'name': row.name,
          'brand': row.brand.isEmpty ? null : row.brand,
          'variant': row.variant.isEmpty ? null : row.variant,
          'category_id': category.id,
          'base_unit': row.baseUnit,
          'main_supplier_id': supplier.id,
          'min_stock_base': 0,
          'needs_price_review': reviewFlag,
          'is_active': true,
          'note': note.isEmpty ? null : note,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
        at: now,
      );

      // Bila dibeli per dus: satu satuan jual (pcs) + satu satuan beli (dus).
      final units = row.buyByPack
          ? [
              _UnitSpec(
                name: row.sellUnitName,
                factor: row.sellFactor,
                defaultSale: true,
                defaultPurchase: false,
              ),
              _UnitSpec(
                name: row.purchaseUnitName,
                factor: row.purchaseFactor,
                defaultSale: false,
                defaultPurchase: true,
              ),
            ]
          : [
              _UnitSpec(
                name: row.purchaseUnitName,
                factor: row.purchaseFactor,
                defaultSale: true,
                defaultPurchase: true,
              ),
            ];

      String? purchaseUnitId;
      for (final unit in units) {
        final unitId = stableId('product_unit', '$productId|${unit.name}');
        if (unit.defaultPurchase) purchaseUnitId = unitId;
        await db
            .into(db.productUnits)
            .insert(
              ProductUnitsCompanion.insert(
                id: unitId,
                storeId: storeId,
                productId: productId,
                unitName: unit.name,
                factorToBase: unit.factor,
                isDefaultSale: Value(unit.defaultSale),
                isDefaultPurchase: Value(unit.defaultPurchase),
                createdAt: now,
                updatedAt: now,
              ),
            );
        await enqueueOutbox(
          db,
          table: 'product_units',
          rowId: unitId,
          op: 'insert',
          payload: {
            'id': unitId,
            'store_id': storeId,
            'product_id': productId,
            'unit_name': unit.name,
            'factor_to_base': unit.factor,
            'barcode': null,
            'barcode_source': null,
            'sell_price': null,
            'is_default_sale': unit.defaultSale,
            'is_default_purchase': unit.defaultPurchase,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
          at: now,
        );
      }

      // Harga dari file adalah harga beli per satuan beli (dus bila ada isi).
      if (row.buyPrice != null && purchaseUnitId != null) {
        final priceId = stableId('price_history', '$purchaseUnitId|buy');
        await db
            .into(db.priceHistory)
            .insert(
              PriceHistoryCompanion.insert(
                id: priceId,
                storeId: storeId,
                productUnitId: purchaseUnitId,
                kind: PriceKind.buy,
                price: row.buyPrice!,
                effectiveAt: now,
                sourceRef: Value('import:${row.sourceSheet}:${row.sourceRow}'),
                createdAt: now,
              ),
            );
        await enqueueOutbox(
          db,
          table: 'price_history',
          rowId: priceId,
          op: 'insert',
          payload: {
            'id': priceId,
            'store_id': storeId,
            'product_unit_id': purchaseUnitId,
            'kind': 'buy',
            'price': row.buyPrice,
            'effective_at': now.toIso8601String(),
            'source_ref': 'import:${row.sourceSheet}:${row.sourceRow}',
            'created_at': now.toIso8601String(),
          },
          at: now,
        );
      }

      inserted++;
      if (reviewFlag) needsReview++;
    }
  });

  return ImportOutcome(
    inserted: inserted,
    skippedExisting: skipped,
    needsReview: needsReview,
    newSuppliers: newSuppliers,
    newCategories: newCategories,
    problems: problems,
  );
}

class _UnitSpec {
  const _UnitSpec({
    required this.name,
    required this.factor,
    required this.defaultSale,
    required this.defaultPurchase,
  });

  final String name;
  final int factor;
  final bool defaultSale;
  final bool defaultPurchase;
}

class _ResolvedRow {
  const _ResolvedRow(this.id, this.created);

  final String? id;
  final bool created;
}

Future<_ResolvedRow> _ensureSupplier(
  AppDatabase db,
  String storeId,
  String name,
  DateTime now,
) async {
  if (name.isEmpty) return const _ResolvedRow(null, false);
  final id = stableId('supplier', '$storeId|$name');
  final existing = await (db.select(
    db.suppliers,
  )..where((t) => t.id.equals(id))).getSingleOrNull();
  if (existing != null) return _ResolvedRow(id, false);

  await db
      .into(db.suppliers)
      .insert(
        SuppliersCompanion.insert(
          id: id,
          storeId: storeId,
          name: name,
          createdAt: now,
          updatedAt: now,
        ),
      );
  await enqueueOutbox(
    db,
    table: 'suppliers',
    rowId: id,
    op: 'insert',
    payload: {
      'id': id,
      'store_id': storeId,
      'name': name,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    },
    at: now,
  );
  return _ResolvedRow(id, true);
}

Future<_ResolvedRow> _ensureCategory(
  AppDatabase db,
  String storeId,
  String name,
  DateTime now,
) async {
  if (name.isEmpty) return const _ResolvedRow(null, false);
  final id = stableId('category', '$storeId|$name');
  final existing = await (db.select(
    db.categories,
  )..where((t) => t.id.equals(id))).getSingleOrNull();
  if (existing != null) return _ResolvedRow(id, false);

  await db
      .into(db.categories)
      .insert(
        CategoriesCompanion.insert(
          id: id,
          storeId: storeId,
          name: name,
          createdAt: now,
          updatedAt: now,
        ),
      );
  await enqueueOutbox(
    db,
    table: 'categories',
    rowId: id,
    op: 'insert',
    payload: {
      'id': id,
      'store_id': storeId,
      'name': name,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    },
    at: now,
  );
  return _ResolvedRow(id, true);
}
