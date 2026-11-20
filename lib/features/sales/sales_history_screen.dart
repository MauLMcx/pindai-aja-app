import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/auth/session_provider.dart';
import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/money.dart';
import '../../core/theme/app_theme.dart';
import '../cashier/cashier_providers.dart';
import '../products/products_providers.dart';
import 'receipt_text.dart';
import 'sale_service.dart';

/// Riwayat transaksi terbaru (maksimal 200 baris agar tetap ringan).
final salesHistoryProvider = StreamProvider<List<Sale>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.sales)
        ..orderBy([(t) => OrderingTerm.desc(t.soldAt)])
        ..limit(200))
      .watch();
});

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final sales = ref.watch(salesHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat transaksi')),
      body: sales.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Gagal memuat: $error')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('Belum ada transaksi'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final sale = items[index];
                  return _SaleTile(
                    sale: sale,
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: palette.canvas,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (_) => _SaleDetailSheet(saleId: sale.id),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.sale, required this.onTap});

  final Sale sale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isVoid = sale.status == SaleStatus.voided;
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.line),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (isVoid ? palette.danger : palette.primary).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  isVoid ? Icons.cancel_outlined : Icons.receipt_long_rounded,
                  size: 20,
                  color: isVoid ? palette.danger : palette.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.receiptNo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDateTime(sale.soldAt.toLocal()),
                      style: TextStyle(fontSize: 11.5, color: palette.muted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatRupiah(sale.total),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: isVoid ? palette.muted : palette.ink,
                      decoration: isVoid ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (isVoid) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Dibatalkan',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: palette.danger,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaleDetailSheet extends ConsumerStatefulWidget {
  const _SaleDetailSheet({required this.saleId});

  final String saleId;

  @override
  ConsumerState<_SaleDetailSheet> createState() => _SaleDetailSheetState();
}

class _SaleDetailSheetState extends ConsumerState<_SaleDetailSheet> {
  late Future<_SaleDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_SaleDetail> _load() async {
    final db = ref.read(appDatabaseProvider);
    final sale = await (db.select(
      db.sales,
    )..where((t) => t.id.equals(widget.saleId))).getSingle();
    final items = await (db.select(
      db.saleItems,
    )..where((t) => t.saleId.equals(sale.id))).get();
    final lines = <ReceiptLine>[];
    for (final item in items) {
      final product = await (db.select(
        db.products,
      )..where((t) => t.id.equals(item.productId))).getSingleOrNull();
      final unit = await (db.select(
        db.productUnits,
      )..where((t) => t.id.equals(item.unitId))).getSingleOrNull();
      lines.add(
        ReceiptLine(
          name: product?.name ?? 'Produk',
          unitName: unit?.unitName ?? 'pcs',
          qty: item.qty,
          unitPrice: item.unitPrice,
          discount: item.discount,
          lineTotal: item.lineTotal,
        ),
      );
    }
    final store = await ref.read(localStoreProvider.future);
    return _SaleDetail(
      sale: sale,
      lines: lines,
      storeName: store.name,
      text: buildReceiptText(
        storeName: store.name,
        sale: sale,
        lines: lines,
        changeAmount: sale.changeAmount,
      ),
    );
  }

  Future<void> _reprint(_SaleDetail detail) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cetak ulang struk'),
        content: SingleChildScrollView(
          child: Text(
            detail.text,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _void(_SaleDetail detail) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan transaksi?'),
        content: const Text(
          'Stok akan dikembalikan dan transaksi ditandai batal. '
          'Data tidak dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      final session = await ref.read(sessionProvider.future);
      final identity = await ref.read(localIdentityProvider.future);
      final store = await ref.read(localStoreProvider.future);
      final db = ref.read(appDatabaseProvider);
      await SaleService(
        db,
        storeId: store.id,
        deviceId: identity.deviceId,
        deviceCode: identity.deviceCode,
      ).voidSale(
        saleId: detail.sale.id,
        byUserId: session.userId ?? identity.cashierId,
      );
      if (!mounted) return;
      setState(() => _future = _load());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Transaksi dibatalkan, stok dikembalikan.'),
          ),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Gagal membatalkan: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final canVoid = ref.watch(sessionProvider).value?.canManage ?? true;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: FutureBuilder<_SaleDetail>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Gagal memuat: ${snapshot.error}'));
              }
              final detail = snapshot.data!;
              final sale = detail.sale;
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.line,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sale.receiptNo,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatDateTime(sale.soldAt.toLocal()),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: palette.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Tutup',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: palette.line),
                        ),
                        child: Text(
                          detail.text,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    decoration: BoxDecoration(
                      color: palette.card,
                      border: Border(top: BorderSide(color: palette.line)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _reprint(detail),
                              icon: const Icon(Icons.print_outlined, size: 18),
                              label: const Text('Cetak ulang'),
                            ),
                          ),
                          if (canVoid &&
                              sale.status == SaleStatus.completed) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _void(detail),
                                style: FilledButton.styleFrom(
                                  backgroundColor: palette.danger,
                                ),
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 18,
                                ),
                                label: const Text('Batalkan'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SaleDetail {
  const _SaleDetail({
    required this.sale,
    required this.lines,
    required this.storeName,
    required this.text,
  });

  final Sale sale;
  final List<ReceiptLine> lines;
  final String storeName;
  final String text;
}

String _formatDateTime(DateTime value) {
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(value.day)}-${two(value.month)}-${value.year} '
      '${two(value.hour)}:${two(value.minute)}';
}
