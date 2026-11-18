import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/money.dart';
import 'stock_queries.dart';

/// Riwayat harga beli/jual satu produk (SPEC §6.2).
class PriceHistoryScreen extends ConsumerWidget {
  const PriceHistoryScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  final String productId;
  final String productName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat harga • $productName')),
      body: FutureBuilder<List<PriceHistoryRow>>(
        future: loadPriceHistory(db, productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Gagal membaca riwayat: ${snapshot.error}'),
              ),
            );
          }
          final items = snapshot.data ?? const <PriceHistoryRow>[];
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada riwayat harga. Riwayat tercatat otomatis '
                  'saat barang masuk atau harga jual diubah.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final row = items[index];
              final tanggal = row.effectiveAt.toLocal();
              return ListTile(
                leading: Icon(
                  row.kind.name == 'buy' ? Icons.south_west : Icons.north_east,
                ),
                title: Text('${formatRupiah(row.price)} / ${row.unitName}'),
                subtitle: Text(
                  '${row.kind.name == 'buy' ? 'Harga beli' : 'Harga jual'} • '
                  '${tanggal.day}/${tanggal.month}/${tanggal.year}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
