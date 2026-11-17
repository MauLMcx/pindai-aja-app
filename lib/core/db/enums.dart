import 'package:drift/drift.dart';

/// Nilai enum disimpan sebagai teks `snake_case` agar cocok dengan PostgreSQL
/// (SPEC §7) dan tetap terbaca saat inspeksi database.
enum MovementType {
  purchaseIn,
  saleOut,
  returnIn,
  purchaseReturnOut,
  opnameAdjust,
  voidIn,
  manualAdjust,
  initial,
}

enum PayMethod { cash, qris, ewallet, transfer, card, credit }

enum SaleStatus { completed, voided, hold }

enum DebtType { saleCredit, payment, returnOffset, adjustment }

enum ReturnKind { sale, purchase }

enum OpnameStatus { open, finished }

enum PaymentStatus { confirmed, pending }

enum BarcodeSource { factory, internal }

enum PriceKind { buy, sell }

enum UserRole { owner, staff }

class MovementTypeConverter extends TypeConverter<MovementType, String> {
  const MovementTypeConverter();

  static const Map<MovementType, String> _db = {
    MovementType.purchaseIn: 'purchase_in',
    MovementType.saleOut: 'sale_out',
    MovementType.returnIn: 'return_in',
    MovementType.purchaseReturnOut: 'purchase_return_out',
    MovementType.opnameAdjust: 'opname_adjust',
    MovementType.voidIn: 'void_in',
    MovementType.manualAdjust: 'manual_adjust',
    MovementType.initial: 'initial',
  };

  @override
  MovementType fromSql(String fromDb) => _db.entries
      .firstWhere(
        (e) => e.value == fromDb,
        orElse: () =>
            throw ArgumentError('movement_type tidak dikenal: $fromDb'),
      )
      .key;

  @override
  String toSql(MovementType value) => _db[value]!;
}

class PayMethodConverter extends TypeConverter<PayMethod, String> {
  const PayMethodConverter();

  static const Map<PayMethod, String> _db = {
    PayMethod.cash: 'cash',
    PayMethod.qris: 'qris',
    PayMethod.ewallet: 'ewallet',
    PayMethod.transfer: 'transfer',
    PayMethod.card: 'card',
    PayMethod.credit: 'credit',
  };

  @override
  PayMethod fromSql(String fromDb) => _db.entries
      .firstWhere(
        (e) => e.value == fromDb,
        orElse: () => throw ArgumentError('pay_method tidak dikenal: $fromDb'),
      )
      .key;

  @override
  String toSql(PayMethod value) => _db[value]!;
}

class SaleStatusConverter extends TypeConverter<SaleStatus, String> {
  const SaleStatusConverter();

  static const Map<SaleStatus, String> _db = {
    SaleStatus.completed: 'completed',
    SaleStatus.voided: 'void',
    SaleStatus.hold: 'hold',
  };

  @override
  SaleStatus fromSql(String fromDb) => _db.entries
      .firstWhere(
        (e) => e.value == fromDb,
        orElse: () =>
            throw ArgumentError('status penjualan tidak dikenal: $fromDb'),
      )
      .key;

  @override
  String toSql(SaleStatus value) => _db[value]!;
}

class DebtTypeConverter extends TypeConverter<DebtType, String> {
  const DebtTypeConverter();

  static const Map<DebtType, String> _db = {
    DebtType.saleCredit: 'sale_credit',
    DebtType.payment: 'payment',
    DebtType.returnOffset: 'return_offset',
    DebtType.adjustment: 'adjustment',
  };

  @override
  DebtType fromSql(String fromDb) => _db.entries
      .firstWhere(
        (e) => e.value == fromDb,
        orElse: () => throw ArgumentError('debt type tidak dikenal: $fromDb'),
      )
      .key;

  @override
  String toSql(DebtType value) => _db[value]!;
}

class ReturnKindConverter extends TypeConverter<ReturnKind, String> {
  const ReturnKindConverter();

  @override
  ReturnKind fromSql(String fromDb) => ReturnKind.values.byName(fromDb);

  @override
  String toSql(ReturnKind value) => value.name;
}

class OpnameStatusConverter extends TypeConverter<OpnameStatus, String> {
  const OpnameStatusConverter();

  @override
  OpnameStatus fromSql(String fromDb) => OpnameStatus.values.byName(fromDb);

  @override
  String toSql(OpnameStatus value) => value.name;
}

class PaymentStatusConverter extends TypeConverter<PaymentStatus, String> {
  const PaymentStatusConverter();

  @override
  PaymentStatus fromSql(String fromDb) => PaymentStatus.values.byName(fromDb);

  @override
  String toSql(PaymentStatus value) => value.name;
}

class BarcodeSourceConverter extends TypeConverter<BarcodeSource, String> {
  const BarcodeSourceConverter();

  @override
  BarcodeSource fromSql(String fromDb) => BarcodeSource.values.byName(fromDb);

  @override
  String toSql(BarcodeSource value) => value.name;
}

class PriceKindConverter extends TypeConverter<PriceKind, String> {
  const PriceKindConverter();

  @override
  PriceKind fromSql(String fromDb) => PriceKind.values.byName(fromDb);

  @override
  String toSql(PriceKind value) => value.name;
}

class UserRoleConverter extends TypeConverter<UserRole, String> {
  const UserRoleConverter();

  @override
  UserRole fromSql(String fromDb) => UserRole.values.byName(fromDb);

  @override
  String toSql(UserRole value) => value.name;
}
