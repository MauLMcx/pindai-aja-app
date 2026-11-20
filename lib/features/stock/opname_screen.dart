import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/store/local_store.dart';
import 'opname_detail_screen.dart';
import 'opname_service.dart';
import 'stock_providers.dart';
import 'stock_queries.dart';

/// Daftar sesi stok opname (SPEC §6.8).
class OpnameScreen extends ConsumerWidget {
  const OpnameScreen({super.key});

  Future<void> _start(BuildContext context, WidgetRef ref, String scope) async {
    final db = ref.read(appDatabaseProvider);
    final store = await ensureLocalStore(db);
    final note = scope.trim();
    final label = note.isEmpty ? 'Seluruh toko' : note;
    final opnameId = await startOpname(db, storeId: store.id, scope: label);
    ref.invalidate(opnameSummariesProvider);
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            OpnameDetailScreen(opnameId: opnameId, isOpen: true, scope: label),
      ),
    );
    ref.invalidate(opnameSummariesProvider);
  }

  Future<void> _askStart(BuildContext context, WidgetRef ref) async {
    final db = ref.read(appDatabaseProvider);
    final options = await loadOpnameScopeOptions(db);
    if (!context.mounted) return;
    final scope = await showDialog<String>(
      context: context,
      builder: (_) => _StartOpnameDialog(options: options),
    );
    if (scope == null || !context.mounted) return;
    try {
      await _start(context, ref, scope);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memulai opname: $error')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(opnameSummariesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stok Opname')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _askStart(context, ref),
        icon: const Icon(Icons.playlist_add_check),
        label: const Text('Mulai opname'),
      ),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Gagal membaca opname: $error'),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada opname. Tekan "Mulai opname" untuk menghitung '
                  'stok fisik.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Icon(
                  item.isOpen ? Icons.edit_note : Icons.check_circle_outline,
                ),
                title: Text(item.scope ?? 'Stok opname'),
                subtitle: Text(
                  '${item.isOpen ? "Berjalan" : "Selesai"} • '
                  '${item.itemCount} barang dihitung\n'
                  'Mulai ${_formatDateTime(item.startedAt)}'
                  '${item.finishedAt == null ? "" : " • Selesai ${_formatDateTime(item.finishedAt!)}"}',
                ),
                isThreeLine: true,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OpnameDetailScreen(
                        opnameId: item.id,
                        isOpen: item.isOpen,
                        scope: item.scope,
                      ),
                    ),
                  );
                  ref.invalidate(opnameSummariesProvider);
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Dialog "Mulai stok opname". Controller dimiliki widget ini agar
/// di-dispose saat rute dialog benar-benar selesai (bukan tepat setelah
/// `showDialog` mengembalikan hasil).
class _StartOpnameDialog extends StatefulWidget {
  const _StartOpnameDialog({required this.options});

  final List<OpnameScopeOption> options;

  @override
  State<_StartOpnameDialog> createState() => _StartOpnameDialogState();
}

class _StartOpnameDialogState extends State<_StartOpnameDialog> {
  late String _scope;

  @override
  void initState() {
    super.initState();
    _scope = widget.options.isEmpty
        ? 'Seluruh toko'
        : widget.options.first.label;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mulai stok opname'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Hitung barang fisik, lalu masukkan jumlahnya. Selisih akan '
              'dicatat sebagai penyesuaian stok saat opname diselesaikan.',
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Cakupan',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _scope,
                  items: [
                    for (final option in widget.options)
                      DropdownMenuItem(
                        value: option.label,
                        child: Text(option.label),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _scope = value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_scope),
          child: const Text('Mulai'),
        ),
      ],
    );
  }
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} $hour:$minute';
}
