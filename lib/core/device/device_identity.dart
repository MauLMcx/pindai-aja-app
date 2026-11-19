import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../db/outbox_writer.dart';
import '../ids.dart';

/// Kunci penyimpanan identitas perangkat di `app_settings`.
const String deviceIdSettingKey = 'device_id';

class DeviceIdentity {
  const DeviceIdentity({
    required this.id,
    required this.code,
    required this.name,
  });

  final String id;

  /// Kode pendek untuk nomor struk (SPEC P3).
  final String code;
  final String name;
}

/// Membuat (sekali) identitas perangkat lokal.
///
/// Server mewajibkan `device_id` pada penjualan, jadi identitas ini harus ada
/// sebelum transaksi pertama, termasuk sebelum login (SPEC §19).
Future<DeviceIdentity> ensureDeviceIdentity(
  AppDatabase db, {
  required String storeId,
}) async {
  final existing =
      await (db.select(db.appSettings)..where(
            (t) => t.storeId.equals(storeId) & t.key.equals(deviceIdSettingKey),
          ))
          .getSingleOrNull();

  if (existing != null) {
    final parsed = _decode(existing.value);
    if (parsed != null) {
      await _ensureDeviceRow(db, storeId, parsed);
      return parsed;
    }
  }

  final now = DateTime.now().toUtc();
  final id = newId();
  final identity = DeviceIdentity(
    id: id,
    code: _shortCode(id),
    name: _deviceName(),
  );

  await db.transaction(() async {
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            storeId: storeId,
            key: deviceIdSettingKey,
            value: jsonEncode({
              'id': identity.id,
              'code': identity.code,
              'name': identity.name,
            }),
            updatedAt: now,
          ),
        );
    await _insertDeviceRow(db, storeId, identity, now);
  });

  return identity;
}

/// Membaca identitas tanpa membuat baru. Null bila perangkat belum punya.
Future<DeviceIdentity?> readDeviceIdentity(
  AppDatabase db, {
  required String storeId,
}) async {
  final row =
      await (db.select(db.appSettings)..where(
            (t) => t.storeId.equals(storeId) & t.key.equals(deviceIdSettingKey),
          ))
          .getSingleOrNull();
  return row == null ? null : _decode(row.value);
}

Future<void> _ensureDeviceRow(
  AppDatabase db,
  String storeId,
  DeviceIdentity identity,
) async {
  final row = await (db.select(
    db.devices,
  )..where((t) => t.id.equals(identity.id))).getSingleOrNull();
  if (row != null) return;

  final now = DateTime.now().toUtc();
  await db.transaction(() async {
    await _insertDeviceRow(db, storeId, identity, now);
  });
}

Future<void> _insertDeviceRow(
  AppDatabase db,
  String storeId,
  DeviceIdentity identity,
  DateTime now,
) async {
  await db
      .into(db.devices)
      .insertOnConflictUpdate(
        DevicesCompanion.insert(
          id: identity.id,
          storeId: storeId,
          code: identity.code,
          name: Value(identity.name),
          createdAt: now,
          updatedAt: now,
          deviceId: Value(identity.id),
        ),
      );
  await enqueueOutbox(
    db,
    table: 'devices',
    rowId: identity.id,
    op: 'insert',
    payload: {
      'id': identity.id,
      'store_id': storeId,
      'code': identity.code,
      'name': identity.name,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
      'device_id': identity.id,
    },
    at: now,
  );
}

DeviceIdentity? _decode(String raw) {
  try {
    final map = jsonDecode(raw);
    if (map is! Map<String, dynamic>) return null;
    final id = map['id'];
    final code = map['code'];
    if (id is! String || code is! String) return null;
    return DeviceIdentity(
      id: id,
      code: code,
      name: map['name'] is String ? map['name'] as String : _deviceName(),
    );
  } catch (_) {
    return null;
  }
}

String _shortCode(String id) =>
    id.replaceAll('-', '').substring(0, 4).toUpperCase();

String _deviceName() {
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'HP Android',
    TargetPlatform.iOS => 'iPhone',
    TargetPlatform.windows => 'Komputer Windows',
    TargetPlatform.macOS => 'Komputer Mac',
    TargetPlatform.linux => 'Komputer Linux',
    TargetPlatform.fuchsia => 'Perangkat',
  };
}
