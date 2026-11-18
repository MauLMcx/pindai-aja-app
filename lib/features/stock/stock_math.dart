import '../../core/db/enums.dart';

/// Satu mutasi stok yang dibutuhkan untuk menghitung HPP rata-rata bergerak.
class CostMovement {
  const CostMovement({
    required this.qtyBaseDelta,
    required this.type,
    this.costPerBase,
  });

  final int qtyBaseDelta;
  final MovementType type;
  final double? costPerBase;
}

/// Hasil hitung ulang ledger: stok buku dan HPP rata-rata per satuan dasar.
class CostReplayResult {
  const CostReplayResult({
    required this.stockBase,
    required this.avgCostPerBase,
  });

  final int stockBase;
  final double avgCostPerBase;
}

/// HPP rata-rata bergerak sesuai SPEC §6.2:
///
/// `avg_baru = (max(stok,0) × avg_lama + qty_masuk × biaya_masuk) / (max(stok,0) + qty_masuk)`
///
/// Hanya `purchase_in` yang mengubah HPP. Mutasi lain (jual, retur, opname)
/// mengubah jumlah stok tetapi tidak mengubah harga rata-rata, karena bukan
/// pembelian baru. Stok minus diperlakukan sebagai 0 saat menghitung rata-rata,
/// sehingga pembelian berikutnya memakai harga masuk sebagai titik awal.
CostReplayResult replayMovingAverage(Iterable<CostMovement> movements) {
  var stock = 0;
  var avg = 0.0;

  for (final movement in movements) {
    if (movement.type == MovementType.purchaseIn) {
      final incomingQty = movement.qtyBaseDelta;
      final incomingCost = movement.costPerBase;
      if (incomingQty > 0 && incomingCost != null) {
        final onHand = stock < 0 ? 0 : stock;
        final denominator = onHand + incomingQty;
        if (denominator > 0) {
          avg = (onHand * avg + incomingQty * incomingCost) / denominator;
        }
        stock += incomingQty;
        continue;
      }
    }
    stock += movement.qtyBaseDelta;
  }

  return CostReplayResult(stockBase: stock, avgCostPerBase: avg);
}

/// Nilai persediaan satu produk, dibulatkan ke rupiah penuh.
/// Stok minus dihitung 0 agar nilai persediaan tidak negatif.
int inventoryValueRupiah(int stockBase, double avgCostPerBase) {
  final onHand = stockBase < 0 ? 0 : stockBase;
  return (onHand * avgCostPerBase).round();
}

/// Selisih opname = fisik − buku (SPEC §6.8).
int opnameDiffBase({required int countedBase, required int expectedBase}) =>
    countedBase - expectedBase;

/// Biaya per satuan dasar dari harga beli per satuan pilihan.
///
/// Contoh: beli 1 dus isi 10 seharga Rp 140.000, satuan dasar ml 3.000 →
/// biaya per ml = 140.000 / 30.000. Hasilnya `double` karena server memakai
/// `numeric(14,4)` untuk `cost_per_base`; uang tetap `int` rupiah.
double costPerBaseFrom(int unitCost, int factorToBase) {
  if (factorToBase <= 0) {
    throw ArgumentError('Faktor satuan harus lebih dari 0');
  }
  return unitCost / factorToBase;
}
