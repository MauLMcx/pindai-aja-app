import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import 'stock_queries.dart';

/// Membuka pemilih produk. Mengembalikan `null` bila dibatalkan.
Future<ProductChoice?> showProductPicker(
  BuildContext context, {
  String title = 'Pilih produk',
}) {
  return Navigator.of(context).push<ProductChoice>(
    MaterialPageRoute<ProductChoice>(
      builder: (_) => _ProductPickerPage(title: title),
    ),
  );
}

class _ProductPickerPage extends ConsumerStatefulWidget {
  const _ProductPickerPage({required this.title});

  final String title;

  @override
  ConsumerState<_ProductPickerPage> createState() => _ProductPickerPageState();
}

class _ProductPickerPageState extends ConsumerState<_ProductPickerPage> {
  final _search = TextEditingController();
  late Future<List<ProductChoice>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load('');
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<List<ProductChoice>> _load(String term) {
    final db = ref.read(appDatabaseProvider);
    return loadProductChoices(db, search: term.trim().isEmpty ? null : term);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Cari nama atau barcode',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _future = _load(value)),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductChoice>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _Message(
                    'Gagal membaca produk: ${snapshot.error}',
                    icon: Icons.error_outline,
                  );
                }
                final items = snapshot.data ?? const <ProductChoice>[];
                if (items.isEmpty) {
                  return const _Message(
                    'Produk tidak ditemukan.',
                    icon: Icons.search_off,
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final product = items[index];
                    final units = product.units
                        .map((unit) => unit.name)
                        .join(', ');
                    return ListTile(
                      title: Text(product.displayName),
                      subtitle: Text(
                        [
                          if (product.brand != null) product.brand!,
                          'stok ${product.stockBase} ${product.baseUnit}',
                          if (product.shelfLocation != null)
                            'rak ${product.shelfLocation}',
                          if (units.isNotEmpty) units,
                        ].join(' • '),
                      ),
                      onTap: () => Navigator.of(context).pop(product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text, {required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
