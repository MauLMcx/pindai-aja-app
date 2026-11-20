import '../../core/db/app_database.dart';
import '../../core/money.dart';

/// Satu baris struk yang sudah siap dicetak/ditampilkan.
class ReceiptLine {
  const ReceiptLine({
    required this.name,
    required this.unitName,
    required this.qty,
    required this.unitPrice,
    required this.discount,
    required this.lineTotal,
  });

  final String name;
  final String unitName;
  final int qty;
  final int unitPrice;
  final int discount;
  final int lineTotal;
}

/// Menyusun teks struk 32 kolom dari data penjualan + baris item.
///
/// Dipakai layar kasir dan riwayat transaksi supaya struk yang dicetak ulang
/// sama persis dengan struk pertama (SPEC §6.4).
String buildReceiptText({
  required String storeName,
  required Sale sale,
  required List<ReceiptLine> lines,
  required int changeAmount,
}) {
  final buffer = StringBuffer()
    ..writeln(storeName)
    ..writeln('No: ${sale.receiptNo}')
    ..writeln(_formatDateTime(sale.soldAt.toLocal()))
    ..writeln('-' * 32);
  for (final line in lines) {
    buffer.writeln('${line.name} (${line.unitName})');
    buffer.writeln(
      '  ${line.qty} x ${formatRupiah(line.unitPrice)}'
      '  ${formatRupiah(line.lineTotal)}',
    );
    if (line.discount > 0) {
      buffer.writeln('  diskon -${formatRupiah(line.discount)}');
    }
  }
  buffer
    ..writeln('-' * 32)
    ..writeln('Subtotal  ${formatRupiah(sale.subtotal)}');
  if (sale.discountTotal > 0) {
    buffer.writeln('Diskon    -${formatRupiah(sale.discountTotal)}');
  }
  buffer
    ..writeln('Total     ${formatRupiah(sale.total)}')
    ..writeln('Bayar     ${formatRupiah(sale.paidTotal)}');
  if (sale.paidTotal < sale.total) {
    buffer.writeln('Utang     ${formatRupiah(sale.total - sale.paidTotal)}');
  } else {
    buffer.writeln('Kembali   ${formatRupiah(changeAmount)}');
  }
  if (sale.status == SaleStatus.voided) {
    buffer.writeln('*** DIBATALKAN ***');
  }
  buffer
    ..writeln('-' * 32)
    ..writeln('Terima kasih sudah berbelanja');
  return buffer.toString();
}

String _formatDateTime(DateTime value) {
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(value.day)}-${two(value.month)}-${value.year} '
      '${two(value.hour)}:${two(value.minute)}';
}
