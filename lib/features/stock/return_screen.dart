import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/money.dart';
import '../../core/store/local_store.dart';
import 'product_picker.dart';
import 'return_service.dart';
import 'stock_providers.dart';
import 'stock_queries.dart';

/// Layar Retur (SPEC §6.5): retur penjualan dan retur pembelian.
class ReturnScreen extends StatelessWidget {
  const ReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Retur'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Retur Penjualan'),
              Tab(text: 'Retur Pembelian'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_SaleReturnTab(), _PurchaseReturnTab()],
        ),
      ),
    );
  }
}

class _SaleReturnTab extends ConsumerStatefulWidget {
  const _SaleReturnTab();

  @override
  ConsumerState<_SaleReturnTab> createState() => _SaleReturnTabState();
}

class _SaleReturnTabState extends ConsumerState<_SaleReturnTab> {
  final _reason = TextEditingController();
  final _qty = <String, TextEditingController>{};
  String? _saleId;
  PayMethod _method = PayMethod.cash;
  bool _saving = false;
  final _drafts = <_SaleReturnDraft>[];
  bool _withoutInvoice = false;

  @override
  void dispose() {
    _reason.dispose();
    for (final controller in _qty.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _key(ReturnableLine line) => '${line.productId}|${line.unitId}';

  TextEditingController _controllerFor(ReturnableLine line) =>
      _qty.putIfAbsent(_key(line), TextEditingController.new);

  void _clearControllers() {
    for (final controller in _qty.values) {
      controller.clear();
    }
  }

  void _resetQuantity(List<ReturnableLine> lines) {
    for (final line in lines) {
      _controllerFor(line).clear();
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _submit(List<ReturnableLine> lines) async {
    final saleId = _saleId;
    if (saleId == null) return;

    final inputs = <ReturnLineInput>[];
    var estimate = 0;
    for (final line in lines) {
      final qty = int.tryParse(_controllerFor(line).text.trim()) ?? 0;
      if (qty <= 0) continue;
      if (line.qty > 0) {
        estimate += (line.docAmount * qty) ~/ line.qty;
      }
      inputs.add(
        ReturnLineInput(
          productId: line.productId,
          unitId: line.unitId,
          qty: qty,
        ),
      );
    }

    if (inputs.isEmpty) {
      _message('Isi jumlah yang ingin diretur minimal satu barang.');
      return;
    }

    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);
      final result = await recordSaleReturn(
        db,
        storeId: store.id,
        saleId: saleId,
        returnedAt: DateTime.now(),
        refundMethod: _method,
        reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
        lines: inputs,
      );

      ref.invalidate(saleSummariesProvider);
      ref.invalidate(returnableSaleLinesProvider(saleId));
      ref.invalidate(stockRowsProvider);
      ref.invalidate(lowStockGroupsProvider);
      ref.invalidate(inventoryValueProvider);

      if (!mounted) return;
      setState(() => _saving = false);
      _resetQuantity(lines);
      _message(
        'Retur tersimpan. Refund ${formatRupiah(result.amount)} '
        '(perkiraan ${formatRupiah(estimate)}).',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _message('Gagal menyimpan retur: $error');
    }
  }

  Future<void> _addDraft() async {
    final product = await showProductPicker(
      context,
      title: 'Barang yang diretur',
    );
    if (product == null || !mounted) return;
    if (product.units.isEmpty) {
      _message('Produk ini belum punya satuan. Lengkapi dulu di data produk.');
      return;
    }

    var unit = product.defaultSaleUnit ?? product.units.first;
    final qty = TextEditingController(text: '1');
    final price = TextEditingController(
      text: (unit.sellPrice ?? 0) > 0 ? unit.sellPrice.toString() : '',
    );

    final draft = await showDialog<_SaleReturnDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(product.displayName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UnitChoice>(
                    isExpanded: true,
                    value: unit,
                    items: [
                      for (final item in product.units)
                        DropdownMenuItem(value: item, child: Text(item.name)),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() {
                        unit = value;
                        if ((value.sellPrice ?? 0) > 0) {
                          price.text = value.sellPrice.toString();
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qty,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga jual per satuan',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final jumlah = int.tryParse(qty.text.trim());
                final harga = int.tryParse(price.text.trim());
                if (jumlah == null || jumlah <= 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Jumlah harus lebih dari 0.')),
                  );
                  return;
                }
                if (harga == null || harga < 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Harga jual tidak boleh negatif.'),
                    ),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(
                  _SaleReturnDraft(
                    product: product,
                    unit: unit,
                    qty: jumlah,
                    unitPrice: harga,
                  ),
                );
              },
              child: const Text('Tambahkan'),
            ),
          ],
        ),
      ),
    );
    qty.dispose();
    price.dispose();
    if (draft == null || !mounted) return;
    setState(() => _drafts.add(draft));
  }

  Future<void> _submitWithoutInvoice() async {
    if (_drafts.isEmpty) {
      _message('Tambahkan minimal satu barang yang diretur.');
      return;
    }

    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);
      final result = await recordSaleReturnWithoutInvoice(
        db,
        storeId: store.id,
        returnedAt: DateTime.now(),
        refundMethod: _method,
        reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
        lines: [
          for (final draft in _drafts)
            StandaloneReturnLineInput(
              productId: draft.product.id,
              unitId: draft.unit.id,
              qty: draft.qty,
              unitPrice: draft.unitPrice,
            ),
        ],
      );

      ref.invalidate(saleSummariesProvider);
      ref.invalidate(stockRowsProvider);
      ref.invalidate(lowStockGroupsProvider);
      ref.invalidate(inventoryValueProvider);

      if (!mounted) return;
      setState(() {
        _saving = false;
        _drafts.clear();
      });
      _message('Retur tersimpan. Refund ${formatRupiah(result.amount)}.');
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _message('Gagal menyimpan retur: $error');
    }
  }

  Widget _methodPicker() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Refund lewat',
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PayMethod>(
          isExpanded: true,
          value: _method,
          items: [
            for (final method in PayMethod.values)
              DropdownMenuItem(
                value: method,
                child: Text(_payMethodLabel(method)),
              ),
          ],
          onChanged: _saving
              ? null
              : (value) {
                  if (value == null) return;
                  setState(() => _method = value);
                },
        ),
      ),
    );
  }

  Widget _reasonField() {
    return TextField(
      controller: _reason,
      enabled: !_saving,
      decoration: const InputDecoration(
        labelText: 'Alasan retur (opsional)',
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sales = ref.watch(saleSummariesProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _withoutInvoice,
          onChanged: _saving
              ? null
              : (value) => setState(() {
                  _withoutInvoice = value;
                  _clearControllers();
                }),
          title: const Text('Tanpa struk'),
          subtitle: const Text(
            'Pelanggan tidak membawa transaksi asal. Harga jual diisi manual, '
            'HPP memakai rata-rata berjalan.',
          ),
        ),
        const Divider(),
        if (_withoutInvoice)
          ..._withoutInvoiceBody()
        else
          ..._withInvoiceBody(sales),
      ],
    );
  }

  List<Widget> _withoutInvoiceBody() {
    return [
      for (final draft in _drafts)
        Card(
          child: ListTile(
            title: Text('${draft.product.displayName} . ${draft.unit.name}'),
            subtitle: Text('${draft.qty} � ${formatRupiah(draft.unitPrice)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formatRupiah(draft.qty * draft.unitPrice)),
                IconButton(
                  tooltip: 'Hapus',
                  onPressed: _saving
                      ? null
                      : () => setState(() => _drafts.remove(draft)),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ),
      OutlinedButton.icon(
        onPressed: _saving ? null : _addDraft,
        icon: const Icon(Icons.add),
        label: const Text('Tambah barang'),
      ),
      const SizedBox(height: 12),
      _methodPicker(),
      const SizedBox(height: 12),
      _reasonField(),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: _saving ? null : _submitWithoutInvoice,
        icon: const Icon(Icons.assignment_return),
        label: Text(_saving ? 'Menyimpan.' : 'Simpan retur penjualan'),
      ),
    ];
  }

  List<Widget> _withInvoiceBody(AsyncValue<List<SaleSummary>> sales) {
    return [
      sales.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('Gagal membaca penjualan: $error'),
        data: (items) {
          if (items.isEmpty) {
            return const Text(
              'Belum ada transaksi penjualan. Pakai mode "Tanpa struk" bila '
              'pelanggan tidak membawa nota.',
            );
          }
          return InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Transaksi penjualan',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _saleId,
                hint: const Text('Pilih transaksi'),
                items: [
                  for (final item in items)
                    DropdownMenuItem(value: item.id, child: Text(item.label)),
                ],
                onChanged: (value) => setState(() {
                  _saleId = value;
                  _clearControllers();
                }),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      if (_saleId != null)
        ref
            .watch(returnableSaleLinesProvider(_saleId!))
            .when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Text('Gagal membaca barang: $error'),
              data: (lines) {
                if (lines.isEmpty) {
                  return const Text(
                    'Semua barang pada transaksi ini sudah diretur.',
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final line in lines)
                      _ReturnLineTile(
                        line: line,
                        controller: _controllerFor(line),
                        enabled: !_saving,
                      ),
                    const SizedBox(height: 12),
                    _methodPicker(),
                    const SizedBox(height: 12),
                    _reasonField(),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _saving ? null : () => _submit(lines),
                      icon: const Icon(Icons.assignment_return),
                      label: Text(
                        _saving ? 'Menyimpan.' : 'Simpan retur penjualan',
                      ),
                    ),
                  ],
                );
              },
            ),
    ];
  }
}

