import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money.dart';
import '../import/import_screen.dart';
import '../products/products_providers.dart';
import '../stock/stock_home_screen.dart';
import '../stock/stock_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    final lowStock = ref.watch(lowStockGroupsProvider);
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
      body: Column(
        children: [
          _LowStockBanner(
            count: lowStock.maybeWhen(
              data: (groups) =>
                  groups.fold<int>(0, (sum, group) => sum + group.rows.length),
              orElse: () => 0,
            ),
          ),
          Expanded(
            child: products.when(
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
          ),
        ],
      ),
    );
  }
}

/// Pengingat stok menipis saat app dibuka (SPEC §6.7), tanpa server push.
class _LowStockBanner extends StatelessWidget {
  const _LowStockBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const StockHomeScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$count barang di bawah stok minimum. Perlu dibeli.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ],
          ),
        ),
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
      itemCount: items.isEmpty ? 4 : items.length + 3,
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
              title: const Text('Stok & Inventaris'),
              subtitle: const Text(
                'Barang masuk, penataan, opname, retur, dan daftar stok.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const StockHomeScreen(),
                ),
              ),
            ),
          );
        }
        if (index == 2) {
          return _CardGap(
            child: ListTile(
              leading: const Icon(Icons.pets),
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
        return _CardGap(child: _ProductTile(item: items[index - 3]));
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
