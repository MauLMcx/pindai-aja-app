import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/enums.dart';
import 'package:petshop_pos/features/stock/stock_math.dart';

CostMovement buy(int qtyBase, double costPerBase) => CostMovement(
  qtyBaseDelta: qtyBase,
  type: MovementType.purchaseIn,
  costPerBase: costPerBase,
);

CostMovement other(int delta, MovementType type) =>
    CostMovement(qtyBaseDelta: delta, type: type);

void main() {
  group('HPP rata-rata bergerak (SPEC §6.2)', () {
    test('dua pembelian berbeda harga memakai rata-rata tertimbang', () {
      final result = replayMovingAverage([buy(100, 1000), buy(100, 2000)]);

      expect(result.stockBase, 200);
      expect(result.avgCostPerBase, 1500);
    });

    test('stok tersisa dihitung dari max(stok, 0)', () {
      // 200 masuk @1500, lalu 150 keluar → sisa 50.
      // Beli lagi 50 @3000 → (50×1500 + 50×3000) / 100 = 2250.
      final result = replayMovingAverage([
        buy(100, 1000),
        buy(100, 2000),
        other(-150, MovementType.saleOut),
        buy(50, 3000),
      ]);

      expect(result.stockBase, 100);
      expect(result.avgCostPerBase, 2250);
    });

    test('stok minus diperlakukan 0 saat pembelian berikutnya', () {
      final result = replayMovingAverage([
        buy(10, 4000),
        other(-25, MovementType.saleOut),
        buy(10, 5000),
      ]);

      expect(result.stockBase, -5);
      expect(result.avgCostPerBase, 5000);
    });

    test('mutasi non-pembelian tidak mengubah harga rata-rata', () {
      final result = replayMovingAverage([
        buy(100, 2000),
        other(20, MovementType.returnIn),
        other(-30, MovementType.opnameAdjust),
      ]);

      expect(result.stockBase, 90);
      expect(result.avgCostPerBase, 2000);
    });

    test('pembelian tanpa biaya per satuan diabaikan untuk rata-rata', () {
      final result = replayMovingAverage([
        CostMovement(
          qtyBaseDelta: 10,
          type: MovementType.purchaseIn,
          costPerBase: null,
        ),
      ]);

      expect(result.stockBase, 10);
      expect(result.avgCostPerBase, 0);
    });
  });

  test('nilai persediaan membulatkan rupiah dan mengabaikan stok minus', () {
    expect(inventoryValueRupiah(1500, 12.5), 18750);
    expect(inventoryValueRupiah(-40, 1000), 0);
  });

  test('selisih opname = fisik − buku', () {
    expect(opnameDiffBase(countedBase: 900, expectedBase: 1000), -100);
    expect(opnameDiffBase(countedBase: 1200, expectedBase: 1000), 200);
  });

  test('biaya per satuan dasar dari harga per satuan', () {
    expect(costPerBaseFrom(150000, 10000), 15);
    expect(() => costPerBaseFrom(1000, 0), throwsArgumentError);
  });
}