class _PurchaseReturnTab extends ConsumerStatefulWidget {
  const _PurchaseReturnTab();

  @override
  ConsumerState<_PurchaseReturnTab> createState() => _PurchaseReturnTabState();
}

class _PurchaseReturnTabState extends ConsumerState<_PurchaseReturnTab> {
  final _reason = TextEditingController();
  final _qty = <String, TextEditingController>{};
  String? _purchaseId;
  bool _saving = false;

  @override
  void dispose() {
    _reason.dispose();
    for (final controller in _qty.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _key(ReturnableLine line) => '${line.productId}|${line.unitId}';

  TextEditingController _controllerFor(ReturnableLine line) =>
      _qty.putIfAbsent(_key(line), TextEditingController.new);

  void _clearControllers() {
    for (final controller in _qty.values) {
      controller.clear();
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _submit(List<ReturnableLine> lines) async {
    final purchaseId = _purchaseId;
    if (purchaseId == null) return;

    final inputs = <ReturnLineInput>[];
    for (final line in lines) {
      final qty = int.tryParse(_controllerFor(line).text.trim()) ?? 0;
      if (qty <= 0) continue;
      inputs.add(
        ReturnLineInput(
          productId: line.productId,
          unitId: line.unitId,
          qty: qty,
        ),
      );
    }

    if (inputs.isEmpty) {
      _message('Isi jumlah yang ingin diretur minimal satu barang.');
      return;
    }

    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);
      final result = await recordPurchaseReturn(
        db,
        storeId: store.id,
        purchaseId: purchaseId,
        returnedAt: DateTime.now(),
        reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
        lines: inputs,
      );

      ref.invalidate(purchaseSummariesProvider);
      ref.invalidate(returnablePurchaseLinesProvider(purchaseId));
      ref.invalidate(stockRowsProvider);
      ref.invalidate(lowStockGroupsProvider);
      ref.invalidate(inventoryValueProvider);

      if (!mounted) return;
      setState(() => _saving = false);
      for (final line in lines) {
        _controllerFor(line).clear();
      }
      _message(
        'Retur pembelian tersimpan. Stok berkurang '
        '${result.qtyBase} satuan dasar.',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _message('Gagal menyimpan retur: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final purchases = ref.watch(purchaseSummariesProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        purchases.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text('Gagal membaca pembelian: $error'),
          data: (items) {
            if (items.isEmpty) {
              return const Text(
                'Belum ada dokumen pembelian yang bisa diretur.',
              );
            }
            return InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Dokumen pembelian',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _purchaseId,
                  hint: const Text('Pilih dokumen'),
                  items: [
                    for (final item in items)
                      DropdownMenuItem(value: item.id, child: Text(item.label)),
                  ],
                  onChanged: (value) => setState(() {
                    _purchaseId = value;
                    _clearControllers();
                  }),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Retur pembelian hanya mengurangi stok. Utang ke pemasok diurus '
          'di luar aplikasi.',
        ),
        const SizedBox(height: 12),
        if (_purchaseId != null)
          ref
              .watch(returnablePurchaseLinesProvider(_purchaseId!))
              .when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Text('Gagal membaca barang: $error'),
                data: (lines) {
                  if (lines.isEmpty) {
                    return const Text(
                      'Semua barang pada dokumen ini sudah diretur.',
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final line in lines)
                        _ReturnLineTile(
                          line: line,
                          controller: _controllerFor(line),
                          enabled: !_saving,
                        ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _reason,
                        enabled: !_saving,
                        decoration: const InputDecoration(
                          labelText: 'Alasan retur (opsional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _saving ? null : () => _submit(lines),
                        icon: const Icon(Icons.assignment_return),
                        label: Text(
                          _saving ? 'Menyimpan�?�' : 'Simpan retur pembelian',
                        ),
                      ),
                    ],
                  );
                },
              ),
      ],
    );
  }
}

class _ReturnLineTile extends StatelessWidget {
  const _ReturnLineTile({
    required this.line,
    required this.controller,
    required this.enabled,
  });

  final ReturnableLine line;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.productName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sisa ${line.remainingBase ~/ _factor(line)} '
                    '${line.unitName} �?� '
                    '${formatRupiah(line.unitPrice)} / ${line.unitName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 88,
              child: TextField(
                controller: controller,
                enabled: enabled,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: line.unitName,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _factor(ReturnableLine line) =>
      line.qty == 0 ? 1 : (line.qtyBase ~/ line.qty);
}

String _payMethodLabel(PayMethod method) => switch (method) {
  PayMethod.cash => 'Tunai',
  PayMethod.qris => 'QRIS',
  PayMethod.ewallet => 'E-wallet',
  PayMethod.transfer => 'Transfer',
  PayMethod.card => 'Kartu',
  PayMethod.credit => 'Kurangi utang pelanggan',
};

class _SaleReturnDraft {
  const _SaleReturnDraft({
    required this.product,
    required this.unit,
    required this.qty,
    required this.unitPrice,
  });

  final ProductChoice product;
  final UnitChoice unit;
  final int qty;
  final int unitPrice;

  int get amount => qty * unitPrice;
}
