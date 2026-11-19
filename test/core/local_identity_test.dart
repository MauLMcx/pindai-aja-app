import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/store/local_identity.dart';

import '../support/db_fixture.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await makeTestDb();
  });

  tearDown(() => db.close());

  test('membuat perangkat dan profil pemilik lokal sekali saja', () async {
    final first = await ensureLocalIdentity(db, storeId: storeId);

    expect(first.device.storeId, storeId);
    expect(first.device.code, startsWith('HP'));
    expect(first.device.code, hasLength(8));
    expect(first.profile.role, UserRole.owner);
    expect(first.cashierId, first.profile.userId);

    final second = await ensureLocalIdentity(db, storeId: storeId);
    expect(second.device.id, first.device.id);
    expect(second.device.code, first.device.code);
    expect(second.profile.userId, first.profile.userId);

    expect(await db.select(db.devices).get(), hasLength(1));
    final devicesOutbox = (await db.select(db.outbox).get())
        .where((row) => row.targetTable == 'devices')
        .toList();
    expect(devicesOutbox, hasLength(1));
  });

  test('profil lokal tetap ada walau sudah ada pengguna uji lain', () async {
    final identity = await ensureLocalIdentity(db, storeId: storeId);

    final profiles = await db.select(db.profiles).get();
    expect(profiles, hasLength(3));
    expect(
      profiles.where((p) => p.userId == identity.profile.userId),
      hasLength(1),
    );
  });
}
