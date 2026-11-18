import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/theme/app_theme.dart';
import '../products/products_providers.dart';
import 'product_importer.dart';

/// Memuat CSV hasil impor Excel ke database lokal (SPEC §14).
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  bool _busy = false;
  ImportOutcome? _outcome;
  String? _error;

  Future<void> _pickAndImport() async {
    setState(() {
      _busy = true;
      _outcome = null;
      _error = null;
    });

    try {
      final file = await FilePicker.pickFile(
        dialogTitle: 'Pilih file CSV hasil impor Excel',
        type: FileType.custom,
        allowedExtensions: const ['csv'],
      );
      if (file == null) return;

      final csv = utf8.decode(await file.readAsBytes(), allowMalformed: true);
      final store = await ref.read(localStoreProvider.future);
      final db = ref.read(appDatabaseProvider);
      final outcome = await importProductCsvText(
        db,
        storeId: store.id,
        csv: csv,
      );

      if (!mounted) return;
      setState(() => _outcome = outcome);
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (error) {
      if (mounted) setState(() => _error = 'Gagal mengimpor: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impor Produk')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const _ImportHero(),
          const SizedBox(height: 16),
          const _StepsCard(),
          const SizedBox(height: 16),
          _UploadCard(busy: _busy, onPick: _pickAndImport),
          if (_error != null) ...[
            const SizedBox(height: 16),
            _ErrorCard(message: _error!),
          ],
          if (_outcome != null) ...[
            const SizedBox(height: 16),
            _OutcomeCard(outcome: _outcome!),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.list_alt_rounded, size: 18),
              label: const Text('Lihat daftar produk'),
            ),
          ],
          const SizedBox(height: 16),
          const _InfoCard(),
        ],
      ),
    );
  }
}

class _ImportHero extends StatelessWidget {
  const _ImportHero();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: palette.heroGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.table_view_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data awal dari Excel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Harga beli & daftar produk',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Pilih file CSV yang dihasilkan skrip impor. Sebelumnya, koreksi '
            'dulu harga yang ditandai di file itu.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cara impor',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          const _Step(
            number: '1',
            text: 'Periksa harga di file CSV, terutama yang bertanda perlu dicek.',
          ),
          const SizedBox(height: 12),
          const _Step(
            number: '2',
            text: 'Tekan tombol pilih file, lalu cari file .csv tersebut.',
          ),
          const SizedBox(height: 12),
          const _Step(
            number: '3',
            text: 'Tunggu sampai ringkasan impor muncul di bawah.',
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: palette.primaryDeep,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({required this.busy, required this.onPick});

  final bool busy;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.upload_file_rounded,
              size: 30,
              color: palette.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'File CSV siap diimpor',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Format .csv, pemisah koma',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: busy ? null : onPick,
              icon: const Icon(Icons.folder_open_rounded, size: 18),
              label: const Text('Pilih file CSV'),
            ),
          ),
          if (busy) ...[
            const SizedBox(height: 18),
            const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: LinearProgressIndicator(minHeight: 6),
            ),
            const SizedBox(height: 10),
            Text(
              'Membaca file dan menyimpan produk…',
              style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.danger.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: palette.danger, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Impor gagal',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: palette.danger,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({required this.outcome});

  final ImportOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.success.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: palette.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: palette.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Impor selesai',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Produk baru',
                  value: '${outcome.inserted}',
                  tint: palette.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Metric(
                  label: 'Dilewati',
                  value: '${outcome.skippedExisting}',
                  tint: palette.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Perlu dicek',
                  value: '${outcome.needsReview}',
                  tint: outcome.needsReview == 0
                      ? palette.success
                      : palette.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Metric(
                  label: 'Pemasok / kategori',
                  value: '${outcome.newSuppliers} / ${outcome.newCategories}',
                  tint: palette.primary,
                ),
              ),
            ],
          ),
          if (outcome.problems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Catatan',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            for (final problem in outcome.problems.take(10))
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(
                      child: Text(problem, style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            if (outcome.problems.length > 10)
              Text(
                '… dan ${outcome.problems.length - 10} catatan lain.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.tint});

  final String label;
  final String value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: tint,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: palette.muted),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.infoBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: palette.warning.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: palette.warning,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stok belum diisi',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'File ini hanya berisi harga beli. Stok awal dicatat saat '
                  'opname pertama, bukan dari file.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                    height: 1.45,
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
