import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/money.dart';
import '../../core/theme/app_theme.dart';
import '../products/product_service.dart';
import '../products/products_providers.dart';
import '../sales/receipt_text.dart';
import '../sales/sale_service.dart';
import '../sales/sales_history_screen.dart';
import 'cashier_providers.dart';

class CashierLine {
  CashierLine({
    required this.productId,
    required this.name,
    required this.unitId,
    required this.unitName,
    required this.factorToBase,
    required this.unitPrice,
    required this.stockBase,
    this.qty = 1,
    this.discount = 0,
  });

  final String productId;
  final String name;
  final String unitId;
  final String unitName;
  final int factorToBase;
  final int unitPrice;
  final int stockBase;
  int qty;

  /// Diskon baris dalam rupiah (nominal, bukan persen).
  int discount;

  int get grossTotal => unitPrice * qty;
  int get lineTotal => grossTotal - discount;
  int get qtyBase => factorToBase * qty;
  bool get exceedsStock => qtyBase > stockBase;
}

/// Hasil dari lembar keranjang: tahan, atau bayar dengan daftar pembayaran.
class CartOutcome {
  const CartOutcome({
    required this.discountTotal,
    this.payments,
    this.hold = false,
  });

  final int discountTotal;
  final List<SalePaymentInput>? payments;
  final bool hold;
}

/// Layar kasir Tahap 1: pilih produk, keranjang, bayar tunai, lalu struk.
class CashierScreen extends ConsumerStatefulWidget {
  const CashierScreen({super.key});

  @override
  ConsumerState<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends ConsumerState<CashierScreen> {
  final TextEditingController _search = TextEditingController();
  final List<CashierLine> _cart = [];
  String _query = '';
  bool _busy = false;
  int _discountTotal = 0;

  /// Bila terisi, keranjang berasal dari transaksi yang ditahan.
  String? _heldSaleId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  int get _subtotal => _cart.fold(0, (sum, line) => sum + line.lineTotal);
  int get _total => _subtotal - _discountTotal;

  void _resetCart() {
    setState(() {
      _cart.clear();
      _discountTotal = 0;
      _heldSaleId = null;
    });
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addProduct(ProductListItem item) async {
    if (item.sellUnitId == null) {
      _notify('Produk ini belum punya satuan jual.');
      return;
    }
    if (item.sellPrice == null) {
      final price = await _askSellPrice(item);
      if (price == null || !mounted) return;
      await _saveSellPrice(item, price);
      if (!mounted) return;
      _insertLine(item, price);
      return;
    }
    _insertLine(item, item.sellPrice!);
  }

  void _insertLine(ProductListItem item, int price) {
    final existing = _cart
        .where(
          (line) => line.productId == item.id && line.unitId == item.sellUnitId,
        )
        .firstOrNull;

    setState(() {
      if (existing != null) {
        existing.qty++;
      } else {
        _cart.add(
          CashierLine(
            productId: item.id,
            name: item.name,
            unitId: item.sellUnitId!,
            unitName: item.sellUnitName ?? item.baseUnit,
            factorToBase: item.sellFactor ?? 1,
            unitPrice: price,
            stockBase: item.stockBase,
          ),
        );
      }
    });

    if (item.stockBase <= 0) {
      _notify('Stok tercatat 0. Penjualan tetap bisa disimpan.');
    }
  }

  Future<int?> _askSellPrice(ProductListItem item) {
    return showDialog<int>(
      context: context,
      builder: (_) => _SellPriceDialog(item: item),
    );
  }

  Future<void> _saveSellPrice(ProductListItem item, int price) async {
    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ref.read(localStoreProvider.future);
      final identity = await ref.read(localIdentityProvider.future);
      await ProductService(
        db,
        storeId: store.id,
        deviceId: identity.deviceId,
      ).setSellPrice(
        productId: item.id,
        unitId: item.sellUnitId!,
        price: price,
      );
    } catch (error) {
      if (mounted) _notify('Gagal menyimpan harga: $error');
    }
  }

  Future<void> _openCart() async {
    if (_cart.isEmpty) return;
    final outcome = await showModalBottomSheet<CartOutcome>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.of(context).canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CartSheet(
        lines: _cart,
        discountTotal: _discountTotal,
        canHold: _heldSaleId == null,
      ),
    );
    if (outcome == null || !mounted) return;
    await _finishCart(outcome);
  }

