import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/money.dart';
import '../../core/store/local_store.dart';
import 'product_picker.dart';
import 'purchase_service.dart';
import 'stock_providers.dart';
import 'stock_queries.dart';

class _DraftLine {
  const _DraftLine({
    required this.product,
    required this.unit,
    required this.qty,
    required this.unitCost,
  });

  final ProductChoice product;
  final UnitChoice unit;
  final int qty;
  final int unitCost;

  int get amount => qty * unitCost;
  String get label => '${product.name} • ${unit.name}';
}

/// Layar Barang Masuk (SPEC §6.2).
class PurchaseScreen extends ConsumerStatefulWidget {
  const PurchaseScreen({super.key});

  @override
  ConsumerState<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends ConsumerState<PurchaseScreen> {
  final _docNo = TextEditingController();
  final _note = TextEditingController();
  final _drafts = <_DraftLine>[];

  DateTime _purchasedAt = DateTime.now();
  String? _supplierId;
  bool _saving = false;

  @override
  void dispose() {
    _docNo.dispose();
    _note.dispose();
    super.dispose();
  }

  int get _total => _drafts.fold<int>(0, (sum, line) => sum + line.amount);

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchasedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() => _purchasedAt = picked);
  }

  Future<void> _addProduct() async {
    final product = await showProductPicker(
      context,
      title: 'Pilih barang masuk',
    );
    if (product == null || !mounted) return;
    if (product.units.isEmpty) {
      _message('Produk ini belum punya satuan. Lengkapi dulu di data produk.');
      return;
    }
    final unit = product.defaultPurchaseUnit ?? product.units.first;
    final db = ref.read(appDatabaseProvider);
    final lastPrice = await lastBuyPrice(db, unit.id);
    if (!mounted) return;
    final draft = await _askQuantity(product, unit, lastPrice);
    if (draft == null) return;
    setState(() => _drafts.add(draft));
  }

  Future<_DraftLine?> _askQuantity(
    ProductChoice product,
    UnitChoice initialUnit,
    int? lastPrice,
  ) {
    var unit = initialUnit;
    final qty = TextEditingController(text: '1');
    final cost = TextEditingController(
      text: lastPrice == null ? '' : lastPrice.toString(),
    );

    return showDialog<_DraftLine>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(product.displayName),
              content: SingleChildScrollView(
                child: Column(
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
                              DropdownMenuItem(
                                value: item,
                                child: Text(item.name),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setDialogState(() => unit = value);
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
                      controller: cost,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Harga beli per ${unit.name}',
                        prefixText: 'Rp ',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    if (lastPrice != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Harga beli terakhir: ${formatRupiah(lastPrice)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final jumlah = int.tryParse(qty.text.trim());
                    final harga = int.tryParse(cost.text.trim());
                    if (jumlah == null || jumlah <= 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Jumlah harus lebih dari 0.'),
                        ),
                      );
                      return;
                    }
                    if (harga == null || harga < 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Harga beli tidak boleh negatif.'),
                        ),
                      );
                      return;
                    }
                    Navigator.of(dialogContext).pop(
                      _DraftLine(
                        product: product,
                        unit: unit,
                        qty: jumlah,
                        unitCost: harga,
                      ),
                    );
                  },
                  child: const Text('Tambahkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _save() async {
    if (_drafts.isEmpty) {
      _message('Tambahkan minimal satu barang.');
      return;
    }

    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);
      final result = await recordPurchase(
        db,
        storeId: store.id,
        supplierId: _supplierId,
        docNo: _docNo.text.trim().isEmpty ? null : _docNo.text.trim(),
        purchasedAt: _purchasedAt,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        lines: [
          for (final line in _drafts)
            PurchaseLineInput(
              productId: line.product.id,
              unitId: line.unit.id,
              qty: line.qty,
              unitCost: line.unitCost,
            ),
        ],
      );

      if (!mounted) return;
      ref.invalidate(stockRowsProvider);
      ref.invalidate(lowStockGroupsProvider);
      ref.invalidate(inventoryValueProvider);
      ref.invalidate(purchaseSummariesProvider);
      await _showResult(result);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _message('Gagal menyimpan: $error');
    }
  }

  Future<void> _showResult(PurchaseSaveResult result) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pembelian tersimpan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${result.itemCount} baris barang'),
            Text('Total ${formatRupiah(result.total)}'),
            if (result.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Perhatian, harga beli berubah:',
                style: Theme.of(dialogContext).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              for (final warning in result.warnings)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• ${warning.message}'),
                ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(suppliersProvider);
    final tanggal =
        '${_purchasedAt.day}/${_purchasedAt.month}/${_purchasedAt.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Barang Masuk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          suppliers.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Gagal membaca pemasok: $error'),
            data: (items) => InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Pemasok',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: _supplierId,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Tanpa pemasok'),
                    ),
                    for (final supplier in items)
                      DropdownMenuItem<String?>(
                        value: supplier.id,
                        child: Text(supplier.name),
                      ),
                  ],
                  onChanged: (value) => setState(() => _supplierId = value),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _saving ? null : _pickDate,
            icon: const Icon(Icons.event),
            label: Text('Tanggal: $tanggal'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _docNo,
            decoration: const InputDecoration(
              labelText: 'Nomor nota (opsional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text('Barang', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_drafts.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.add_shopping_cart),
                title: Text('Belum ada barang'),
                subtitle: Text('Tambahkan barang yang masuk.'),
              ),
            ),
          for (var index = 0; index < _drafts.length; index++)
            Card(
              child: ListTile(
                title: Text(_drafts[index].label),
                subtitle: Text(
                  '${_drafts[index].qty} ${_drafts[index].unit.name} × '
                  '${formatRupiah(_drafts[index].unitCost)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(formatRupiah(_drafts[index].amount)),
                    IconButton(
                      tooltip: 'Hapus',
                      onPressed: _saving
                          ? null
                          : () => setState(() => _drafts.removeAt(index)),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _saving ? null : _addProduct,
            icon: const Icon(Icons.add),
            label: const Text('Tambah barang'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _note,
            decoration: const InputDecoration(
              labelText: 'Catatan (opsional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Total pembelian'),
              trailing: Text(
                formatRupiah(_total),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(_saving ? 'Menyimpan…' : 'Simpan pembelian'),
          ),
        ],
      ),
    );
  }
}
