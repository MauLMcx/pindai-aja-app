import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'product_sheet.dart';
import 'purchase_screen.dart';
import 'stock_providers.dart';

/// Layar Stok: daftar stok dan daftar "Perlu dibeli" (SPEC §6.7).
class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stok'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Stok'),
              Tab(text: 'Perlu dibeli'),
            ],
          ),
        ),
        body: TabBarView(children: [_stockTab(), _lowStockTab()]),
      ),
    );
  }

  Widget _stockTab() {
    final rows = ref.watch(stockRowsProvider);
    final term = _search.text.trim().toLowerCase();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Cari nama, merek, atau barcode',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: rows.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _Message('Gagal membaca stok: $error'),
            data: (items) {
              final filtered = term.isEmpty
                  ? items
                  : items
                        .where(
                          (row) =>
                              row.name.toLowerCase().contains(term) ||
                              (row.brand ?? '').toLowerCase().contains(term) ||
                              (row.variant ?? '').toLowerCase().contains(term),
                        )
                        .toList();
              if (filtered.isEmpty) {
                return _Message(
                  items.isEmpty
                      ? 'Belum ada produk. Impor produk dulu di layar utama.'
                      : 'Produk tidak ditemukan.',
                );
              }
              return ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final row = filtered[index];
                  return ListTile(
                    isThreeLine: true,
                    leading: Icon(
                      row.isLow
                          ? Icons.warning_amber_rounded
                          : Icons.inventory_2_outlined,
                      color: row.isLow
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                    title: Text(row.displayName),
                    subtitle: Text(
                      [
                        if (row.brand != null) row.brand!,
                        'Stok ${row.stockBase} ${row.baseUnit}',
                        if (row.minStockBase > 0) 'minimum ${row.minStockBase}',
                        if (row.shelfLocation != null)
                          'rak ${row.shelfLocation}',
                      ].join(' • '),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showProductSheet(context, row: row),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _lowStockTab() {
    final groups = ref.watch(lowStockGroupsProvider);

    return groups.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _Message('Gagal membaca daftar: $error'),
      data: (items) {
        if (items.isEmpty) {
          return const _Message(
            'Semua stok aman. Produk akan muncul di sini bila stok di bawah '
            'minimum yang diatur.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.shopping_cart_outlined),
                      title: Text(
                        '${items.length} pemasok punya barang menipis',
                      ),
                      subtitle: const Text(
                        'Belanja ke pemasok ini untuk mengisi stok.',
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PurchaseScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Catat barang masuk'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            for (final group in items) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: Text(
                  group.supplierName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final row in group.rows)
                Card(
                  child: ListTile(
                    title: Text(row.displayName),
                    subtitle: Text(
                      'Stok ${row.stockBase} ${row.baseUnit} • '
                      'minimum ${row.minStockBase} • '
                      'kurang ${row.shortfallBase} ${row.baseUnit}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showProductSheet(context, row: row),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
