import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show BooleanExpressionOperators;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/auth/session_provider.dart';
import '../../core/backup/backup_service.dart';
import '../../core/db/database_provider.dart';
import '../../core/settings/theme_mode_provider.dart';
import '../../core/store/local_store.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/time_format.dart';
import '../auth/login_screen.dart';
import '../products/products_providers.dart';
import '../sync/sync_queue_screen.dart';

/// Pengaturan: tema, akun, sinkron, dan backup.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _busy;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final session = ref.watch(sessionProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _SettingsHeader(palette: palette),
          const SizedBox(height: 22),
          Text(
            'Tampilan',
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih tampilan yang paling nyaman untuk matamu.',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            icon: Icons.brightness_auto_rounded,
            title: 'Ikuti sistem',
            description: 'Terang saat HP terang, gelap saat HP gelap.',
            selected: mode == ThemeMode.system,
            onTap: () =>
                ref.read(themeModeProvider.notifier).select(ThemeMode.system),
          ),
          const SizedBox(height: 10),
          _ThemeOption(
            icon: Icons.light_mode_rounded,
            title: 'Terang',
            description: 'Latar terang, cocok untuk siang hari.',
            selected: mode == ThemeMode.light,
            onTap: () =>
                ref.read(themeModeProvider.notifier).select(ThemeMode.light),
          ),
          const SizedBox(height: 10),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            title: 'Gelap',
            description: 'Latar gelap, lebih nyaman saat malam.',
            selected: mode == ThemeMode.dark,
            onTap: () =>
                ref.read(themeModeProvider.notifier).select(ThemeMode.dark),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: palette.infoBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: palette.warning,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pilihan tema tersimpan di perangkat ini dan tetap sama '
                    'saat aplikasi dibuka kembali.',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: palette.muted, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _SectionTitle(
            title: 'Akun & toko',
            subtitle: 'Satu akun untuk semua perangkat toko.',
            palette: palette,
          ),
          const SizedBox(height: 10),
          if (session == null)
            _LoadingCard(palette: palette)
          else if (session.isSignedIn)
            _AccountCard(
              session: session,
              palette: palette,
              onSignOut: _signOut,
            )
          else if (session.isLocalOnly)
            _NoteCard(
              palette: palette,
              icon: Icons.phonelink_lock_rounded,
              title: 'Mode lokal',
              message:
                  session.message ??
                  'Sinkron belum diatur. Data tersimpan di perangkat ini.',
            )
          else
            _LoginCard(
              palette: palette,
              message: session.message,
              onLogin: _openLogin,
            ),
          const SizedBox(height: 26),
          _SectionTitle(
            title: 'Sinkron',
            subtitle: 'Kasir tidak pernah menunggu jaringan.',
            palette: palette,
          ),
          const SizedBox(height: 10),
          _SyncCard(
            palette: palette,
            signedIn: session?.isSignedIn ?? false,
            onOpenQueue: _openQueue,
          ),
          if (session?.canManage ?? true) ...[
            const SizedBox(height: 26),
            _SectionTitle(
              title: 'Backup',
              subtitle: 'Salinan data untuk berjaga-jaga.',
              palette: palette,
            ),
            const SizedBox(height: 10),
            _BackupCard(
              palette: palette,
              busy: _busy,
              onExport: _exportBackup,
              onRestore: _restoreBackup,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text(
          'Data lokal tetap tersimpan. Kamu perlu masuk lagi untuk sinkron.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(sessionProvider.notifier).signOut();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sudah keluar.')));
    }
  }

  void _openLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
  }

  void _openQueue() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const SyncQueueScreen()));
  }

  Future<void> _exportBackup() async {
    setState(() => _busy = 'export');
    try {
      final db = ref.read(appDatabaseProvider);
      final data = await buildBackup(db);
      final bytes = Uint8List.fromList(
        utf8.encode(const JsonEncoder.withIndent('  ').convert(data)),
      );
      final uri = await FilePicker.saveFile(
        dialogTitle: 'Simpan backup petshop',
        fileName: 'petshop-backup-${_stamp(DateTime.now())}.json',
        bytes: bytes,
        mimeType: 'application/json',
      );
      if (!mounted) return;
      if (uri != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File backup berhasil disimpan.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal membuat backup: $error')));
      }
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _restoreBackup() async {
    final picked = await FilePicker.pickFile(
      dialogTitle: 'Pilih file backup petshop',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (picked == null || !mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pulihkan backup?'),
        content: const Text(
          'Semua data di perangkat ini akan DIGANTI dengan isi file backup. '
          'Buat backup data sekarang dulu bila belum yakin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Pulihkan'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = 'restore');
    try {
      final text = utf8.decode(
        await picked.readAsBytes(),
        allowMalformed: true,
      );
      final result = await restoreBackup(ref.read(appDatabaseProvider), text);
      ref.invalidate(productListProvider);
      ref.invalidate(localStoreProvider);
      ref.invalidate(sessionProvider);
      await ref.read(syncControllerProvider.notifier).reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Backup dipulihkan: ${result.rows} baris dari '
              '${result.tables} tabel.',
            ),
          ),
        );
      }
    } on FormatException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memulihkan backup: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  String _stamp(DateTime at) {
    final month = at.month.toString().padLeft(2, '0');
    final day = at.day.toString().padLeft(2, '0');
    final hour = at.hour.toString().padLeft(2, '0');
    final minute = at.minute.toString().padLeft(2, '0');
    return '${at.year}-$month-$day-$hour$minute';
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: palette.heroGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atur tampilan toko',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Sesuaikan tema dengan suasana tokomu.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12,
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

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);

    return Material(
      color: selected ? palette.primary.withValues(alpha: 0.08) : palette.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: selected ? palette.primary : palette.line,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, size: 21, color: palette.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 13.5,
                        color: palette.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.5,
                        color: palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? palette.primary : Colors.transparent,
                  border: Border.all(
                    color: selected ? palette.primary : palette.line,
                    width: 1.6,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: palette.onPrimary,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.palette,
  });

  final String title;
  final String subtitle;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: palette.muted),
        ),
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.session,
    required this.palette,
    required this.onSignOut,
  });

  final AppSession session;
  final AppPalette palette;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  size: 22,
                  color: palette.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.displayName ?? session.email ?? 'Pengguna',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.email ?? 'Tanpa email',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontSize: 11.5, color: palette.muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  session.roleLabel,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: palette.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _KeyValue(
            label: 'Toko',
            value: session.storeName ?? '-',
            palette: palette,
          ),
          const SizedBox(height: 6),
          _KeyValue(
            label: 'Perangkat',
            value: session.deviceId == null
                ? '-'
                : session.deviceId!.substring(0, 8),
            palette: palette,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.palette,
    required this.message,
    required this.onLogin,
  });

  final AppPalette palette;
  final String? message;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 20,
                color: palette.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Belum masuk',
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ],
          ),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: palette.muted, height: 1.4),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onLogin,
            icon: const Icon(Icons.login_rounded, size: 18),
            label: const Text('Masuk'),
          ),
        ],
      ),
    );
  }
}

