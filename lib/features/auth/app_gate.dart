import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/auth/session_provider.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

/// Menentukan layar awal: beranda (lokal/login tersimpan) atau layar masuk.
///
/// Juga memicu sinkron saat app dibuka, kembali ke depan, dan tiap 3 menit.
class AppGate extends ConsumerStatefulWidget {
  const AppGate({super.key});

  @override
  ConsumerState<AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<AppGate> with WidgetsBindingObserver {
  Timer? _timer;
  SessionStatus? _lastStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onSessionChanged());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncQuietly();
    }
  }

  void _onSessionChanged() {
    final status = ref.read(sessionProvider).value?.status;
    if (status == _lastStatus) return;
    _lastStatus = status;

    _timer?.cancel();
    _timer = null;

    if (status == SessionStatus.signedIn) {
      _syncQuietly();
      _timer = Timer.periodic(
        const Duration(minutes: 3),
        (_) => _syncQuietly(),
      );
    }
  }

  void _syncQuietly() {
    final status = ref.read(sessionProvider).value?.status;
    if (status != SessionStatus.signedIn) return;
    unawaited(ref.read(syncControllerProvider.notifier).syncNow(force: true));
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    ref.listen(sessionProvider, (_, next) {
      if (next.hasValue) _onSessionChanged();
    });

    return session.when(
      loading: () => const _GateLoading(),
      error: (error, _) => _GateError(error: error),
      data: (value) {
        if (value.status == SessionStatus.signedIn ||
            value.status == SessionStatus.localOnly) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class _GateLoading extends StatelessWidget {
  const _GateLoading();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                gradient: AppPalette.of(context).heroGradient,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.pets, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 18),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 14),
            Text(
              'Menyiapkan toko…',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppPalette.of(context).muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _GateError extends ConsumerWidget {
  const _GateError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: palette.danger,
                size: 40,
              ),
              const SizedBox(height: 14),
              Text(
                'Gagal menyiapkan aplikasi',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: palette.muted),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => ref.invalidate(sessionProvider),
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
