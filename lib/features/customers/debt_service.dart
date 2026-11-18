import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/ledger.dart';
import '../../core/ids.dart';

/// Utang pelanggan (SPEC §6.9). Semua perubahan lewat ledger append-only.
class DebtService {
  DebtService(this.db, {required this.storeId, required this.deviceId});

  final AppDatabase db;
  final String storeId;
  final String deviceId;

  Future<int> balance(String customerId) => debtBalanceOf(db, customerId);

  Future<List<DebtLedgerData>> history(String customerId) {
    return (db.select(db.debtLedger)
          ..where((t) => t.customerId.equals(customerId))
          ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
        .get();
  }

  /// Mencatat pembayaran utang. `amount` positif mengurangi saldo.
  Future<int> pay({
    required String customerId,
    required int amount,
    required PayMethod method,
    DateTime? at,
    String? note,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('nominal pembayaran harus lebih dari 0');
    }
    if (method == PayMethod.credit) {
      throw ArgumentError('pembayaran utang tidak boleh memakai metode kredit');
    }

    final occurredAt = (at ?? DateTime.now()).toUtc();
    return db.transaction(() async {
      await addDebtEntry(
        db,
        id: newId(),
        storeId: storeId,
        customerId: customerId,
        delta: -amount,
        type: DebtType.payment,
        occurredAt: occurredAt,
        method: method,
        note: note,
        deviceId: deviceId,
      );
      return debtBalanceOf(db, customerId);
    });
  }

  /// Penyesuaian manual (mis. koreksi kasir). Positif menambah utang.
  Future<int> adjust({
    required String customerId,
    required int delta,
    DateTime? at,
    String? note,
  }) async {
    if (delta == 0) {
      throw ArgumentError('penyesuaian tidak boleh nol');
    }

    final occurredAt = (at ?? DateTime.now()).toUtc();
    return db.transaction(() async {
      await addDebtEntry(
        db,
        id: newId(),
        storeId: storeId,
        customerId: customerId,
        delta: delta,
        type: DebtType.adjustment,
        occurredAt: occurredAt,
        note: note,
        deviceId: deviceId,
      );
      return debtBalanceOf(db, customerId);
    });
  }
}
