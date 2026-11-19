import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Kredensial Supabase dibaca dari `--dart-define`, bukan dari file rahasia.
///
/// Hanya `anon`/publishable key yang boleh ada di aplikasi (SPEC P9).
/// Contoh:
///   flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///               --dart-define=SUPABASE_ANON_KEY=eyJ...
const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

bool get hasSupabaseConfig =>
    supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

bool _ready = false;
String? _initError;

/// Apakah Supabase berhasil disiapkan pada proses ini.
bool get isSupabaseReady => _ready;

/// Pesan kegagalan inisialisasi (tanpa kredensial), untuk ditampilkan di UI.
String? get supabaseInitError => _initError;

/// Menyiapkan Supabase bila kredensial tersedia.
///
/// Aplikasi tetap bisa dipakai tanpa konfigurasi ini (mode lokal/offline).
/// Tidak ada jaringan yang wajib berhasil di sini: sesi tersimpan dibaca dari
/// penyimpanan lokal sehingga app tetap terbuka saat mati lampu (S8).
Future<void> initSupabaseIfConfigured() async {
  if (!hasSupabaseConfig) {
    _ready = false;
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
    _ready = true;
    _initError = null;
  } catch (error) {
    _ready = false;
    _initError = 'Supabase gagal disiapkan: $error';
    debugPrint(_initError);
  }
}
