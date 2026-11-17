import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Satu instance database untuk seluruh aplikasi.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openAppDatabaseConnection());
  ref.onDispose(db.close);
  return db;
});
