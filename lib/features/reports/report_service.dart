import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';

class PaymentRecap {
  const PaymentRecap({required this.method, required this.amount});

  final PayMethod method;
  final int amount;
}

class SalesSummary {
  const SalesSummary({
    required this.omzet,
    required this.discountTotal,
    required this.returnsTotal,
    required this.returnCost,
    required this.hpp,
    required this.grossProfit,
    required this.expenses,
    required this.netProfit,
    required this.transactionCount,
    required this.payments,
  });

  /// Total penjualan selesai sebelum dikurangi retur.
  final int omzet;
  final int discountTotal;
  final int returnsTotal;

  /// HPP barang yang diretur (mengurangi HPP penjualan).
  final int returnCost;
  final int hpp;
  final int grossProfit;
  final int expenses;
  final int netProfit;
  final int transactionCount;
  final List<PaymentRecap> payments;

  int get omzetNet => omzet - returnsTotal;
  int get hppNet => hpp - returnCost;
}

/// Laporan dari data lokal (SPEC §6.10), rentang `[from, to)`.
///
/// HPP memakai snapshot `sale_items.cost_per_base`, bukan dihitung ulang.
class ReportService {
  ReportService(this.db);

  final AppDatabase db;

  Future<SalesSummary> salesSummary({
    required DateTime from,
    required DateTime to,
  }) async {
    final start = from.toUtc();
    final end = to.toUtc();
    if (!end.isAfter(start)) {
      throw ArgumentError('rentang laporan tidak valid');
    }

    final sales =
        await (db.select(db.sales)
              ..where(
                (t) =>
                    t.status.equalsValue(SaleStatus.completed) &
                    t.soldAt.isBiggerOrEqualValue(start) &
                    t.soldAt.isSmallerThanValue(end),
              ))
            .get();

    var omzet = 0;
    var discountTotal = 0;
    for (final sale in sales) {
      omzet += sale.total;
      discountTotal += sale.discountTotal;
    }

    final saleIds = sales.map((s) => s.id).toList();
    var hpp = 0;
    var transactionCount = sales.length;
    final payments = <PayMethod, int>{};

    if (saleIds.isNotEmpty) {
      final items =
          await (db.select(db.saleItems)
                ..where((t) => t.saleId.isIn(saleIds)))
              .get();
      for (final item in items) {
        discountTotal += item.discount;
        hpp += (item.qtyBase * (item.costPerBase ?? 0)).round();
      }

      final paid =
          await (db.select(db.payments)
                ..where(
                  (t) =>
                      t.saleId.isIn(saleIds) &
                      t.status.equalsValue(PaymentStatus.confirmed),
                ))
              .get();
      for (final payment in paid) {
        payments[payment.method] =
            (payments[payment.method] ?? 0) + payment.amount;
      }
    }

    final saleReturns =
        await (db.select(db.returns)
              ..where(
                (t) =>
                    t.kind.equalsValue(ReturnKind.sale) &
                    t.returnedAt.isBiggerOrEqualValue(start) &
                    t.returnedAt.isSmallerThanValue(end),
              ))
            .get();

    var returnsTotal = 0;
    for (final row in saleReturns) {
      returnsTotal += row.refundTotal;
    }

    var returnCost = 0;
    final returnIds = saleReturns.map((r) => r.id).toList();
    if (returnIds.isNotEmpty) {
      final returnItems =
          await (db.select(db.returnItems)
                ..where((t) => t.returnId.isIn(returnIds)))
              .get();
      for (final item in returnItems) {
        returnCost += (item.qtyBase * (item.costPerBase ?? 0)).round();
      }
    }

    final expenseRows =
        await (db.select(db.expenses)
              ..where(
                (t) =>
                    t.spentAt.isBiggerOrEqualValue(start) &
                    t.spentAt.isSmallerThanValue(end),
              ))
            .get();
    var expenses = 0;
    for (final row in expenseRows) {
      expenses += row.amount;
    }

    final grossProfit = (omzet - returnsTotal) - (hpp - returnCost);
    final netProfit = grossProfit - expenses;

    return SalesSummary(
      omzet: omzet,
      discountTotal: discountTotal,
      returnsTotal: returnsTotal,
      returnCost: returnCost,
      hpp: hpp,
      grossProfit: grossProfit,
      expenses: expenses,
      netProfit: netProfit,
      transactionCount: transactionCount,
      payments: [
        for (final entry in payments.entries)
          PaymentRecap(method: entry.key, amount: entry.value),
      ],
    );
  }
}
