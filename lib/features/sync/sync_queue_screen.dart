import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/db/app_database.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/time_format.dart';

/// Daftar operasi yang belum terkirim, termasuk yang perlu diselesaikan.
class SyncQueueScreen extends ConsumerWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final queue = ref.watch(syncQueueProvider);
    final status = ref.watch(syncControllerProvider).value;
    final conflicts = ref.watch(syncConflictsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Antrean sinkron')),
      body: queue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Gagal membaca antrean: $error')),
        data: (rows) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _QueueHeader(
                pending: rows.length + conflicts.length,
                failed: status?.failed ?? 0,
                conflicts: (status?.conflicts ?? 0) + conflicts.length,
                lastSyncAt: status?.lastSyncAt,
              ),
              const SizedBox(height: 14),
              if (conflicts.isNotEmpty) ...[
                ...conflicts.map(
                  (conflict) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ConflictTile(
                      conflict: conflict,
                      palette: palette,
                      onDismiss: () => ref
                          .read(syncControllerProvider.notifier)
                          .dismissConflict(conflict.key),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              FilledButton.icon(
                onPressed: status?.running == true
                    ? null
                    : () => ref
                          .read(syncControllerProvider.notifier)
                          .syncNow(force: true),
                icon: status?.running == true
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync_rounded, size: 19),
                label: Text(
                  status?.running == true
                      ? 'Sedang sinkron…'
                      : 'Coba kirim lagi',
                ),
              ),
              const SizedBox(height: 18),
              if (rows.isEmpty)
                _EmptyQueue(palette: palette)
              else
                ...rows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _QueueTile(row: row, palette: palette),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Data tetap aman di perangkat ini sampai berhasil terkirim. '
                'Baris berlabel "Perlu diselesaikan" biasanya karena barcode '
                'yang sama sudah dipakai perangkat lain.',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: palette.muted, height: 1.5),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QueueHeader extends StatelessWidget {
  const _QueueHeader({
    required this.pending,
    required this.failed,
    required this.conflicts,
    required this.lastSyncAt,
  });

  final int pending;
  final int failed;
  final int conflicts;
  final DateTime? lastSyncAt;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final well = pending == 0;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: well ? null : palette.heroGradient,
        color: well ? palette.card : null,
        borderRadius: BorderRadius.circular(22),
        border: well ? Border.all(color: palette.line) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: well
                      ? palette.success.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  well ? Icons.cloud_done_rounded : Icons.cloud_upload_rounded,
                  color: well ? palette.success : Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  well ? 'Semua sudah terkirim' : '$pending menunggu dikirim',
                  style: TextStyle(
                    color: well ? palette.ink : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            failed > 0
                ? '$failed gagal, $conflicts perlu diselesaikan. '
                      'Sinkron terakhir: ${formatTanggalWaktu(lastSyncAt)}.'
                : 'Sinkron terakhir: ${formatTanggalWaktu(lastSyncAt)}.',
            style: TextStyle(
              color: well
                  ? palette.muted
                  : Colors.white.withValues(alpha: 0.82),
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({required this.row, required this.palette});

  final OutboxData row;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final failed = row.lastError != null;
    final conflict = row.lastError?.startsWith('Bentrok') ?? false;
    final tint = conflict
        ? palette.warning
        : failed
        ? palette.danger
        : palette.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              conflict
                  ? Icons.report_gmailerrorred_rounded
                  : failed
                  ? Icons.error_outline_rounded
                  : Icons.schedule_rounded,
              size: 19,
              color: tint,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${row.targetTable} • ${row.op}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (conflict)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: palette.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          'Perlu diselesaikan',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: palette.warning,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Dibuat ${formatTanggalWaktu(row.createdAt)} • '
                  'percobaan ${row.attempts}',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontSize: 11, color: palette.muted),
                ),
                if (row.lastError != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    row.lastError!,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(fontSize: 11.5, color: tint, height: 1.4),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConflictTile extends StatelessWidget {
  const _ConflictTile({
    required this.conflict,
    required this.palette,
    required this.onDismiss,
  });

  final SyncConflict conflict;
  final AppPalette palette;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.infoBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.warning.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.report_gmailerrorred_rounded,
                size: 18,
                color: palette.warning,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Perlu diselesaikan • ${conflict.table}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: palette.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            conflict.message,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11, color: palette.muted, height: 1.4),
          ),
          const SizedBox(height: 3),
          Text(
            'Baris: ${conflict.rowId}',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 10.5, color: palette.muted),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onDismiss,
              child: const Text('Tandai selesai'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 36,
            color: palette.success,
          ),
          const SizedBox(height: 10),
          Text(
            'Tidak ada antrean',
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Semua perubahan sudah terkirim ke server.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: palette.muted),
          ),
        ],
      ),
    );
  }
}
