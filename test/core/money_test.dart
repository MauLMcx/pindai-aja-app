import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/money.dart';

void main() {
  group('formatRupiah', () {
    test('memakai titik ribuan dan awalan Rp', () {
      expect(formatRupiah(1250000), 'Rp 1.250.000');
      expect(formatRupiah(0), 'Rp 0');
      expect(formatRupiah(999), 'Rp 999');
    });

    test('negatif ditandai di depan', () {
      expect(formatRupiah(-2500), '-Rp 2.500');
    });
  });

  group('parseRupiah', () {
    test('mengabaikan titik, spasi, dan Rp', () {
      expect(parseRupiah('Rp 1.250.000'), 1250000);
      expect(parseRupiah('1 250 000'), 1250000);
      expect(parseRupiah(''), 0);
    });
  });

  group('aritmetika rupiah', () {
    test('perkalian tetap bilangan bulat', () {
      expect(multiplyRupiah(48000, 3), 144000);
    });

    test('split tidak kehilangan atau menambah rupiah', () {
      final parts = splitRupiah(100, 3);
      expect(parts.reduce((a, b) => a + b), 100);
      expect(parts.first, 34);
    });
  });
}
