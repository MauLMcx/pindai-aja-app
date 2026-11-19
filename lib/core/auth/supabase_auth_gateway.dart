import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'auth_gateway.dart';

/// Implementasi [AuthGateway] memakai Supabase Auth + PostgREST.
class SupabaseAuthGateway implements AuthGateway {
  SupabaseAuthGateway(this._client);

  final SupabaseClient _client;

  @override
  AuthUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AuthUser(id: user.id, email: user.email);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const AuthFailure('Masuk gagal: pengguna tidak ditemukan.');
      }
      return AuthUser(id: user.id, email: user.email);
    } on AuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    } catch (error) {
      throw AuthFailure(
        'Tidak bisa masuk. Periksa koneksi internet lalu coba lagi. ($error)',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Scope lokal: sesi di perangkat dibersihkan walau server tak terjangkau.
      await _client.auth.signOut(scope: SignOutScope.local);
    } catch (_) {
      // Abaikan: tujuan utamanya sesi lokal hilang.
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    try {
      return await _client
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
    } catch (error) {
      throw AuthFailure(
        'Profil pengguna gagal dimuat. Pastikan internet aktif. ($error)',
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchStore(String storeId) async {
    try {
      return await _client
          .from('stores')
          .select()
          .eq('id', storeId)
          .maybeSingle();
    } catch (error) {
      throw AuthFailure('Data toko gagal dimuat. ($error)');
    }
  }

  String _messageFor(AuthException error) {
    switch (error.code) {
      case 'invalid_credentials':
        return 'Email atau kata sandi salah.';
      case 'email_not_confirmed':
        return 'Email belum dikonfirmasi. Cek kotak masuk emailmu.';
      case 'over_request_rate_limit':
      case 'over_email_send_rate_limit':
        return 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';
      case 'user_banned':
        return 'Akun ini diblokir. Hubungi pemilik toko.';
      default:
        return error.message.isEmpty
            ? 'Masuk gagal. Coba lagi.'
            : 'Masuk gagal: ${error.message}';
    }
  }
}
