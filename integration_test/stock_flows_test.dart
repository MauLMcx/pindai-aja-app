import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/core/ids.dart';
import 'package:petshop_pos/core/store/local_store.dart';
import 'package:petshop_pos/main.dart';

/// Data uji yang dipakai alur di bawah.
class _Fixture {
  const _Fixture({
    required this.productId,
    required this.saleUnitId,
    required this.purchaseUnitId,
  });

  final String productId;
  final String saleUnitId;
  final String purchaseUnitId;
}

Future<String> _seedSupplier(
  AppDatabase db,
  String storeId,
  String name,
) async {
  final id = newId();
  final now = DateTime.utc(2026, 11, 18, 8);
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
  return id;
}

/// Produk: stok dalam gram, jual per pcs (1.000 gram), beli per dus (10.000 gram).
Future<_Fixture> _seedProduct(
  AppDatabase db,
  String storeId, {
  String? supplierId,
}) async {
  final now = DateTime.utc(2026, 11, 18, 8);
  final productId = newId();
  await db
      .into(db.products)
      .insert(
        ProductsCompanion.insert(
          id: productId,
          storeId: storeId,
          name: 'Whiskas Tuna',
          baseUnit: 'gram',
          minStockBase: const Value(0),
          mainSupplierId: Value(supplierId),
          createdAt: now,
          updatedAt: now,
        ),
      );

  final saleUnitId = newId();
  await db
      .into(db.productUnits)
      .insert(
        ProductUnitsCompanion.insert(
          id: saleUnitId,
          storeId: storeId,
          productId: productId,
          unitName: 'pcs',
          factorToBase: 1000,
          sellPrice: const Value(20000),
          isDefaultSale: const Value(true),
          createdAt: now,
          updatedAt: now,
        ),
      );

  final purchaseUnitId = newId();
  await db
      .into(db.productUnits)
      .insert(
        ProductUnitsCompanion.insert(
          id: purchaseUnitId,
          storeId: storeId,
          productId: productId,
          unitName: 'dus',
          factorToBase: 10000,
          isDefaultPurchase: const Value(true),
          createdAt: now,
          updatedAt: now,
        ),
      );

  return _Fixture(
    productId: productId,
    saleUnitId: saleUnitId,
    purchaseUnitId: purchaseUnitId,
  );
}

/// Penjualan lama 1 pcs, dipakai untuk menguji retur penjualan.
Future<void> _seedSale(AppDatabase db, String storeId, _Fixture product) async {
  final now = DateTime.utc(2026, 11, 18, 9);
  final saleId = newId();
  await db
      .into(db.sales)
      .insert(
        SalesCompanion.insert(
          id: saleId,
          storeId: storeId,
          receiptNo: 'INV/001',
          cashierId: 'kasir-uji',
          soldAt: now,
          subtotal: 20000,
          total: 20000,
          paidTotal: 20000,
          createdAt: now,
          updatedAt: now,
        ),
      );
  await db
      .into(db.saleItems)
      .insert(
        SaleItemsCompanion.insert(
          id: newId(),
          storeId: storeId,
          saleId: saleId,
          productId: product.productId,
          unitId: product.saleUnitId,
          qty: 1,
          qtyBase: 1000,
          unitPrice: 20000,
          lineTotal: 20000,
          costPerBase: const Value(15),
          createdAt: now,
          updatedAt: now,
        ),
      );
  await db
      .into(db.stockMovements)
      .insert(
        StockMovementsCompanion.insert(
          id: newId(),
          storeId: storeId,
          productId: product.productId,
          qtyBaseDelta: -1000,
          type: MovementType.saleOut,
          occurredAt: now,
        ),
      );
}

/// Menunggu widget muncul tanpa `pumpAndSettle` (indikator loading berputar
/// terus dan membuat `pumpAndSettle` tidak pernah selesai).
Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder, {
  String? label,
  Duration timeout = const Duration(seconds: 25),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  final visible = find
      .byType(Text)
      .evaluate()
      .map((element) => (element.widget as Text).data)
      .whereType<String>()
      .take(60)
      .join(' | ');
  fail(
    'Tidak menemukan ${label ?? 'widget yang dicari'}\nTeks terlihat: $visible',
  );
}

