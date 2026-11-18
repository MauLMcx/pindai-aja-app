import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/settings/theme_mode_provider.dart';
import '../../core/theme/app_theme.dart';

/// Pengaturan sederhana: pilihan tema terang, gelap, atau ikut sistem.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final mode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

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
        ],
      ),
    );
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
