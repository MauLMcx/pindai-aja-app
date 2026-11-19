import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../device/device_identity.dart';
import '../store/local_store.dart';
import '../supabase/supabase_config.dart';
import 'auth_gateway.dart';
import 'supabase_auth_gateway.dart';

/// Kunci `app_settings` untuk identitas login terakhir (khusus perangkat).
const String lastSignedInUserSettingKey = 'last_signed_in_user';

enum SessionStatus {
  /// Supabase belum diatur; aplikasi hanya memakai data lokal.
  localOnly,

  /// Supabase siap, tetapi belum ada sesi/login.
  signedOut,

  /// Sudah login dan profil toko tersedia (boleh offline).
  signedIn,
}

class AppSession {
  const AppSession({
    required this.status,
    required this.role,
    this.userId,
    this.email,
    this.storeId,
    this.storeName,
    this.displayName,
    this.deviceId,
    this.message,
  });

  final SessionStatus status;
  final UserRole role;
  final String? userId;
  final String? email;
  final String? storeId;
  final String? storeName;
  final String? displayName;
  final String? deviceId;

  /// Keterangan tambahan untuk UI (misalnya kenapa belum bisa login).
  final String? message;

  bool get isSignedIn => status == SessionStatus.signedIn;
  bool get isLocalOnly => status == SessionStatus.localOnly;

  /// HPP, laporan laba, pengaturan, dan pengelolaan pengguna hanya untuk owner.
  bool get canManage => role == UserRole.owner;

  String get roleLabel => role == UserRole.owner ? 'Pemilik' : 'Kasir';
}

final authGatewayProvider = Provider<AuthGateway?>((ref) {
  if (!isSupabaseReady) return null;
  return SupabaseAuthGateway(Supabase.instance.client);
});

class SessionController extends AsyncNotifier<AppSession> {
  @override
  Future<AppSession> build() async {
    final db = ref.watch(appDatabaseProvider);
    final gateway = ref.watch(authGatewayProvider);
    final localStore = await ensureLocalStore(db);

    if (gateway == null) {
      final device = await ensureDeviceIdentity(db, storeId: localStore.id);
      return AppSession(
        status: SessionStatus.localOnly,
        role: UserRole.owner,
        storeId: localStore.id,
        storeName: localStore.name,
        deviceId: device.id,
        message: hasSupabaseConfig
            ? (supabaseInitError ?? 'Sinkron belum siap.')
            : 'Sinkron belum diatur. Aplikasi berjalan dengan data lokal.',
      );
    }

    final user =
        gateway.currentUser ?? await _readCachedUser(db, localStore.id);
    if (user == null) {
      return const AppSession(
        status: SessionStatus.signedOut,
        role: UserRole.owner,
        message: 'Masuk untuk mengaktifkan sinkron antarperangkat.',
      );
    }

    return _restoreSession(db, gateway, user, localStore);
  }