/// Menekan widget setelah dipastikan berada di dalam layar dan animasi
/// rute/lembar bawah selesai. `_pumpUntil` bisa menemukan widget saat lembar
/// bawah masih bergerak naik dari bawah layar, sehingga tap meleset.
Future<void> _tapVisible(
  WidgetTester tester,
  Finder finder, {
  String? label,
}) async {
  final end = DateTime.now().add(const Duration(seconds: 25));
  final ratio = tester.view.devicePixelRatio;
  final size = Size(
    tester.view.physicalSize.width / ratio,
    tester.view.physicalSize.height / ratio,
  );

  bool onScreen() {
    if (finder.evaluate().isEmpty) return false;
    final rect = tester.getRect(finder.first);
    return rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= size.height &&
        rect.right <= size.width;
  }

  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (!onScreen()) continue;
    await tester.pump(const Duration(milliseconds: 350));
    if (!onScreen()) continue;
    await tester.tap(finder.first);
    return;
  }
  fail('Tidak bisa menekan ${label ?? 'widget'}: tidak berada di layar');
}

Future<void> _openStockHome(WidgetTester tester) async {
  await _tapVisible(tester, find.text('Stok & Inventaris'), label: 'Stok');
  await _pumpUntil(tester, find.text('Nilai persediaan'));
}

/// Menekan tombol kembali setelah animasi rute selesai. `pageBack` menolak
/// bila masih ada dua tombol "Back" (rute lama + rute baru saat transisi).
Future<void> _goBack(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pageBack();
  await tester.pump(const Duration(milliseconds: 100));
}