class _SyncCard extends ConsumerWidget {
  const _SyncCard({
    required this.palette,
    required this.signedIn,
    required this.onOpenQueue,
  });

  final AppPalette palette;
  final bool signedIn;
  final VoidCallback onOpenQueue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncControllerProvider).value;
    final pending = status?.pending ?? 0;
    final failed = status?.failed ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                failed > 0
                    ? Icons.cloud_off_rounded
                    : pending > 0
                    ? Icons.cloud_upload_outlined
                    : Icons.cloud_done_outlined,
                size: 20,
                color: failed > 0
                    ? palette.danger
                    : pending > 0
                    ? palette.warning
                    : palette.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  failed > 0
                      ? '$failed gagal dikirim'
                      : pending > 0
                      ? '$pending menunggu dikirim'
                      : 'Tersinkron',
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5),
                ),
              ),
              if (status?.running == true)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Sinkron terakhir: ${formatTanggalWaktu(status?.lastSyncAt)}',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11.5, color: palette.muted),
          ),
          if (status?.message != null) ...[
            const SizedBox(height: 4),
            Text(
              status!.message!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11.5,
                color: failed > 0 ? palette.danger : palette.muted,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: !signedIn || status?.running == true
                    ? null
                    : () => ref
                          .read(syncControllerProvider.notifier)
                          .syncNow(force: true),
                icon: const Icon(Icons.sync_rounded, size: 18),
                label: const Text('Sinkron sekarang'),
              ),
              OutlinedButton.icon(
                onPressed: onOpenQueue,
                icon: const Icon(Icons.list_alt_rounded, size: 18),
                label: const Text('Antrean sinkron'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackupCard extends ConsumerWidget {
  const _BackupCard({
    required this.palette,
    required this.busy,
    required this.onExport,
    required this.onRestore,
  });

  final AppPalette palette;
  final String? busy;
  final VoidCallback onExport;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastBackup = ref.watch(_lastBackupProvider).value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.backup_outlined, size: 20, color: palette.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Backup terakhir: ${formatTanggalWaktu(lastBackup)}',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontSize: 11.5, color: palette.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: busy == null ? onExport : null,
                icon: busy == 'export'
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_alt_rounded, size: 18),
                label: const Text('Buat file backup'),
              ),
              OutlinedButton.icon(
                onPressed: busy == null ? onRestore : null,
                icon: busy == 'restore'
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.restore_rounded, size: 18),
                label: const Text('Pulihkan'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Backup harian ditulis otomatis ke folder aplikasi saat app dibuka. '
            'Salin file backup ke Google Drive secara berkala agar aman bila HP '
            'hilang.',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11, color: palette.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11.5, color: palette.muted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11.5,
              color: palette.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.palette,
    required this.icon,
    required this.title,
    required this.message,
  });

  final AppPalette palette;
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: palette.warning),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: palette.muted, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.line),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

final _lastBackupProvider = FutureProvider<DateTime?>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final store = await ensureLocalStore(db);
  final row =
      await (db.select(db.appSettings)..where(
            (t) => t.storeId.equals(store.id) & t.key.equals(lastBackupAtKey),
          ))
          .getSingleOrNull();
  return DateTime.tryParse(row?.value ?? '');
});
