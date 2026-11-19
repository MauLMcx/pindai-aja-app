import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/database_provider.dart';
import '../../core/store/local_store.dart';
import 'opname_detail_screen.dart';
import 'opname_service.dart';
import 'stock_providers.dart';

/// Daftar sesi stok opname (SPEC §6.8).
class OpnameScreen extends ConsumerWidget {
  const OpnameScreen({super.key});

  Future<void> _start(
    BuildContext context,
    WidgetRef ref,
    String scope,
  ) async {
    final db = ref.read(appDatabaseProvider);
    final store = await ensureLocalStore(db);
    final note = scope.trim();
    final opnameId = await startOpname(
      db,
      storeId: store.id,
      scope: note.isEmpty ? 'Seluruh toko' : note,
    );
    ref.invalidate(opnameSummariesProvider);
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OpnameDetailScreen(opnameId: opnameId, isOpen: true),
      ),
    );
    ref.invalidate(opnameSummariesProvider);
  }

  Future<void> _askStart(BuildContext context, WidgetRef ref) async {
    final scope = await showDialog<String>(
      context: context,
      builder: (_) => const _StartOpnameDialog(),
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

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} $hour:$minute';
}