  Future<void> _finishCart(CartOutcome outcome) async {
    if (_busy) return;
    setState(() => _busy = true);
    final lines = [
      for (final line in _cart)
        CashierLine(
          productId: line.productId,
          name: line.name,
          unitId: line.unitId,
          unitName: line.unitName,
          factorToBase: line.factorToBase,
          unitPrice: line.unitPrice,
          stockBase: line.stockBase,
          qty: line.qty,
          discount: line.discount,
        ),
    ];

    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ref.read(localStoreProvider.future);
      final identity = await ref.read(localIdentityProvider.future);
      final service = SaleService(
        db,
        storeId: store.id,
        deviceId: identity.deviceId,
        deviceCode: identity.deviceCode,
      );

      if (outcome.hold) {
        await service.create(
          cashierId: identity.cashierId,
          items: [
            for (final line in lines)
              SaleDraftItem(
                productId: line.productId,
                unitId: line.unitId,
                qty: line.qty,
                unitPrice: line.unitPrice,
                discount: line.discount,
              ),
          ],
          discountTotal: outcome.discountTotal,
          status: SaleStatus.hold,
        );
        if (!mounted) return;
        _resetCart();
        _notify('Transaksi ditahan. Buka lagi lewat ikon tahan.');
        return;
      }

      final SaleResult result;
      final heldId = _heldSaleId;
      if (heldId != null) {
        result = await service.completeHeld(
          saleId: heldId,
          payments: outcome.payments ?? const [],
          discountTotal: outcome.discountTotal,
        );
      } else {
        result = await service.create(
          cashierId: identity.cashierId,
          items: [
            for (final line in lines)
              SaleDraftItem(
                productId: line.productId,
                unitId: line.unitId,
                qty: line.qty,
                unitPrice: line.unitPrice,
                discount: line.discount,
              ),
          ],
          payments: outcome.payments ?? const [],
          discountTotal: outcome.discountTotal,
        );
      }
      if (!mounted) return;
      _resetCart();
      await showDialog<void>(
        context: context,
        builder: (_) =>
            _ReceiptDialog(storeName: store.name, result: result, lines: lines),
      );
    } catch (error) {
      if (mounted) _notify('Gagal menyimpan transaksi: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openHeldSales() async {
    if (_cart.isNotEmpty) {
      final replace = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ganti keranjang?'),
          content: const Text(
            'Keranjang saat ini akan diganti dengan transaksi yang ditahan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ganti'),
            ),
          ],
        ),
      );
      if (replace != true || !mounted) return;
    }

    final sale = await showModalBottomSheet<Sale>(
      context: context,
      backgroundColor: AppPalette.of(context).canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _HeldSalesSheet(),
    );
    if (sale == null || !mounted) return;
    await _loadHeldSale(sale);
  }

  Future<void> _loadHeldSale(Sale sale) async {
    final db = ref.read(appDatabaseProvider);
    try {
      final items = await (db.select(
        db.saleItems,
      )..where((t) => t.saleId.equals(sale.id))).get();
      final lines = <CashierLine>[];
      for (final item in items) {
        final unit = await (db.select(
          db.productUnits,
        )..where((t) => t.id.equals(item.unitId))).getSingleOrNull();
        final product = await (db.select(
          db.products,
        )..where((t) => t.id.equals(item.productId))).getSingleOrNull();
        lines.add(
          CashierLine(
            productId: item.productId,
            name: product?.name ?? 'Produk',
            unitId: item.unitId,
            unitName: unit?.unitName ?? 'pcs',
            factorToBase: unit?.factorToBase ?? 1,
            unitPrice: item.unitPrice,
            stockBase: await db.stockBase(item.productId),
            qty: item.qty,
            discount: item.discount,
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        _cart
          ..clear()
          ..addAll(lines);
        _discountTotal = sale.discountTotal;
        _heldSaleId = sale.id;
      });
      _notify('Transaksi ${sale.receiptNo} dilanjutkan.');
    } catch (error) {
      if (mounted) _notify('Gagal membuka transaksi ditahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    final palette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_heldSaleId == null ? 'Kasir' : 'Lanjutkan transaksi'),
        actions: [
          IconButton(
            tooltip: 'Riwayat transaksi',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SalesHistoryScreen(),
              ),
            ),
            icon: const Icon(Icons.receipt_long_rounded, size: 22),
          ),
          if (_heldSaleId == null)
            IconButton(
              tooltip: 'Transaksi ditahan',
              onPressed: _openHeldSales,
              icon: const Icon(Icons.pause_circle_outline_rounded),
            )
          else
            IconButton(
              tooltip: 'Batalkan lanjut',
              onPressed: _resetCart,
              icon: const Icon(Icons.close_rounded),
            ),
          if (_cart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: _openCart,
                icon: const Icon(
                  Icons.shopping_cart_checkout_rounded,
                  size: 20,
                ),
                label: Text('${_cart.length} item'),
              ),
            ),
        ],
      ),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Gagal membaca produk: $error'),
          ),
        ),
        data: (items) => _buildProductList(items),
      ),
      bottomNavigationBar: _cart.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                decoration: BoxDecoration(
                  color: palette.card,
                  border: Border(top: BorderSide(color: palette.line)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _discountTotal > 0
                                ? 'Total setelah diskon'
                                : 'Total',
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.muted,
                            ),
                          ),
                          Text(
                            formatRupiah(_total),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: palette.primaryDeep,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _busy ? null : _openCart,
                      icon: const Icon(Icons.payments_rounded, size: 20),
                      label: Text(_busy ? 'Menyimpan…' : 'Bayar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProductList(List<ProductListItem> items) {
    final query = _query.trim().toLowerCase();
    final visible = items.where((item) {
      if (query.isEmpty) return true;
      final haystack = [
        item.name,
        item.brand,
        item.variant,
        item.sellUnitName,
      ].whereType<String>().join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: TextField(
            controller: _search,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Cari produk untuk dijual',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Hapus pencarian',
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
            ),
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? const Center(child: Text('Tidak ada produk yang cocok'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _CashierProductTile(
                    item: visible[index],
                    onTap: () => _addProduct(visible[index]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _CashierProductTile extends StatelessWidget {
  const _CashierProductTile({required this.item, required this.onTap});

  final ProductListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final price = item.sellPrice;
    final unit = item.sellUnitName ?? item.baseUnit;
    final factor = item.sellFactor ?? 1;
    final stockInUnit = factor <= 0 ? item.stockBase : item.stockBase ~/ factor;
    final title = item.variant == null
        ? item.name
        : '${item.name} (${item.variant})';

    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.line),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.pets, color: palette.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Stok $stockInUnit $unit',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: item.stockBase <= 0
                            ? palette.warning
                            : palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (price == null)
                    Text(
                      'Atur harga',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: palette.warning,
                      ),
                    )
                  else
                    Text(
                      formatRupiah(price),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: palette.primaryDeep,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    'per $unit',
                    style: TextStyle(fontSize: 10.5, color: palette.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartSheet extends StatefulWidget {
  const _CartSheet({
    required this.lines,
    required this.discountTotal,
    required this.canHold,
  });

  final List<CashierLine> lines;
  final int discountTotal;
  final bool canHold;

  @override
  State<_CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<_CartSheet> {
  late int _discountTotal = widget.discountTotal;

  int get _subtotal =>
      widget.lines.fold(0, (sum, line) => sum + line.lineTotal);
  int get _total => _subtotal - _discountTotal;

  Future<void> _editDiscount() async {
    final value = await _askRupiah(
      context,
      title: 'Diskon transaksi',
      initial: _discountTotal,
      maxValue: _subtotal,
      hint: 'Diskon untuk seluruh transaksi',
    );
    if (value == null || !mounted) return;
    setState(() => _discountTotal = value);
  }

  Future<void> _pay() async {
    final cash = await _askCash(context, _total);
    if (cash == null || !mounted) return;
    Navigator.of(context).pop(
      CartOutcome(
        discountTotal: _discountTotal,
        payments: [SalePaymentInput(method: PayMethod.cash, amount: cash)],
      ),
    );
  }

  Future<void> _payMixed() async {
    final payments = await showDialog<List<SalePaymentInput>>(
      context: context,
      builder: (_) => _PaymentDialog(total: _total),
    );
    if (payments == null || !mounted) return;
    Navigator.of(context)
        .pop(CartOutcome(discountTotal: _discountTotal, payments: payments));
  }

  void _hold() {
    Navigator.of(context)
        .pop(CartOutcome(discountTotal: _discountTotal, hold: true));
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SizedBox(
        height: media.size.height * 0.82,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: palette.line,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  const Text(
                    'Keranjang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.lines.length} produk',
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                itemCount: widget.lines.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final line = widget.lines[index];
                  return _CartLineTile(
                    line: line,
                    onChanged: () => setState(() {}),
                    onRemove: () => setState(() => widget.lines.remove(line)),
                    onEditDiscount: () async {
                      final value = await _askRupiah(
                        context,
                        title: 'Diskon baris',
                        initial: line.discount,
                        maxValue: line.grossTotal,
                        hint: 'Diskon untuk ${line.name}',
                      );
                      if (value == null || !mounted) return;
                      setState(() => line.discount = value);
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: palette.card,
                border: Border(top: BorderSide(color: palette.line)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SummaryRow(
                      label: 'Subtotal',
                      value: formatRupiah(_subtotal),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _editDiscount,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              'Diskon',
                              style: TextStyle(
                                fontSize: 13,
                                color: palette.muted,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.edit_rounded,
                              size: 14,
                              color: palette.muted,
                            ),
                            const Spacer(),
                            Text(
                              _discountTotal == 0
                                  ? 'Atur'
                                  : '- ${formatRupiah(_discountTotal)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _discountTotal == 0
                                    ? palette.primary
                                    : palette.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 18),
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 13, color: palette.muted),
                        ),
                        const Spacer(),
                        Text(
                          formatRupiah(_total),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: palette.primaryDeep,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (widget.canHold) ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: widget.lines.isEmpty ? null : _hold,
                          icon: const Icon(
                            Icons.pause_circle_outline_rounded,
                            size: 18,
                          ),
                          label: const Text('Tahan transaksi'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.lines.isEmpty ? null : _payMixed,
                            icon: const Icon(
                              Icons.call_split_rounded,
                              size: 18,
                            ),
                            label: const Text('Bayar campuran'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: widget.lines.isEmpty ? null : _pay,
                            icon: const Icon(Icons.payments_rounded, size: 20),
                            label: const Text('Bayar tunai'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: palette.muted)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

/// Dialog nominal rupiah (diskon baris/transaksi).
Future<int?> _askRupiah(
  BuildContext context, {
  required String title,
  required int initial,
  required int maxValue,
  required String hint,
}) {
  return showDialog<int>(
    context: context,
    builder: (_) => _RupiahDialog(
      title: title,
      initial: initial,
      maxValue: maxValue,
      hint: hint,
    ),
  );
}

class _RupiahDialog extends StatefulWidget {
  const _RupiahDialog({
    required this.title,
    required this.initial,
    required this.maxValue,
    required this.hint,
  });

  final String title;
  final int initial;
  final int maxValue;
  final String hint;

  @override
  State<_RupiahDialog> createState() => _RupiahDialogState();
}

class _RupiahDialogState extends State<_RupiahDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial == 0 ? '' : '${widget.initial}',
  );

  int get _value => parseRupiah(_controller.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final tooLarge = _value > widget.maxValue;
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hint,
              style: TextStyle(color: palette.muted, fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('discount-input'),
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
              ),
            ),
            if (tooLarge) ...[
              const SizedBox(height: 8),
              Text(
                'Maksimal ${formatRupiah(widget.maxValue)}',
                style: TextStyle(fontSize: 12, color: palette.danger),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: tooLarge || _value < 0
              ? null
              : () => Navigator.of(context).pop(_value),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({
    required this.line,
    required this.onChanged,
    required this.onRemove,
    required this.onEditDiscount,
  });

  final CashierLine line;
  final VoidCallback onChanged;
  final VoidCallback onRemove;
  final Future<void> Function() onEditDiscount;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatRupiah(line.unitPrice)} / ${line.unitName}',
                      style: TextStyle(fontSize: 11.5, color: palette.muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hapus',
                onPressed: onRemove,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: palette.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: 'Kurangi',
                onPressed: line.qty <= 1
                    ? null
                    : () {
                        line.qty--;
                        onChanged();
                      },
                icon: const Icon(Icons.remove_rounded, size: 18),
              ),
              SizedBox(
                width: 42,
                child: Text(
                  '${line.qty}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Tambah',
                onPressed: () {
                  line.qty++;
                  onChanged();
                },
                icon: const Icon(Icons.add_rounded, size: 18),
              ),
              const Spacer(),
              Text(
                formatRupiah(line.lineTotal),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (line.discount > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Diskon',
                  style: TextStyle(fontSize: 11, color: palette.muted),
                ),
                const Spacer(),
                Text(
                  '- ${formatRupiah(line.discount)}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: palette.danger,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onEditDiscount,
              icon: const Icon(Icons.local_offer_outlined, size: 15),
              label: Text(
                line.discount == 0 ? 'Beri diskon' : 'Ubah diskon',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          if (line.exceedsStock) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: palette.warning,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Stok tercatat ${line.factorToBase <= 0 ? line.stockBase : line.stockBase ~/ line.factorToBase} '
                    '${line.unitName} — transaksi tetap bisa disimpan',
                    style: TextStyle(fontSize: 10.5, color: palette.warning),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Future<int?> _askCash(BuildContext context, int total) {
  return showDialog<int>(
    context: context,
    builder: (_) => _CashDialog(total: total),
  );
}

/// Dialog pembayaran campuran: tunai, transfer, dan QRIS dalam satu transaksi.
/// Kredit tidak ditawarkan di sini karena membutuhkan pelanggan.
class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog({required this.total});

  final int total;

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  final TextEditingController _cash = TextEditingController();
  final TextEditingController _transfer = TextEditingController();
  final TextEditingController _qris = TextEditingController();

  int get _paid =>
      parseRupiah(_cash.text) +
      parseRupiah(_transfer.text) +
      parseRupiah(_qris.text);

  @override
  void initState() {
    super.initState();
    _cash.text = '${widget.total}';
    for (final controller in [_cash, _transfer, _qris]) {
      controller.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    for (final controller in [_cash, _transfer, _qris]) {
      controller
        ..removeListener(_refresh)
        ..dispose();
    }
    super.dispose();
  }

  void _submit() {
    final payments = <SalePaymentInput>[
      if (parseRupiah(_cash.text) > 0)
        SalePaymentInput(
          method: PayMethod.cash,
          amount: parseRupiah(_cash.text),
        ),
      if (parseRupiah(_transfer.text) > 0)
        SalePaymentInput(
          method: PayMethod.transfer,
          amount: parseRupiah(_transfer.text),
        ),
      if (parseRupiah(_qris.text) > 0)
        SalePaymentInput(
          method: PayMethod.qris,
          amount: parseRupiah(_qris.text),
        ),
    ];
    Navigator.of(context).pop(payments);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final remaining = widget.total - _paid;
    return AlertDialog(
      title: const Text('Pembayaran campuran'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Total'),
                const Spacer(),
                Text(
                  formatRupiah(widget.total),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _PayField(keyName: 'pay-cash', controller: _cash, label: 'Tunai'),
            const SizedBox(height: 10),
            _PayField(
              keyName: 'pay-transfer',
              controller: _transfer,
              label: 'Transfer',
            ),
            const SizedBox(height: 10),
            _PayField(keyName: 'pay-qris', controller: _qris, label: 'QRIS'),
            const SizedBox(height: 12),
            Text(
              remaining > 0
                  ? 'Kurang ${formatRupiah(remaining)}'
                  : 'Kembalian ${formatRupiah(-remaining)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: remaining > 0 ? palette.danger : palette.success,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: remaining > 0 ? null : _submit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _PayField extends StatelessWidget {
  const _PayField({
    required this.keyName,
    required this.controller,
    required this.label,
  });

  final String keyName;
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: Key(keyName),
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixText: 'Rp ',
        isDense: true,
      ),
    );
  }
}

/// Daftar transaksi yang ditahan (status `hold`).
class _HeldSalesSheet extends ConsumerWidget {
  const _HeldSalesSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final held = ref.watch(heldSalesProvider);
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: palette.line,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  const Text(
                    'Transaksi ditahan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: held.when(
                loading: () => const Center(child: Text('Memuat…')),
                error: (error, _) =>
                    Center(child: Text('Gagal memuat: $error')),
                data: (sales) => sales.isEmpty
                    ? const Center(
                        child: Text('Belum ada transaksi yang ditahan'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        itemCount: sales.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final sale = sales[index];
                          return Material(
                            color: palette.card,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => Navigator.of(context).pop(sale),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: palette.line),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sale.receiptNo,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _formatDateTime(
                                              sale.soldAt.toLocal(),
                                            ),
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: palette.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      formatRupiah(sale.total),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: palette.muted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellPriceDialog extends StatefulWidget {
  const _SellPriceDialog({required this.item});

  final ProductListItem item;

  @override
  State<_SellPriceDialog> createState() => _SellPriceDialogState();
}

class _SellPriceDialogState extends State<_SellPriceDialog> {
  final TextEditingController _controller = TextEditingController();
  int get _value => parseRupiah(_controller.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_value <= 0) return;
    Navigator.of(context).pop(_value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final item = widget.item;
    return AlertDialog(
      title: const Text('Atur harga jual'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.name} per ${item.sellUnitName ?? item.baseUnit}',
              style: TextStyle(color: palette.muted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('sell-price-input'),
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Harga jual',
                prefixText: 'Rp ',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _value <= 0 ? null : _submit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _CashDialog extends StatefulWidget {
  const _CashDialog({required this.total});

  final int total;

  @override
  State<_CashDialog> createState() => _CashDialogState();
}

class _CashDialogState extends State<_CashDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.total}',
  );

  int get _cash => parseRupiah(_controller.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final total = widget.total;
    final cash = _cash;
    final change = cash - total;
    final quickValues = <int>{
      total,
      ((total + 19999) ~/ 20000) * 20000,
      ((total + 49999) ~/ 50000) * 50000,
      ((total + 99999) ~/ 100000) * 100000,
    }.where((value) => value >= total).toList()..sort();

    return AlertDialog(
      title: const Text('Pembayaran tunai'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Total'),
                const Spacer(),
                Text(
                  formatRupiah(total),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              key: const Key('cash-input'),
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Uang diterima',
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final value in quickValues)
                  ActionChip(
                    label: Text(
                      value == total ? 'Uang pas' : formatRupiah(value),
                    ),
                    onPressed: () {
                      _controller.text = '$value';
                      setState(() {});
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              change < 0
                  ? 'Uang belum cukup'
                  : 'Kembalian ${formatRupiah(change)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: change < 0 ? palette.danger : palette.success,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: cash < total
              ? null
              : () => Navigator.of(context).pop(cash),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _ReceiptDialog extends StatelessWidget {
  const _ReceiptDialog({
    required this.storeName,
    required this.result,
    required this.lines,
  });

  final String storeName;
  final SaleResult result;
  final List<CashierLine> lines;

  @override
  Widget build(BuildContext context) {
    final sale = result.sale;
    final text = buildReceiptText(
      storeName: storeName,
      sale: sale,
      lines: [
        for (final line in lines)
          ReceiptLine(
            name: line.name,
            unitName: line.unitName,
            qty: line.qty,
            unitPrice: line.unitPrice,
            discount: line.discount,
            lineTotal: line.lineTotal,
          ),
      ],
      changeAmount: result.changeAmount,
    );

    return AlertDialog(
      title: const Text('Transaksi tersimpan'),
      content: SingleChildScrollView(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.45,
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Transaksi baru'),
        ),
      ],
    );
  }
}

String _formatDateTime(DateTime value) {
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(value.day)}-${two(value.month)}-${value.year} '
      '${two(value.hour)}:${two(value.minute)}';
}
