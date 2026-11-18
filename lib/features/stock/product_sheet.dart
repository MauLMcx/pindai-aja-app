import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/store/local_store.dart';
import '../products/products_providers.dart';
import 'price_history_screen.dart';
import 'product_service.dart';
import 'putaway_service.dart';
import 'stock_providers.dart';
import 'stock_queries.dart';

/// Lembar bawah untuk mengatur stok minimum dan lokasi rak satu produk.
Future<void> showProductSheet(BuildContext context, {required StockRow row}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ProductSheet(row: row),
  );
}

class _ProductSheet extends ConsumerStatefulWidget {
  const _ProductSheet({required this.row});

  final StockRow row;

  @override
  ConsumerState<_ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends ConsumerState<_ProductSheet> {
  late final TextEditingController _minStock;
  late final TextEditingController _shelf;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _minStock = TextEditingController(text: widget.row.minStockBase.toString());
    _shelf = TextEditingController(text: widget.row.shelfLocation ?? '');
  }

  @override
  void dispose() {
    _minStock.dispose();
    _shelf.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final minStock = int.tryParse(_minStock.text.trim());
    if (minStock == null || minStock < 0) {
      _showMessage('Stok minimum harus angka 0 atau lebih.');
      return;
    }

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);

      await updateProductMinStock(
        db,
        storeId: store.id,
        productId: widget.row.productId,
        minStockBase: minStock,
      );
      await moveProductToShelf(
        db,
        storeId: store.id,
        productId: widget.row.productId,
        location: _shelf.text,
      );

      if (!mounted) return;
      ref.invalidate(stockRowsProvider);
      ref.invalidate(lowStockGroupsProvider);
      ref.invalidate(inventoryValueProvider);
      ref.invalidate(productListProvider);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Produk diperbarui.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $error')),
      );
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(row.displayName, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Stok ${row.stockBase} ${row.baseUnit} • '
            'minimum ${row.minStockBase}',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _minStock,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Stok minimum (${row.baseUnit})',
              helperText: 'Isi 0 bila tidak perlu peringatan stok menipis.',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _shelf,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Lokasi rak',
              hintText: 'Contoh: Rak A-3',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(_saving ? 'Menyimpan…' : 'Simpan'),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: _saving
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PriceHistoryScreen(
                        productId: row.productId,
                        productName: row.name,
                      ),
                    ),
                  ),
            icon: const Icon(Icons.history),
            label: const Text('Riwayat harga'),
          ),
        ],
      ),
    );
  }
}
