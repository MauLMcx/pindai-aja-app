import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money.dart';
import '../import/import_screen.dart';
import '../products/products_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Petshop'),
        actions: [
          IconButton(
            tooltip: 'Impor produk',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ImportScreen()),
            ),
            icon: const Icon(Icons.upload_file),
          ),
        ],
      ),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Gagal membaca database: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (items) => _ProductList(items: items),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.items});

  final List<ProductListItem> items;

  @override
  Widget build(BuildContext context) {
    final needsReview = items.where((item) => item.needsPriceReview).length;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.isEmpty ? 3 : items.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _CardGap(
            child: ListTile(
              leading: Icon(Icons.cloud_off),
              title: Text('Mode offline aktif'),
              subtitle: Text(
                'Kasir tetap berjalan tanpa internet. Sinkron berjalan di latar belakang.',
              ),
            ),
          );
        }
        if (index == 1) {
          return _CardGap(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Produk'),
              subtitle: Text('${items.length} produk'),
              trailing: needsReview == 0
                  ? null
                  : Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text('$needsReview perlu dicek'),
                    ),
            ),
          );
        }
        if (items.isEmpty) {
          return const _CardGap(
            child: ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Belum ada produk'),
              subtitle: Text(
                'Impor data awal dari file CSV lewat tombol di kanan atas.',
              ),
            ),
          );
        }
        return _CardGap(child: _ProductTile(item: items[index - 2]));
      },
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.item});

  final ProductListItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = item.variant == null
        ? item.name
        : '${item.name} (${item.variant})';
    final details = [
      if (item.brand != null) item.brand!,
      if (item.supplierName != null) item.supplierName!,
      if (item.unitName != null) 'per ${item.unitName}',
      if (item.needsPriceReview) 'perlu cek harga',
    ].join(' • ');

    return ListTile(
      leading: item.needsPriceReview
          ? Icon(Icons.warning_amber_rounded, color: theme.colorScheme.tertiary)
          : const Icon(Icons.pets),
      title: Text(title),
      subtitle: details.isEmpty ? null : Text(details),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            item.buyPrice == null
                ? 'Harga belum ada'
                : formatRupiah(item.buyPrice!),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Stok ${item.stockBase} ${item.baseUnit}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _CardGap extends StatelessWidget {
  const _CardGap({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(child: child),
    );
  }
}
