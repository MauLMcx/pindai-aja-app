/// Utilitas uang. Aturan SPEC P4: uang selalu `int` rupiah, tidak pernah `double`.
library;

/// Format angka rupiah gaya Indonesia: `Rp 1.250.000`.
String formatRupiah(int rupiah) {
  final sign = rupiah < 0 ? '-' : '';
  final digits = rupiah.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${sign}Rp $buffer';
}

/// Baca input pengguna menjadi rupiah bulat. Mengabaikan titik, spasi, dan `Rp`.
int parseRupiah(String input) {
  final negative = input.trim().startsWith('-');
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return 0;
  final value = int.parse(digits);
  return negative ? -value : value;
}

/// Perkalian uang yang aman: hasil selalu integer rupiah.
int multiplyRupiah(int unitPrice, int quantity) => unitPrice * quantity;

/// Bagi total secara merata dengan sisa dibagikan ke bagian awal.
/// Dipakai untuk pembulatan diskon/pembayaran campuran tanpa desimal.
List<int> splitRupiah(int total, int parts) {
  if (parts <= 0) throw ArgumentError.value(parts, 'parts', 'harus > 0');
  final base = total ~/ parts;
  final remainder = total % parts;
  return List<int>.generate(parts, (i) => base + (i < remainder ? 1 : 0));
}
