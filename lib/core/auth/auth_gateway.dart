/// Pengguna yang sedang login di Supabase Auth.
class AuthUser {
  const AuthUser({required this.id, this.email});

  final String id;
  final String? email;
}

/// Kesalahan autentikasi yang pesannya siap ditampilkan ke pemilik toko.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Pintu masuk autentikasi. Dipisah dari Supabase agar bisa diuji tanpa jaringan.
abstract class AuthGateway {
  AuthUser? get currentUser;

  /// Masuk dengan email + kata sandi. Melempar [AuthFailure] bila gagal.
  Future<AuthUser> signIn({required String email, required String password});

  /// Keluar. Harus tetap membersihkan sesi lokal walau jaringan mati.
  Future<void> signOut();

  /// Profil pengguna (store_id, role, display_name) dari server.
  Future<Map<String, dynamic>?> fetchProfile(String userId);

  /// Data toko dari server.
  Future<Map<String, dynamic>?> fetchStore(String storeId);
}
