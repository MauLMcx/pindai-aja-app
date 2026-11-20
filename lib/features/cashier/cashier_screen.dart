import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/money.dart';
import '../../core/theme/app_theme.dart';
import '../products/product_service.dart';
import '../products/products_providers.dart';
import '../sales/sale_service.dart';
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
  });

  final String productId;
  final String name;
  final String unitId;
  final String unitName;
  final int factorToBase;
  final int unitPrice;
  final int stockBase;
  int qty;

  int get lineTotal => unitPrice * qty;
  int get qtyBase => factorToBase * qty;
  bool get exceedsStock => qtyBase > stockBase;
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

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  int get _total => _cart.fold(0, (sum, line) => sum + line.lineTotal);

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
    final cash = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.of(context).canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CartSheet(lines: _cart),
    );
    if (cash == null || !mounted) return;
    await _completeSale(cash);
  }

  Future<void> _completeSale(int cash) async {
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
      final result = await service.create(
        cashierId: identity.cashierId,
        items: [
          for (final line in lines)
            SaleDraftItem(
              productId: line.productId,
              unitId: line.unitId,
              qty: line.qty,
              unitPrice: line.unitPrice,
            ),
        ],
        payments: [SalePaymentInput(method: PayMethod.cash, amount: cash)],
      );
      if (!mounted) return;
      setState(() => _cart.clear());
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

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    final palette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir'),
        actions: [
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
                            'Total',
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
  const _CartSheet({required this.lines});

  final List<CashierLine> lines;

  @override
  State<_CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<_CartSheet> {
  int get _total => widget.lines.fold(0, (sum, line) => sum + line.lineTotal);

  Future<void> _pay() async {
    final cash = await _askCash(context, _total);
    if (cash == null || !mounted) return;
    Navigator.of(context).pop(cash);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SizedBox(
        height: media.size.height * 0.78,
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
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: widget.lines.isEmpty ? null : _pay,
                        icon: const Icon(Icons.payments_rounded, size: 20),
                        label: const Text('Bayar tunai'),
                      ),
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

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({
    required this.line,
    required this.onChanged,
    required this.onRemove,
  });

  final CashierLine line;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

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
    final buffer = StringBuffer()
      ..writeln(storeName)
      ..writeln('No: ${sale.receiptNo}')
      ..writeln(_formatDateTime(sale.soldAt.toLocal()))
      ..writeln('-' * 32);
    for (final line in lines) {
      buffer.writeln('${line.name} (${line.unitName})');
      buffer.writeln(
        '  ${line.qty} x ${formatRupiah(line.unitPrice)}'
        '  ${formatRupiah(line.lineTotal)}',
      );
    }
    buffer
      ..writeln('-' * 32)
      ..writeln('Total     ${formatRupiah(sale.total)}')
      ..writeln('Bayar     ${formatRupiah(sale.paidTotal)}')
      ..writeln('Kembali   ${formatRupiah(result.changeAmount)}')
      ..writeln('-' * 32)
      ..writeln('Terima kasih sudah berbelanja');

    return AlertDialog(
      title: const Text('Transaksi tersimpan'),
      content: SingleChildScrollView(
        child: Text(
          buffer.toString(),
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
