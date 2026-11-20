import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../device/device_identity.dart';
import '../ids.dart';

/// Identitas yang dipakai sebelum login tersedia (Tahap 3).
class LocalIdentity {
  const LocalIdentity({required this.device, required this.profile});

  final Device device;
  final Profile profile;

  String get deviceId => device.id;
  String get deviceCode => device.code;
  String get cashierId => profile.userId;
}

/// Memastikan perangkat ini punya baris `devices` dan satu profil pemilik
/// lokal. Identitas perangkat memakai satu sumber (`ensureDeviceIdentity`)
/// supaya nomor struk dan sesi memakai kode HP yang sama (SPEC P3).
Future<LocalIdentity> ensureLocalIdentity(
  AppDatabase db, {
  required String storeId,
}) async {
  final profile = await _ensureLocalOwner(db, storeId);
  final identity = await ensureDeviceIdentity(db, storeId: storeId);
  final device = await (db.select(
    db.devices,
  )..where((t) => t.id.equals(identity.id))).getSingle();
  return LocalIdentity(device: device, profile: profile);
}

Future<Profile> _ensureLocalOwner(AppDatabase db, String storeId) async {
  final userId = stableId('user', 'pemilik-lokal');
  final existing = await (db.select(
    db.profiles,
  )..where((t) => t.userId.equals(userId))).getSingleOrNull();
  if (existing != null) return existing;

  final now = DateTime.now().toUtc();
  await db
      .into(db.profiles)
      .insert(
        ProfilesCompanion.insert(
          userId: userId,
          storeId: storeId,
          role: UserRole.owner,
          displayName: const Value('Pemilik'),
          createdAt: now,
          updatedAt: now,
        ),
      );
  return (await (db.select(
    db.profiles,
  )..where((t) => t.userId.equals(userId))).getSingle());
}
