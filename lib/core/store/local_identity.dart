import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../db/outbox_writer.dart';
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
/// lokal. ID perangkat dibuat acak sekali dan disimpan, sehingga dua HP tidak
/// memakai kode struk yang sama (SPEC P3).
Future<LocalIdentity> ensureLocalIdentity(
  AppDatabase db, {
  required String storeId,
}) async {
  final profile = await _ensureLocalOwner(db, storeId);
  final existing =
      await (db.select(db.devices)
            ..where((t) => t.storeId.equals(storeId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) {
    return LocalIdentity(device: existing, profile: profile);
  }

  return db.transaction(() async {
    final raced =
        await (db.select(db.devices)
              ..where((t) => t.storeId.equals(storeId) & t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (raced != null) {
      return LocalIdentity(device: raced, profile: profile);
    }

    final now = DateTime.now().toUtc();
    final id = newId();
    final code = 'HP${id.replaceAll('-', '').substring(0, 6).toUpperCase()}';
    await db
        .into(db.devices)
        .insert(
          DevicesCompanion.insert(
            id: id,
            storeId: storeId,
            code: code,
            name: const Value('Perangkat ini'),
            createdAt: now,
            updatedAt: now,
            deviceId: Value(id),
          ),
        );
    await enqueueOutbox(
      db,
      table: 'devices',
      rowId: id,
      op: 'insert',
      payload: {
        'id': id,
        'store_id': storeId,
        'code': code,
        'name': 'Perangkat ini',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'device_id': id,
      },
      at: now,
    );

    final device =
        await (db.select(db.devices)..where((t) => t.id.equals(id))).getSingle();
    return LocalIdentity(device: device, profile: profile);
  });
}

Future<Profile> _ensureLocalOwner(AppDatabase db, String storeId) async {
  final userId = stableId('user', 'pemilik-lokal');
  final existing =
      await (db.select(db.profiles)
            ..where((t) => t.userId.equals(userId)))
          .getSingleOrNull();
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
  return (await (db.select(db.profiles)
            ..where((t) => t.userId.equals(userId)))
          .getSingle());
}
