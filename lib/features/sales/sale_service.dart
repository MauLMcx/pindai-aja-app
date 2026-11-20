import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/ledger.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';

class SaleDraftItem {
  const SaleDraftItem({
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.unitPrice,
    this.discount = 0,
  });

  final String productId;
  final String unitId;
  final int qty;
  final int unitPrice;
  final int discount;
}

class SalePaymentInput {
  const SalePaymentInput({
    required this.method,
    required this.amount,
    this.status = PaymentStatus.confirmed,
    this.reference,
  });

  final PayMethod method;
  final int amount;
  final PaymentStatus status;
  final String? reference;
}

class SaleResult {
  const SaleResult({
    required this.sale,
    required this.debtAmount,
    required this.changeAmount,
  });

  final Sale sale;
  final int debtAmount;
  final int changeAmount;
}

/// Penjualan lokal (SPEC §6.4). Semua tulisan terjadi dalam satu transaksi:
/// baris penjualan, item, pembayaran, mutasi stok, utang, dan outbox.
class SaleService {
  SaleService(
    this.db, {
    required this.storeId,
    required this.deviceId,
    required this.deviceCode,
  });

  final AppDatabase db;
  final String storeId;
  final String deviceId;
  final String deviceCode;

  Future<SaleResult> create({
    required String cashierId,
    required List<SaleDraftItem> items,
    List<SalePaymentInput> payments = const [],
    String? customerId,
    int discountTotal = 0,
    String? note,
    DateTime? soldAt,
    SaleStatus status = SaleStatus.completed,
    String? receiptNo,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('penjualan harus punya minimal satu item');
    }
    if (discountTotal < 0) {
      throw ArgumentError('diskon tidak boleh negatif');
    }
    for (final payment in payments) {
      if (payment.amount < 0) {
        throw ArgumentError('nominal pembayaran tidak boleh negatif');
      }
    }

    return db.transaction(() async {
      final at = (soldAt ?? DateTime.now()).toUtc();
      final saleId = newId();
      final prepared = <_PreparedLine>[];
      var subtotal = 0;

      for (final item in items) {
        if (item.qty <= 0) {
          throw ArgumentError('jumlah item harus lebih dari 0');
        }
        if (item.unitPrice < 0 || item.discount < 0) {
          throw ArgumentError('harga dan diskon tidak boleh negatif');
        }
        final unit = await (db.select(
          db.productUnits,
        )..where((t) => t.id.equals(item.unitId))).getSingleOrNull();
        if (unit == null) {
          throw StateError('satuan ${item.unitId} tidak ditemukan');
        }
        if (unit.productId != item.productId) {
          throw ArgumentError('satuan bukan milik produk ${item.productId}');
        }
        final gross = item.unitPrice * item.qty;
        if (item.discount > gross) {
          throw ArgumentError('diskon baris melebihi harga baris');
        }
        final lineTotal = gross - item.discount;
        subtotal += lineTotal;
        prepared.add(
          _PreparedLine(
            item: item,
            qtyBase: item.qty * unit.factorToBase,
            lineTotal: lineTotal,
          ),
        );
      }

      if (discountTotal > subtotal) {
        throw ArgumentError('diskon transaksi melebihi subtotal');
      }
      final total = subtotal - discountTotal;

      var paid = 0;
      if (status != SaleStatus.hold) {
        for (final payment in payments) {
          if (payment.method != PayMethod.credit &&
              payment.status == PaymentStatus.confirmed) {
            paid += payment.amount;
          }
        }
      }

      final debtAmount = status == SaleStatus.hold
          ? 0
          : (total > paid ? total - paid : 0);
      final changeAmount = status == SaleStatus.hold
          ? 0
          : (paid > total ? paid - total : 0);

      if (debtAmount > 0 && customerId == null) {
        throw StateError('penjualan kredit membutuhkan pelanggan');
      }

      final number = receiptNo ?? await _nextReceiptNo(at);
      final createdAt = at;

      await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              id: saleId,
              storeId: storeId,
              receiptNo: number,
              cashierId: cashierId,
              customerId: Value(customerId),
              soldAt: at,
              subtotal: subtotal,
              discountTotal: Value(discountTotal),
              total: total,
              paidTotal: paid,
              changeAmount: Value(changeAmount),
              status: Value(status),
              note: Value(note),
              createdAt: createdAt,
              updatedAt: createdAt,
              deviceId: Value(deviceId),
            ),
          );

      await _enqueueSale(
        saleId: saleId,
        receiptNo: number,
        cashierId: cashierId,
        customerId: customerId,
        soldAt: at,
        subtotal: subtotal,
        discountTotal: discountTotal,
        total: total,
        paid: paid,
        changeAmount: changeAmount,
        status: status,
        note: note,
      );

      final costCache = <String, double?>{};

      for (final line in prepared) {
        final itemId = newId();
        final item = line.item;
        final cost =
            costCache[item.productId] ??
            await averageCostBaseOf(db, item.productId);
        costCache[item.productId] = cost;

        await db
            .into(db.saleItems)
            .insert(
              SaleItemsCompanion.insert(
                id: itemId,
                storeId: storeId,
                saleId: saleId,
                productId: item.productId,
                unitId: item.unitId,
                qty: item.qty,
                qtyBase: line.qtyBase,
                unitPrice: item.unitPrice,
                discount: Value(item.discount),
                lineTotal: line.lineTotal,
                costPerBase: Value(cost),
                createdAt: createdAt,
                updatedAt: createdAt,
                deviceId: Value(deviceId),
              ),
            );

        await enqueueOutbox(
          db,
          table: 'sale_items',
          rowId: itemId,
          op: 'insert',
          payload: {
            'id': itemId,
            'store_id': storeId,
            'sale_id': saleId,
            'product_id': item.productId,
            'unit_id': item.unitId,
            'qty': item.qty,
            'qty_base': line.qtyBase,
            'unit_price': item.unitPrice,
            'discount': item.discount,
            'line_total': line.lineTotal,
            'cost_per_base': cost,
            'created_at': createdAt.toIso8601String(),
            'updated_at': createdAt.toIso8601String(),
            'device_id': deviceId,
          },
          at: createdAt,
        );

        if (status == SaleStatus.completed) {
          await addStockMovement(
            db,
            id: newId(),
            storeId: storeId,
            productId: item.productId,
            qtyBaseDelta: -line.qtyBase,
            type: MovementType.saleOut,
            occurredAt: at,
            refType: 'sale',
            refId: saleId,
            costPerBase: cost,
            deviceId: deviceId,
          );
        }
      }

      for (final payment in payments) {
        if (status == SaleStatus.hold) break;
        await _insertPayment(
          saleId: saleId,
          payment: payment,
          at: at,
          createdAt: createdAt,
        );
      }

      if (debtAmount > 0) {
        await addDebtEntry(
          db,
          id: newId(),
          storeId: storeId,
          customerId: customerId!,
          delta: debtAmount,
          type: DebtType.saleCredit,
          occurredAt: at,
          refId: saleId,
          deviceId: deviceId,
        );
      }

      final sale = await (db.select(
        db.sales,
      )..where((t) => t.id.equals(saleId))).getSingle();

      return SaleResult(
        sale: sale,
        debtAmount: debtAmount,
        changeAmount: changeAmount,
      );
    });
  }

  /// Melanjutkan transaksi yang ditahan lalu menyelesaikannya.
  ///
  /// Stok baru berkurang di sini, jadi transaksi yang ditahan tidak pernah
  /// mengubah stok dan tidak mencatat pembayaran (SPEC §6.4).
  Future<SaleResult> completeHeld({
    required String saleId,
    required List<SalePaymentInput> payments,
    int? discountTotal,
    DateTime? at,
  }) {
    return db.transaction(() async {
      final sale = await (db.select(
        db.sales,
      )..where((t) => t.id.equals(saleId))).getSingleOrNull();
      if (sale == null) {
        throw StateError('penjualan tidak ditemukan');
      }
      if (sale.status != SaleStatus.hold) {
        throw StateError('transaksi ini tidak sedang ditahan');
      }
      for (final payment in payments) {
        if (payment.amount < 0) {
          throw ArgumentError('nominal pembayaran tidak boleh negatif');
        }
      }

      final subtotal = sale.subtotal;
      final discount = discountTotal ?? sale.discountTotal;
      if (discount < 0 || discount > subtotal) {
        throw ArgumentError('diskon transaksi melebihi subtotal');
      }
      final total = subtotal - discount;
      final paid = _paidTotal(payments);
      final debtAmount = total > paid ? total - paid : 0;
      final changeAmount = paid > total ? paid - total : 0;
      if (debtAmount > 0 && sale.customerId == null) {
        throw StateError('penjualan kredit membutuhkan pelanggan');
      }

      final now = (at ?? DateTime.now()).toUtc();
      final createdAt = sale.createdAt;

      for (final payment in payments) {
        await _insertPayment(
          saleId: saleId,
          payment: payment,
          at: now,
          createdAt: createdAt,
        );
      }

      final items = await (db.select(
        db.saleItems,
      )..where((t) => t.saleId.equals(saleId))).get();

      for (final item in items) {
        await addStockMovement(
          db,
          id: newId(),
          storeId: storeId,
          productId: item.productId,
          qtyBaseDelta: -item.qtyBase,
          type: MovementType.saleOut,
          occurredAt: now,
          refType: 'sale',
          refId: saleId,
          costPerBase: item.costPerBase,
          deviceId: deviceId,
        );
      }

      if (debtAmount > 0) {
        await addDebtEntry(
          db,
          id: newId(),
          storeId: storeId,
          customerId: sale.customerId!,
          delta: debtAmount,
          type: DebtType.saleCredit,
          occurredAt: now,
          refId: saleId,
          deviceId: deviceId,
        );
      }

      await (db.update(db.sales)..where((t) => t.id.equals(saleId))).write(
        SalesCompanion(
          discountTotal: Value(discount),
          total: Value(total),
          paidTotal: Value(paid),
          changeAmount: Value(changeAmount),
          status: const Value(SaleStatus.completed),
          updatedAt: Value(now),
        ),
      );

      await enqueueOutbox(
        db,
        table: 'sales',
        rowId: saleId,
        op: 'update',
        payload: {
          'id': saleId,
          'store_id': storeId,
          'receipt_no': sale.receiptNo,
          'cashier_id': sale.cashierId,
          'customer_id': sale.customerId,
          'sold_at': sale.soldAt.toUtc().toIso8601String(),
          'subtotal': subtotal,
          'discount_total': discount,
          'total': total,
          'paid_total': paid,
          'change_amount': changeAmount,
          'status': const SaleStatusConverter().toSql(SaleStatus.completed),
          'note': sale.note,
          'updated_at': now.toIso8601String(),
          'device_id': deviceId,
        },
        at: now,
      );

      final updated = await (db.select(
        db.sales,
      )..where((t) => t.id.equals(saleId))).getSingle();

      return SaleResult(
        sale: updated,
        debtAmount: debtAmount,
        changeAmount: changeAmount,
      );
    });
  }

  /// Membatalkan penjualan (SPEC §6.4.1). Hanya `owner`, lewat status `void`
  /// dan mutasi balik; tidak ada penghapusan.
  Future<void> voidSale({
    required String saleId,
    required String byUserId,
    DateTime? at,
  }) {
    return db.transaction(() async {
      final sale = await (db.select(
        db.sales,
      )..where((t) => t.id.equals(saleId))).getSingleOrNull();
      if (sale == null) {
        throw StateError('penjualan tidak ditemukan');
      }
      if (sale.status == SaleStatus.voided) return;
      if (sale.status != SaleStatus.completed) {
        throw StateError('hanya penjualan selesai yang bisa dibatalkan');
      }

      final profile = await (db.select(
        db.profiles,
      )..where((t) => t.userId.equals(byUserId))).getSingleOrNull();
      if (profile == null || profile.role != UserRole.owner) {
        throw StateError('hanya pemilik yang boleh membatalkan penjualan');
      }

      final now = (at ?? DateTime.now()).toUtc();
      final items = await (db.select(
        db.saleItems,
      )..where((t) => t.saleId.equals(saleId))).get();

      for (final item in items) {
        await addStockMovement(
          db,
          id: newId(),
          storeId: storeId,
          productId: item.productId,
          qtyBaseDelta: item.qtyBase,
          type: MovementType.voidIn,
          occurredAt: now,
          refType: 'sale',
          refId: saleId,
          costPerBase: item.costPerBase,
          note: 'void ${sale.receiptNo}',
          deviceId: deviceId,
        );
      }

      final creditTotal = await _saleCreditTotal(saleId);
      if (creditTotal != 0 && sale.customerId != null) {
        await addDebtEntry(
          db,
          id: newId(),
          storeId: storeId,
          customerId: sale.customerId!,
          delta: -creditTotal,
          type: DebtType.adjustment,
          occurredAt: now,
          refId: saleId,
          note: 'void ${sale.receiptNo}',
          deviceId: deviceId,
        );
      }

      await (db.update(db.sales)..where((t) => t.id.equals(saleId))).write(
        SalesCompanion(
          status: const Value(SaleStatus.voided),
          updatedAt: Value(now),
        ),
      );

      await enqueueOutbox(
        db,
        table: 'sales',
        rowId: saleId,
        op: 'update',
        payload: {
          'id': saleId,
          'store_id': storeId,
          'receipt_no': sale.receiptNo,
          'cashier_id': sale.cashierId,
          'customer_id': sale.customerId,
          'sold_at': sale.soldAt.toUtc().toIso8601String(),
          'subtotal': sale.subtotal,
          'discount_total': sale.discountTotal,
          'total': sale.total,
          'paid_total': sale.paidTotal,
          'change_amount': sale.changeAmount,
          'status': const SaleStatusConverter().toSql(SaleStatus.voided),
          'note': sale.note,
          'updated_at': now.toIso8601String(),
          'device_id': deviceId,
        },
        at: now,
      );
    });
  }

  Future<void> _enqueueSale({
    required String saleId,
    required String receiptNo,
    required String cashierId,
    required String? customerId,
    required DateTime soldAt,
    required int subtotal,
    required int discountTotal,
    required int total,
    required int paid,
    required int changeAmount,
    required SaleStatus status,
    required String? note,
  }) async {
    await enqueueOutbox(
      db,
      table: 'sales',
      rowId: saleId,
      op: 'insert',
      payload: {
        'id': saleId,
        'store_id': storeId,
        'receipt_no': receiptNo,
        'cashier_id': cashierId,
        'customer_id': customerId,
        'sold_at': soldAt.toIso8601String(),
        'subtotal': subtotal,
        'discount_total': discountTotal,
        'total': total,
        'paid_total': paid,
        'change_amount': changeAmount,
        'status': const SaleStatusConverter().toSql(status),
        'note': note,
        'created_at': soldAt.toIso8601String(),
        'updated_at': soldAt.toIso8601String(),
        'device_id': deviceId,
      },
      at: soldAt,
    );
  }

  int _paidTotal(List<SalePaymentInput> payments) {
    var paid = 0;
    for (final payment in payments) {
      if (payment.method != PayMethod.credit &&
          payment.status == PaymentStatus.confirmed) {
        paid += payment.amount;
      }
    }
    return paid;
  }

  Future<void> _insertPayment({
    required String saleId,
    required SalePaymentInput payment,
    required DateTime at,
    required DateTime createdAt,
  }) async {
    final paymentId = newId();
    await db
        .into(db.payments)
        .insert(
          PaymentsCompanion.insert(
            id: paymentId,
            storeId: storeId,
            saleId: saleId,
            method: payment.method,
            amount: payment.amount,
            status: Value(payment.status),
            reference: Value(payment.reference),
            paidAt: at,
            createdAt: createdAt,
            updatedAt: createdAt,
            deviceId: Value(deviceId),
          ),
        );

    await enqueueOutbox(
      db,
      table: 'payments',
      rowId: paymentId,
      op: 'insert',
      payload: {
        'id': paymentId,
        'store_id': storeId,
        'sale_id': saleId,
        'method': const PayMethodConverter().toSql(payment.method),
        'amount': payment.amount,
        'status': const PaymentStatusConverter().toSql(payment.status),
        'reference': payment.reference,
        'paid_at': at.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': createdAt.toIso8601String(),
        'device_id': deviceId,
      },
      at: createdAt,
    );
  }

  Future<int> _saleCreditTotal(String saleId) async {
    final total = db.debtLedger.delta.sum();
    final query = db.selectOnly(db.debtLedger)
      ..addColumns([total])
      ..where(
        db.debtLedger.refId.equals(saleId) &
            db.debtLedger.type.equalsValue(DebtType.saleCredit),
      );
    final row = await query.getSingle();
    return row.read(total) ?? 0;
  }

  /// Nomor struk: kode perangkat + tanggal + counter lokal (SPEC P3).
  Future<String> _nextReceiptNo(DateTime at) async {
    final day =
        '${at.year}${at.month.toString().padLeft(2, '0')}'
        '${at.day.toString().padLeft(2, '0')}';
    final key = 'receipt_counter:$deviceCode:$day';
    final existing =
        await (db.select(db.appSettings)
              ..where((t) => t.storeId.equals(storeId) & t.key.equals(key)))
            .getSingleOrNull();
    final next = (int.tryParse(existing?.value ?? '0') ?? 0) + 1;
    await db
        .into(db.appSettings)
        .insert(
          AppSettingsCompanion.insert(
            storeId: storeId,
            key: key,
            value: '$next',
            updatedAt: at,
          ),
          mode: InsertMode.insertOrReplace,
        );
    return '$deviceCode-$day-${next.toString().padLeft(4, '0')}';
  }
}

class _PreparedLine {
  const _PreparedLine({
    required this.item,
    required this.qtyBase,
    required this.lineTotal,
  });

  final SaleDraftItem item;
  final int qtyBase;
  final int lineTotal;
}
