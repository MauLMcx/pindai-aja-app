import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Impor Produk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data awal dari Excel',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih file CSV yang dihasilkan skrip impor. Sebelumnya, '
                    'koreksi dulu harga yang ditandai di file itu.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _busy ? null : _pickAndImport,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Pilih file CSV'),
                  ),
                ],
              ),
            ),
          ),
          if (_busy) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
            const SizedBox(height: 8),
            const Text('Membaca file dan menyimpan produk…'),
          ],
          if (_error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.error,
                ),
                title: const Text('Impor gagal'),
                subtitle: Text(_error!),
              ),
            ),
          ],
          if (_outcome != null) ...[
            const SizedBox(height: 16),
            _OutcomeCard(outcome: _outcome!),
          ],
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Stok belum diisi'),
              subtitle: const Text(
                'File ini hanya berisi harga beli. Stok awal dicatat saat '
                'opname pertama, bukan dari file.',
              ),
            ),
          ),
          if (_outcome != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.list_alt),
              label: const Text('Lihat daftar produk'),
            ),
          ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Impor selesai', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _Line('Produk baru', '${outcome.inserted}'),
            _Line('Dilewati (sudah ada)', '${outcome.skippedExisting}'),
            _Line('Perlu dicek harganya', '${outcome.needsReview}'),
            _Line(
              'Pemasok / kategori baru',
              '${outcome.newSuppliers} / ${outcome.newCategories}',
            ),
            if (outcome.problems.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Catatan', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              for (final problem in outcome.problems.take(10))
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• $problem'),
                ),
              if (outcome.problems.length > 10)
                Text('… dan ${outcome.problems.length - 10} catatan lain.'),
            ],
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
