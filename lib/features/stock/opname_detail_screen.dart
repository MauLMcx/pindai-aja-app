import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/money.dart';
import '../../core/store/local_store.dart';
import 'opname_service.dart';
import 'product_picker.dart';
import 'stock_providers.dart';

/// Layar hitung satu sesi opname (SPEC §6.8).
class OpnameDetailScreen extends ConsumerWidget {
  const OpnameDetailScreen({
    super.key,
    required this.opnameId,
    required this.isOpen,
  });

  final String opnameId;
  final bool isOpen;

  Future<void> _count(
    BuildContext context,
    WidgetRef ref,
    List<OpnameItemRow> existing,
  ) async {
    final product = await showProductPicker(context, title: 'Hitung barang');
    if (product == null || !context.mounted) return;

    OpnameItemRow? previous;
    for (final item in existing) {
      if (item.productId == product.id) {
        previous = item;
        break;
      }
    }

    final counted = TextEditingController(
      text: previous?.countedBase.toString() ?? '',
    );
    final amount = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(product.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stok buku: ${product.stockBase} ${product.baseUnit}'),
            const SizedBox(height: 12),
            TextField(
              controller: counted,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah fisik (${product.baseUnit})',
                border: const OutlineInputBorder(),
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
              final value = int.tryParse(counted.text.trim());
              if (value == null || value < 0) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Jumlah fisik harus angka 0 atau lebih.'),
                  ),
                );
                return;
              }
              Navigator.of(dialogContext).pop(value);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    counted.dispose();
    if (amount == null || !context.mounted) return;

    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);
      await setOpnameCount(
        db,
        storeId: store.id,
        opnameId: opnameId,
        productId: product.id,
        countedBase: amount,
      );
      ref.invalidate(opnameItemsProvider(opnameId));
      ref.invalidate(opnameSummariesProvider);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan hitungan: $error')),
      );
    }
  }

  Future<void> _finish(
    BuildContext context,
    WidgetRef ref,
    List<OpnameItemRow> items,
  ) async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hitung minimal satu barang sebelum menyelesaikan.'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Selesaikan opname?'),
        content: const Text(
          'Selisih terhadap stok buku akan dicatat sebagai penyesuaian stok. '
          'Sesi yang sudah selesai tidak bisa diubah lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final db = ref.read(appDatabaseProvider);
      final store = await ensureLocalStore(db);
      final result = await finishOpname(
        db,
        storeId: store.id,
        opnameId: opnameId,
      );
      ref.invalidate(opnameItemsProvider(opnameId));
      ref.invalidate(opnameSummariesProvider);
      ref.invalidate(stockRowsProvider);
      ref.invalidate(lowStockGroupsProvider);
      ref.invalidate(inventoryValueProvider);
      if (!context.mounted) return;
      await showOpnameResult(context, result);
      if (context.mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyelesaikan opname: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(opnameItemsProvider(opnameId));

    return Scaffold(
      appBar: AppBar(title: Text(isOpen ? 'Hitung Opname' : 'Hasil Opname')),
      floatingActionButton: isOpen
          ? FloatingActionButton.extended(
              onPressed: () => _count(context, ref, items.value ?? const []),
              icon: const Icon(Icons.add),
              label: const Text('Hitung barang'),
            )
          : null,
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Gagal membaca opname: $error'),
          ),
        ),
        data: (rows) {
          if (rows.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada barang dihitung. Tekan "Hitung barang" untuk '
                  'memasukkan jumlah fisik.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    final diff = row.diffBase;
                    return ListTile(
                      title: Text(row.productName),
                      subtitle: Text(
                        'Fisik ${row.countedBase} ${row.baseUnit}'
                        '${row.expectedBase == null ? "" : " • buku ${row.expectedBase} ${row.baseUnit}"}',
                      ),
                      trailing: isOpen
                          ? IconButton(
                              tooltip: 'Ubah hitungan',
                              onPressed: () => _count(context, ref, rows),
                              icon: const Icon(Icons.edit_outlined),
                            )
                          : Text(
                              diff == null
                                  ? '-'
                                  : '${diff > 0 ? "+" : ""}$diff',
                              style: TextStyle(
                                color: diff == 0
                                    ? null
                                    : diff! > 0
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    );
                  },
                ),
              ),
              if (isOpen)
                SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _finish(context, ref, rows),
                      icon: const Icon(Icons.check),
                      label: const Text('Selesaikan opname'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Menampilkan hasil opname (selisih dan nilainya) setelah sesi selesai.
Future<void> showOpnameResult(BuildContext context, OpnameFinishResult result) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Opname selesai'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.rows.isEmpty)
              const Text('Tidak ada selisih stok. Semua cocok.')
            else ...[
              Text('${result.adjustedCount} barang disesuaikan'),
              Text('Nilai selisih ${formatRupiah(result.totalValueRupiah)}'),
              const SizedBox(height: 12),
              for (final row in result.rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• ${row.productName}: buku ${row.expectedBase}, '
                    'fisik ${row.countedBase} ${row.baseUnit} '
                    '(${row.diffBase > 0 ? "+" : ""}${row.diffBase})',
                  ),
                ),
            ],
          ],
        ),
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