/// Menutup lembar bawah lewat Navigator agar tidak bergantung pada posisi
/// tombol "Back" halaman di belakangnya.
Future<void> _dismissSheet(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  final sheet = find.byType(BottomSheet);
  if (sheet.evaluate().isEmpty) {
    await _goBack(tester);
    return;
  }
  Navigator.of(tester.element(sheet.first)).pop();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

/// Menunggu sampai widget benar-benar hilang, mis. rute pemilih produk
/// selesai ditutup sehingga tidak ada dua `TextField` sekaligus.
Future<void> _pumpUntilGone(
  WidgetTester tester,
  Finder finder, {
  String? label,
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isEmpty) return;
  }
  fail('${label ?? 'Widget'} masih tampil setelah menunggu');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('alur Tahap 2 lengkap di perangkat', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final store = await ensureLocalStore(db);
    final supplierId = await _seedSupplier(db, store.id, 'Bintang Petshop');
    final product = await _seedProduct(db, store.id, supplierId: supplierId);
    await _seedSale(db, store.id, product);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PetshopApp(),
      ),
    );
    await _pumpUntil(tester, find.text('Stok & Inventaris'));

    // ---------- Barang masuk ----------
    await _openStockHome(tester);
    await _tapVisible(tester, find.text('Barang Masuk'), label: 'Barang Masuk');
    await _pumpUntil(tester, find.text('Tambah barang'));
    await _tapVisible(
      tester,
      find.text('Tambah barang'),
      label: 'Tambah barang',
    );
    await _pumpUntil(tester, find.text('Whiskas Tuna'));
    await _tapVisible(tester, find.text('Whiskas Tuna'), label: 'produk');
    await _pumpUntil(tester, find.text('Tambahkan'));
    await tester.enterText(find.widgetWithText(TextField, 'Jumlah'), '2');
    await tester.enterText(
      find.widgetWithText(TextField, 'Harga beli per dus'),
      '150000',
    );
    await _tapVisible(tester, find.text('Tambahkan'), label: 'Tambahkan');
    await _pumpUntil(tester, find.textContaining('2 dus'));
    await _tapVisible(
      tester,
      find.text('Simpan pembelian'),
      label: 'Simpan pembelian',
    );
    await _pumpUntil(tester, find.text('Pembelian tersimpan'));
    expect(find.textContaining('Rp 300.000'), findsWidgets);
    await _tapVisible(tester, find.text('Selesai'), label: 'Selesai');
    await _pumpUntil(tester, find.text('Nilai persediaan'));
    expect(await db.stockBase(product.productId), 19000);
    expect(await db.select(db.priceHistory).get(), hasLength(1));

    // ---------- Daftar stok + stok minimum + rak ----------
    await _tapVisible(tester, find.text('Daftar Stok'), label: 'Daftar Stok');
    await _pumpUntil(tester, find.text('Whiskas Tuna'));
    expect(find.textContaining('Stok 19000 gram'), findsOneWidget);
    await _tapVisible(tester, find.text('Whiskas Tuna'), label: 'produk');
    await _pumpUntil(tester, find.text('Simpan'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Stok minimum (gram)'),
      '25000',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Lokasi rak'),
      'Rak A-1',
    );
    await _tapVisible(tester, find.text('Simpan'), label: 'Simpan');
    await _pumpUntil(tester, find.text('Produk diperbarui.'));
    final productRow = await (db.select(
      db.products,
    )..where((t) => t.id.equals(product.productId))).getSingle();
    expect(productRow.minStockBase, 25000);
    expect(productRow.shelfLocation, 'Rak A-1');

    // ---------- Riwayat harga ----------
    await _tapVisible(tester, find.text('Whiskas Tuna'), label: 'produk');
    await _pumpUntil(tester, find.text('Riwayat harga'));
    await _tapVisible(
      tester,
      find.text('Riwayat harga'),
      label: 'Riwayat harga',
    );
    await _pumpUntil(tester, find.textContaining('Rp 150.000 / dus'));
    expect(find.textContaining('Harga beli'), findsWidgets);
    await _goBack(tester);
    await _pumpUntil(tester, find.text('Simpan'));

    // tutup lembar produk
    await _dismissSheet(tester);
    await _pumpUntil(tester, find.text('Perlu dibeli'));

    // ---------- Perlu dibeli ----------
    await _tapVisible(tester, find.text('Perlu dibeli'), label: 'Perlu dibeli');
    await _pumpUntil(tester, find.textContaining('kurang 6000 gram'));
    expect(find.text('Bintang Petshop'), findsOneWidget);

    await _goBack(tester);
    await _pumpUntil(tester, find.text('Nilai persediaan'));
    await _goBack(tester);
    await _pumpUntil(
      tester,
      find.textContaining('1 barang di bawah stok minimum'),
    );

    // ---------- Susun barang ----------
    await _openStockHome(tester);
    await _tapVisible(tester, find.text('Susun Barang'), label: 'Susun Barang');
    await _pumpUntil(tester, find.text('Pilih barang'));
    await _tapVisible(tester, find.text('Pilih barang'), label: 'Pilih barang');
    await _pumpUntil(tester, find.text('Whiskas Tuna'));
    await _tapVisible(tester, find.text('Whiskas Tuna'), label: 'produk');
    await _pumpUntil(tester, find.text('Simpan lokasi'));
    await _pumpUntilGone(
      tester,
      find.widgetWithText(TextField, 'Cari nama atau barcode'),
      label: 'Pencarian produk',
    );
    await tester.enterText(find.byType(TextField), 'Rak B-2');
    await _tapVisible(
      tester,
      find.text('Simpan lokasi'),
      label: 'Simpan lokasi',
    );
    await _pumpUntil(tester, find.text('Lokasi rak diperbarui.'));
    final putaway = await db.select(db.putawayLog).get();
    expect(putaway, hasLength(2)); // Rak A-1 lalu Rak B-2
    expect(putaway.last.toLocation, 'Rak B-2');

    // ---------- Opname ----------
    await _goBack(tester);
    await _pumpUntil(tester, find.text('Nilai persediaan'));
    await _tapVisible(tester, find.text('Stok Opname'), label: 'Stok Opname');
    await _pumpUntil(tester, find.text('Mulai opname'));
    await _tapVisible(tester, find.text('Mulai opname'), label: 'Mulai opname');
    await _pumpUntil(tester, find.text('Mulai'));
    await _tapVisible(tester, find.text('Mulai'), label: 'Mulai');
    await _pumpUntil(tester, find.text('Hitung barang'));
    await _tapVisible(
      tester,
      find.text('Hitung barang'),
      label: 'Hitung barang',
    );
    await _pumpUntil(tester, find.text('Whiskas Tuna'));
    await _tapVisible(tester, find.text('Whiskas Tuna'), label: 'produk');
    await _pumpUntil(tester, find.textContaining('Jumlah fisik'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Jumlah fisik (gram)'),
      '18500',
    );
    await _tapVisible(tester, find.text('Simpan'), label: 'Simpan');
    await _pumpUntil(tester, find.textContaining('Fisik 18500 gram'));
    await _tapVisible(
      tester,
      find.text('Selesaikan opname'),
      label: 'Selesaikan opname',
    );
    await _pumpUntil(tester, find.text('Selesaikan'));
    await _tapVisible(tester, find.text('Selesaikan'), label: 'Selesaikan');
    await _pumpUntil(tester, find.text('Opname selesai'));
    expect(find.textContaining('1 barang disesuaikan'), findsOneWidget);
    await _tapVisible(tester, find.text('Selesai'), label: 'Selesai');
    await _pumpUntil(tester, find.text('Mulai opname'));
    expect(await db.stockBase(product.productId), 18500);
    final opname = await db.select(db.stockOpnames).getSingle();
    expect(opname.status.name, 'finished');

    // ---------- Retur pembelian ----------
    await _goBack(tester);
    await _pumpUntil(tester, find.text('Nilai persediaan'));
    await _tapVisible(tester, find.text('Retur'), label: 'Retur');
    await _pumpUntil(tester, find.text('Retur Pembelian'));
    await _tapVisible(
      tester,
      find.text('Retur Pembelian'),
      label: 'Retur Pembelian',
    );
    await _pumpUntil(tester, find.text('Pilih dokumen'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _tapVisible(
      tester,
      find.byType(DropdownButton<String>).first,
      label: 'Pilih dokumen',
    );
    await _pumpUntil(tester, find.textContaining('Pembelian'));
    await _tapVisible(
      tester,
      find.textContaining('Pembelian').last,
      label: 'dokumen pembelian',
    );
    await _pumpUntil(tester, find.textContaining('Sisa 2 dus'));
    await tester.enterText(find.widgetWithText(TextField, 'dus').last, '1');
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await _tapVisible(
      tester,
      find.text('Simpan retur pembelian'),
      label: 'Simpan retur pembelian',
    );
    await _pumpUntil(tester, find.textContaining('Retur pembelian tersimpan'));
    expect(await db.stockBase(product.productId), 8500);

    // ---------- Retur penjualan ----------
    await _tapVisible(
      tester,
      find.text('Retur Penjualan'),
      label: 'Retur Penjualan',
    );
    await _pumpUntil(tester, find.text('Pilih transaksi'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _tapVisible(
      tester,
      find.byType(DropdownButton<String>).first,
      label: 'Pilih transaksi',
    );
    await _pumpUntil(tester, find.textContaining('INV/001'));
    await _tapVisible(
      tester,
      find.textContaining('INV/001').last,
      label: 'transaksi penjualan',
    );
    await _pumpUntil(tester, find.textContaining('Sisa 1 pcs'));
    await tester.enterText(find.widgetWithText(TextField, 'pcs').last, '1');
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await _tapVisible(
      tester,
      find.text('Simpan retur penjualan'),
      label: 'Simpan retur penjualan',
    );
    await _pumpUntil(tester, find.textContaining('Retur tersimpan'));

    // 18.500 − 10.000 (retur beli) + 1.000 (retur jual) = 9.500
    expect(await db.stockBase(product.productId), 9500);
    final returns = await db.select(db.returns).get();
    expect(returns, hasLength(2));
    final saleReturn = returns.firstWhere((row) => row.kind == ReturnKind.sale);
    expect(saleReturn.refundTotal, 20000);
    final saleReturnMovement = await (db.select(
      db.stockMovements,
    )..where((t) => t.type.equalsValue(MovementType.returnIn))).getSingle();
    expect(saleReturnMovement.qtyBaseDelta, 1000);
    expect(saleReturnMovement.costPerBase, 15);
  });
}
