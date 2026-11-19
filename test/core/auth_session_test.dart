import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/auth/auth_gateway.dart';
import 'package:petshop_pos/core/auth/session_provider.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/core/store/local_store.dart';

void main() {
  late AppDatabase db;
  late Store store;

  setUp(() async {
    db = AppDatabase.memory();
    store = await ensureLocalStore(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('login menyimpan profil, peran, dan identitas perangkat', () async {
    final gateway = _FakeAuthGateway(
      profile: _profile(store.id, role: 'owner'),
      store: _store(store.id),
    );
    final container = _container(db, gateway);
    addTearDown(container.dispose);

    final before = await container.read(sessionProvider.future);
    expect(before.status, SessionStatus.signedOut);

    await container
        .read(sessionProvider.notifier)
        .signIn(email: 'pemilik@toko.id', password: 'rahasia123');

    final session = container.read(sessionProvider).value!;
    expect(session.status, SessionStatus.signedIn);
    expect(session.role, UserRole.owner);
    expect(session.canManage, isTrue);
    expect(session.storeId, store.id);
    expect(session.displayName, 'Pemilik Toko');
    expect(session.deviceId, isNotNull);

    final cached = await db.select(db.profiles).get();
    expect(cached.single.userId, 'u-owner');
    expect(cached.single.storeId, store.id);
  });

  test(
    'S8: setelah login, aplikasi tetap terbuka walau tanpa internet',
    () async {
      final online = _FakeAuthGateway(
        profile: _profile(store.id, role: 'owner'),
        store: _store(store.id),
      );
      final first = _container(db, online);
      addTearDown(first.dispose);
      await first
          .read(sessionProvider.notifier)
          .signIn(email: 'pemilik@toko.id', password: 'rahasia123');
      expect(first.read(sessionProvider).value!.isSignedIn, isTrue);

      // Perangkat dibuka lagi saat jaringan mati dan sesi Supabase tidak bisa
      // diperbarui: identitas login terakhir + profil dibaca dari cache.
      online.offline = true;
      online.forgetSession();
      final second = _container(db, online);
      addTearDown(second.dispose);

      final restored = await second.read(sessionProvider.future);
      expect(restored.status, SessionStatus.signedIn);
      expect(restored.userId, 'u-owner');
      expect(restored.storeId, store.id);
      expect(restored.message, contains('tanpa internet'));
    },
  );

  test('kasir hanya boleh memakai kasir, bukan impor/pengaturan', () async {
    final gateway = _FakeAuthGateway(
      profile: _profile(store.id, role: 'staff', name: 'Kasir Satu'),
      store: _store(store.id),
    );
    final container = _container(db, gateway);
    addTearDown(container.dispose);

    await container
        .read(sessionProvider.notifier)
        .signIn(email: 'kasir@toko.id', password: 'rahasia123');

    final session = container.read(sessionProvider).value!;
    expect(session.role, UserRole.staff);
    expect(session.canManage, isFalse);
    expect(session.roleLabel, 'Kasir');
  });

  test('akun tanpa profil toko ditolak dan sesi dibersihkan', () async {
    final gateway = _FakeAuthGateway();
    final container = _container(db, gateway);
    addTearDown(container.dispose);

    await container.read(sessionProvider.future);

    await expectLater(
      container
          .read(sessionProvider.notifier)
          .signIn(email: 'asing@toko.id', password: 'rahasia123'),
      throwsA(isA<AuthFailure>()),
    );
    expect(gateway.signOutCalls, 1);
  });

  test('keluar menghapus sesi tersimpan tetapi data lokal tetap ada', () async {
    final gateway = _FakeAuthGateway(
      profile: _profile(store.id, role: 'owner'),
      store: _store(store.id),
    );
    final container = _container(db, gateway);
    addTearDown(container.dispose);

    await container
        .read(sessionProvider.notifier)
        .signIn(email: 'pemilik@toko.id', password: 'rahasia123');
    await container.read(sessionProvider.notifier).signOut();

    final session = container.read(sessionProvider).value!;
    expect(session.status, SessionStatus.signedOut);

    gateway.offline = true;
    final reopened = _container(db, gateway);
    addTearDown(reopened.dispose);
    final restored = await reopened.read(sessionProvider.future);
    expect(restored.status, SessionStatus.signedOut);

    // Profil tidak dihapus saat keluar.
    expect(await db.select(db.profiles).get(), isNotEmpty);
  });

  test(
    'tanpa konfigurasi server aplikasi jatuh ke mode lokal pemilik',
    () async {
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          authGatewayProvider.overrideWithValue(null),
        ],
      );
      addTearDown(container.dispose);

      final session = await container.read(sessionProvider.future);
      expect(session.status, SessionStatus.localOnly);
      expect(session.role, UserRole.owner);
      expect(session.canManage, isTrue);
      expect(session.storeName, 'Toko Utama');
    },
  );
}

ProviderContainer _container(AppDatabase db, AuthGateway gateway) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      authGatewayProvider.overrideWithValue(gateway),
    ],
  );
}

Map<String, dynamic> _profile(
  String storeId, {
  required String role,
  String name = 'Pemilik Toko',
}) {
  final now = DateTime.utc(2026, 11, 19, 8).toIso8601String();
  return {
    'user_id': role == 'owner' ? 'u-owner' : 'u-staff',
    'store_id': storeId,
    'role': role,
    'display_name': name,
    'created_at': now,
    'updated_at': now,
  };
}

Map<String, dynamic> _store(String storeId) {
  final now = DateTime.utc(2026, 11, 19, 8).toIso8601String();
  return {
    'id': storeId,
    'name': 'Toko Utama',
    'code2': '01',
    'created_at': now,
    'updated_at': now,
  };
}

class _FakeAuthGateway implements AuthGateway {
  _FakeAuthGateway({this.profile, this.store});

  Map<String, dynamic>? profile;
  Map<String, dynamic>? store;

  /// Meniru perangkat tanpa internet.
  bool offline = false;
  int signOutCalls = 0;

  AuthUser? _user;

  void forgetSession() => _user = null;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    if (offline) throw const AuthFailure('Tidak ada internet.');
    _user = AuthUser(
      id: (profile?['user_id'] as String?) ?? 'u-owner',
      email: email,
    );
    return _user!;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _user = null;
  }

  @override
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    if (offline) throw const AuthFailure('Tidak ada internet.');
    return profile;
  }

  @override
  Future<Map<String, dynamic>?> fetchStore(String storeId) async {
    if (offline) throw const AuthFailure('Tidak ada internet.');
    return store;
  }
}
