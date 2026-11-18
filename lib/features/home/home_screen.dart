import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/money.dart';
import '../../core/theme/app_theme.dart';
import '../import/import_screen.dart';
import '../products/products_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    return Scaffold(
      body: products.when(
        loading: () => const _HomeLoading(),
        error: (error, _) => _HomeError(error: error),
        data: (items) => _HomeView(items: items),
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({required this.items});

  final List<ProductListItem> items;

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  bool _reviewOnly = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openImport() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ImportScreen()));
  }

  List<ProductListItem> get _visibleItems {
    final query = _query.trim().toLowerCase();
    return widget.items.where((item) {
      if (_reviewOnly && !item.needsPriceReview) return false;
      if (query.isEmpty) return true;
      final haystack = [
        item.name,
        item.variant,
        item.brand,
        item.supplierName,
        item.unitName,
        item.baseUnit,
      ].whereType<String>().join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final needsReview = widget.items
        .where((item) => item.needsPriceReview)
        .length;
    final visible = _visibleItems;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 4 + (visible.isEmpty ? 1 : visible.length),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _HomeHeader(onImport: _openImport);
          case 1:
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: _SummaryRow(
                total: widget.items.length,
                needsReview: needsReview,
              ),
            );
          case 2:
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _search,
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Cari produk, merek, atau pemasok',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Hapus pencarian',
                              onPressed: () {
                                _search.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close_rounded, size: 20),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _FilterChip(
                        label: 'Semua',
                        selected: !_reviewOnly,
                        onTap: () => setState(() => _reviewOnly = false),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: needsReview == 0
                            ? 'Perlu dicek'
                            : 'Perlu dicek ($needsReview)',
                        selected: _reviewOnly,
                        onTap: () => setState(() => _reviewOnly = true),
                      ),
                    ],
                  ),
                ],
              ),
            );
          case 3:
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Daftar Produk',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  Text(
                    '${visible.length} tampil',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            );
          default:
            if (visible.isEmpty) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: _EmptyState(
                  hasProducts: widget.items.isNotEmpty,
                  onImport: _openImport,
                  onReset: () {
                    _search.clear();
                    setState(() {
                      _query = '';
                      _reviewOnly = false;
                    });
                  },
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: _ProductCard(item: visible[index - 4]),
            );
        }
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onImport});

  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: Stack(
          children: [
            Positioned(right: -50, top: -60, child: _Bubble(size: 170)),
            Positioned(right: 70, bottom: -80, child: _Bubble(size: 140)),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kasir Petshop',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Kasir & stok toko dalam satu genggaman',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.78),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Impor produk',
                          onPressed: onImport,
                          icon: const Icon(Icons.upload_file_rounded, size: 22),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.16,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.cloud_off_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mode offline aktif',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Kasir tetap berjalan tanpa internet. '
                                  'Sinkron berjalan di latar belakang.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.78),
                                    fontSize: 11.5,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.total, required this.needsReview});

  final int total;
  final int needsReview;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.inventory_2_outlined,
            value: '$total produk',
            label: 'Total produk',
            tint: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: needsReview == 0
                ? Icons.verified_outlined
                : Icons.rate_review_outlined,
            value: needsReview == 0
                ? 'Harga lengkap'
                : '$needsReview perlu dicek',
            label: 'Status harga',
            tint: needsReview == 0 ? AppColors.success : AppColors.warning,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: tint),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: selected ? AppColors.primary : AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.item});

  final ProductListItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final review = item.needsPriceReview;
    final tint = review ? AppColors.warning : AppColors.primary;
    final title = item.variant == null
        ? item.name
        : '${item.name} (${item.variant})';
    final meta = [
      if (item.brand != null) item.brand!,
      if (item.supplierName != null) item.supplierName!,
      if (item.unitName != null) 'per ${item.unitName}',
    ].join(' • ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              review ? Icons.warning_amber_rounded : Icons.pets,
              color: tint,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(fontSize: 14.5),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    meta,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 9),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Pill(
                      icon: Icons.inventory_2_outlined,
                      text: 'Stok ${item.stockBase} ${item.baseUnit}',
                      tint: item.stockBase <= 0
                          ? AppColors.warning
                          : AppColors.muted,
                    ),
                    if (review)
                      const _Pill(
                        icon: Icons.rate_review_outlined,
                        text: 'Perlu cek harga',
                        tint: AppColors.warning,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _PriceTag(item: item),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text, required this.tint});

  final IconData icon;
  final String text;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: tint),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: tint,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.item});

  final ProductListItem item;

  @override
  Widget build(BuildContext context) {
    if (item.buyPrice == null) {
      return const Text(
        'Harga belum ada',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        formatRupiah(item.buyPrice!),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDeep,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.hasProducts,
    required this.onImport,
    required this.onReset,
  });

  final bool hasProducts;
  final VoidCallback onImport;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasProducts ? Icons.search_off_rounded : Icons.pets,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasProducts ? 'Tidak ada produk yang cocok' : 'Belum ada produk',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasProducts
                ? 'Coba kata kunci lain atau tampilkan semua produk.'
                : 'Impor data awal dari file CSV. Tombol impor juga '
                      'tersedia di kanan atas.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          if (hasProducts)
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Tampilkan semua'),
            )
          else
            FilledButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.upload_file_rounded, size: 18),
              label: const Text('Impor dari CSV'),
            ),
        ],
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text(
            'Menyiapkan data toko…',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _HomeError extends ConsumerWidget {
  const _HomeError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.danger,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Gagal membaca database',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(productListProvider),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
