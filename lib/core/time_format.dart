/// Format tanggal-waktu sederhana untuk UI (WITA/lokal perangkat).
String formatTanggalWaktu(DateTime? value) {
  if (value == null) return 'belum pernah';
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} $hour:$minute';
}