  /// Identitas login terakhir, disimpan supaya app tetap terbuka saat sesi
  /// Supabase tidak bisa diperbarui karena tidak ada internet (S8).
  Future<AuthUser?> _readCachedUser(AppDatabase db, String storeId) async {
    final row =
        await (db.select(db.appSettings)..where(
              (t) =>
                  t.storeId.equals(storeId) &
                  t.key.equals(lastSignedInUserSettingKey),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    final map = jsonDecode(row.value);
    if (map is! Map<String, dynamic>) return null;
    final id = map['id'];
    if (id is! String) return null;
    return AuthUser(id: id, email: map['email'] as String?);
  }

  Future<void> _saveCachedUser(
    AppDatabase db,
    String storeId,
    AuthUser user,
  ) async {
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            storeId: storeId,
            key: lastSignedInUserSettingKey,
            value: jsonEncode({'id': user.id, 'email': user.email}),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> _clearCachedUser(AppDatabase db, String storeId) async {
    await (db.delete(db.appSettings)..where(
          (t) =>
              t.storeId.equals(storeId) &
              t.key.equals(lastSignedInUserSettingKey),
        ))
        .go();
  }

  /// Memulihkan sesi tersimpan TANPA jaringan (S8).
  Future<AppSession> _restoreSession(
    AppDatabase db,
    AuthGateway gateway,
    AuthUser user,
    Store localStore,
  ) async {
    var profile =
        await (db.select(db.profiles)
              ..where((t) => t.userId.equals(user.id) & t.deletedAt.isNull()))
            .getSingleOrNull();

    if (profile == null) {
      // Sesi ada (misalnya setelah reinstall) tetapi profil belum di-cache.
      try {
        final remote = await gateway.fetchProfile(user.id);
        if (remote == null) {
          return AppSession(
            status: SessionStatus.signedOut,
            role: UserRole.owner,
            message: 'Akun ini belum terhubung ke toko. Hubungi pemilik.',
          );
        }
        profile = await _cacheProfile(db, user, remote);
      } on AuthFailure catch (error) {
        return AppSession(
          status: SessionStatus.signedOut,
          role: UserRole.owner,
          message: error.message,
        );
      }
    }

    final cachedProfile = profile;
    final Store store;
    try {
      store = await _ensureStoreForProfile(
        db,
        cachedProfile.storeId,
        null,
        localStore,
        allowAdopt: true,
      );
    } on AuthFailure catch (error) {
      return AppSession(
        status: SessionStatus.signedOut,
        role: UserRole.owner,
        message: error.message,
      );
    }

    final device = await ensureDeviceIdentity(db, storeId: store.id);
    return _sessionFrom(user, cachedProfile, store, device);
  }

  /// Login email + kata sandi, lalu simpan profil & toko ke SQLite.
  Future<void> signIn({required String email, required String password}) async {
    final gateway = ref.read(authGatewayProvider);
    if (gateway == null) {
      throw AuthFailure(
        hasSupabaseConfig
            ? (supabaseInitError ?? 'Sinkron belum siap.')
            : 'Sinkron belum diatur di aplikasi ini.',
      );
    }

    final user = await gateway.signIn(email: email, password: password);

    final remote = await gateway.fetchProfile(user.id);
    if (remote == null) {
      await gateway.signOut();
      throw const AuthFailure(
        'Akun ini belum terhubung ke toko. Minta pemilik menambahkannya.',
      );
    }

    final storeId = remote['store_id'] as String?;
    if (storeId == null) {
      await gateway.signOut();
      throw const AuthFailure('Profil akun tidak memiliki toko.');
    }

    final remoteStore = await gateway.fetchStore(storeId);
    if (remoteStore == null) {
      await gateway.signOut();
      throw const AuthFailure('Data toko tidak ditemukan di server.');
    }

    final db = ref.read(appDatabaseProvider);
    final localStore = await ensureLocalStore(db);
    final profile = await _cacheProfile(db, user, remote);
    final store = await _ensureStoreForProfile(
      db,
      profile.storeId,
      remoteStore,
      localStore,
      allowAdopt: true,
    );
    final device = await ensureDeviceIdentity(db, storeId: store.id);
    await _saveCachedUser(db, store.id, user);

    state = AsyncData(_sessionFrom(user, profile, store, device));
  }

  /// Keluar tanpa menghapus data penjualan/stok (audit tetap utuh).
  Future<void> signOut() async {
    final gateway = ref.read(authGatewayProvider);
    await gateway?.signOut();
    final db = ref.read(appDatabaseProvider);
    final store = await ensureLocalStore(db);
    await _clearCachedUser(db, store.id);
    state = AsyncData(
      AppSession(
        status: SessionStatus.signedOut,
        role: UserRole.owner,
        storeId: store.id,
        storeName: store.name,
        message: 'Sudah keluar. Data lokal tetap tersimpan.',
      ),
    );
  }

  Future<Profile> _cacheProfile(
    AppDatabase db,
    AuthUser user,
    Map<String, dynamic> remote,
  ) async {
    final now = DateTime.now().toUtc();
    final role = remote['role'] == 'owner' ? UserRole.owner : UserRole.staff;
    final profile = ProfilesCompanion.insert(
      userId: user.id,
      storeId: remote['store_id'] as String,
      role: role,
      displayName: Value(
        (remote['display_name'] as String?)?.trim().isNotEmpty == true
            ? remote['display_name'] as String
            : user.email,
      ),
      createdAt: _date(remote['created_at']) ?? now,
      updatedAt: _date(remote['updated_at']) ?? now,
      deletedAt: Value(_date(remote['deleted_at'])),
      deviceId: Value(remote['device_id'] as String?),
    );

    await db.into(db.profiles).insertOnConflictUpdate(profile);
    return (db.select(
      db.profiles,
    )..where((t) => t.userId.equals(user.id))).getSingle();
  }

  /// Memastikan baris toko di SQLite cocok dengan toko profil.
  ///
  /// Bila perangkat sudah punya data bisnis untuk toko lain, login ditolak
  /// dengan pesan jelas — data tidak dicampur atau dihapus diam-diam.
  Future<Store> _ensureStoreForProfile(
    AppDatabase db,
    String serverStoreId,
    Map<String, dynamic>? remoteStore,
    Store localStore, {
    required bool allowAdopt,
  }) async {
    if (localStore.id == serverStoreId) {
      if (remoteStore != null) {
        await (db.update(
          db.stores,
        )..where((t) => t.id.equals(localStore.id))).write(
          StoresCompanion(
            name: Value((remoteStore['name'] as String?) ?? localStore.name),
            code2: Value((remoteStore['code2'] as String?) ?? localStore.code2),
            updatedAt: Value(
              _date(remoteStore['updated_at']) ?? localStore.updatedAt,
            ),
          ),
        );
      }
      return (db.select(
        db.stores,
      )..where((t) => t.id.equals(serverStoreId))).getSingle();
    }

    final businessRows = await _countBusinessRows(db, localStore.id);
    if (businessRows > 0) {
      throw const AuthFailure(
        'Data lokal di perangkat ini milik toko lain. '
        'Backup lalu kosongkan data sebelum masuk dengan akun ini.',
      );
    }

    if (!allowAdopt) {
      throw const AuthFailure(
        'Toko akun berbeda dengan data lokal. Hubungi pemilik toko.',
      );
    }

    final now = DateTime.now().toUtc();
    final name = (remoteStore?['name'] as String?) ?? 'Toko Utama';
    final code2 = (remoteStore?['code2'] as String?) ?? '01';

    await db.transaction(() async {
      // Pindahkan setelan perangkat (tema, ID perangkat) ke toko server.
      await (db.update(db.appSettings)
            ..where((t) => t.storeId.equals(localStore.id)))
          .write(AppSettingsCompanion(storeId: Value(serverStoreId)));
      await (db.update(db.devices)
            ..where((t) => t.storeId.equals(localStore.id)))
          .write(DevicesCompanion(storeId: Value(serverStoreId)));

      // Baris toko lama belum pernah diterima server (outbox belum terkirim).
      await (db.delete(db.outbox)..where(
            (t) =>
                t.targetTable.equals('stores') & t.rowId.equals(localStore.id),
          ))
          .go();
      await (db.delete(
        db.stores,
      )..where((t) => t.id.equals(localStore.id))).go();

      await db
          .into(db.stores)
          .insertOnConflictUpdate(
            StoresCompanion.insert(
              id: serverStoreId,
              name: name,
              code2: code2,
              createdAt: localStore.createdAt,
              updatedAt: _date(remoteStore?['updated_at']) ?? now,
            ),
          );
    });

    return (db.select(
      db.stores,
    )..where((t) => t.id.equals(serverStoreId))).getSingle();
  }

  Future<int> _countBusinessRows(AppDatabase db, String storeId) async {
    final products = await (db.select(
      db.products,
    )..where((t) => t.storeId.equals(storeId))).get();
    final sales = await (db.select(
      db.sales,
    )..where((t) => t.storeId.equals(storeId))).get();
    final movements = await (db.select(
      db.stockMovements,
    )..where((t) => t.storeId.equals(storeId))).get();
    final expenses = await (db.select(
      db.expenses,
    )..where((t) => t.storeId.equals(storeId))).get();
    return products.length + sales.length + movements.length + expenses.length;
  }

  AppSession _sessionFrom(
    AuthUser user,
    Profile profile,
    Store store,
    DeviceIdentity device,
  ) {
    return AppSession(
      status: SessionStatus.signedIn,
      role: profile.role,
      userId: user.id,
      email: user.email,
      storeId: store.id,
      storeName: store.name,
      displayName: profile.displayName,
      deviceId: device.id,
      message: 'Siap sinkron. Kasir tetap jalan tanpa internet.',
    );
  }

  DateTime? _date(Object? value) {
    if (value is DateTime) return value.toUtc();
    if (value is String) return DateTime.tryParse(value)?.toUtc();
    return null;
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, AppSession>(
  SessionController.new,
);
