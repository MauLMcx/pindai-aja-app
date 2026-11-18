import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/store/local_store.dart';
import 'product_picker.dart';
import 'putaway_service.dart';
import 'stock_providers.dart';
import 'stock_queries.dart';

/// Layar Susun Barang (SPEC §6.3): pilih produk, ubah lokasi rak.
class PutawayScreen extends ConsumerStatefulWidget {
  const PutawayScreen({super.key});

  @override
  ConsumerState<PutawayScreen> createState() => _PutawayScreenState();
}

class _PutawayScreenState extends ConsumerState<PutawayScreen> {
  final _location = TextEditingController();
  ProductChoice? _product;
  bool _saving = false;

  @override
  void dispose() {
    _location.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pick() async {
    final product = await showProductPicker(
      context,
      title: 'Pilih barang untuk disusun',
    );
    if (product == null || !mounted) return;
    setState(() {
      _product = product;
      _location.text = product.shelfLocation ?? '';
    });
  }

  Future<void> _save() async {
    final product = _product;
    if (product == null) return;

    setState(() => _saving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);
      final moved = await moveProductToShelf(
        db,
        storeId: store.id,
        productId: product.id,
        location: _location.text,
      );

      if (!mounted) return;
      ref.invalidate(stockRowsProvider);
      ref.invalidate(recentPutawayProvider);
      setState(() {
        _saving = false;
        _product = null;
        _location.clear();
      });
      _message(
        moved
            ? 'Lokasi rak diperbarui.'
            : 'Lokasi tidak berubah, tidak ada riwayat baru.',
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _message('Gagal menyimpan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(recentPutawayProvider);
    final product = _product;

    return Scaffold(
      appBar: AppBar(title: const Text('Susun Barang')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: product == null
                ? const ListTile(
                    leading: Icon(Icons.qr_code_scanner),
                    title: Text('Belum ada barang dipilih'),
                    subtitle: Text('Pilih barang, lalu isi lokasi raknya.'),
                  )
                : ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(product.displayName),
                    subtitle: Text(
                      'Rak saat ini: ${product.shelfLocation ?? "belum diatur"}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Ganti barang',
                      onPressed: _saving ? null : _pick,
                      icon: const Icon(Icons.swap_horiz),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          if (product == null)
            FilledButton.icon(
              onPressed: _saving ? null : _pick,
              icon: const Icon(Icons.search),
              label: const Text('Pilih barang'),
            )
          else ...[
            TextField(
              controller: _location,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Lokasi rak (${product.baseUnit} disimpan di sini)',
                hintText: 'Contoh: Rak A-3',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Menyimpan…' : 'Simpan lokasi'),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Riwayat penataan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          history.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Gagal membaca riwayat: $error'),
            data: (items) {
              if (items.isEmpty) {
                return const Text('Belum ada riwayat penataan.');
              }
              return Column(
                children: [
                  for (final row in items)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.swap_vert),
                      title: Text(row.productName),
                      subtitle: Text(
                        '${row.fromLocation ?? "belum diatur"} → '
                        '${row.toLocation ?? "dikosongkan"}',
                      ),
                      trailing: Text(
                        '${row.occurredAt.toLocal().day}/'
                        '${row.occurredAt.toLocal().month} '
                        '${row.occurredAt.toLocal().hour.toString().padLeft(2, "0")}:'
                        '${row.occurredAt.toLocal().minute.toString().padLeft(2, "0")}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
