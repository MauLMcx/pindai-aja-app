import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money.dart';
import 'opname_screen.dart';
import 'purchase_screen.dart';
import 'putaway_screen.dart';
import 'return_screen.dart';
import 'stock_providers.dart';
import 'stock_screen.dart';

/// Pintu masuk fitur stok: barang masuk, penataan, opname, retur, daftar stok.
class StockHomeScreen extends ConsumerWidget {
  const StockHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryValueProvider);
    final lowStock = ref.watch(lowStockGroupsProvider);

    final lowCount = lowStock.maybeWhen(
      data: (groups) => groups.fold<int>(0, (sum, g) => sum + g.rows.length),
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Stok & Inventaris')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: const Text('Nilai persediaan'),
              subtitle: Text(
                inventory.maybeWhen(
                  data: (value) => formatRupiah(value),
                  orElse: () => 'Menghitung…',
                ),
              ),
            ),
          ),
          if (lowCount != null && lowCount > 0)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                leading: const Icon(Icons.warning_amber_rounded),
                title: Text('$lowCount barang di bawah stok minimum'),
                subtitle: const Text('Buka tab "Perlu dibeli" di daftar stok.'),
                onTap: () => _open(context, const StockScreen()),
              ),
            ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              _MenuCard(
                icon: Icons.inventory_2_outlined,
                label: 'Daftar Stok',
                onTap: () => _open(context, const StockScreen()),
              ),
              _MenuCard(
                icon: Icons.add_shopping_cart,
                label: 'Barang Masuk',
                onTap: () => _open(context, const PurchaseScreen()),
              ),
              _MenuCard(
                icon: Icons.shelves,
                label: 'Susun Barang',
                onTap: () => _open(context, const PutawayScreen()),
              ),
              _MenuCard(
                icon: Icons.playlist_add_check,
                label: 'Stok Opname',
                onTap: () => _open(context, const OpnameScreen()),
              ),
              _MenuCard(
                icon: Icons.assignment_return,
                label: 'Retur',
                onTap: () => _open(context, const ReturnScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
