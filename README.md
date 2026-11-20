# Pindai Aja — Aplikasi Kasir & Stok Petshop

Aplikasi kasir dan stok untuk petshop, dibuat untuk dipakai di toko kecil.
**Offline-first**: kasir wajib jalan tanpa internet. Data ditulis ke SQLite
lokal lebih dulu, lalu disinkronkan ke Supabase di latar belakang.

- Uang disimpan sebagai `int` rupiah, stok sebagai `int` satuan dasar (gram/ml).
- Stok adalah **ledger append-only** (`stock_movements`); angka stok tidak
  pernah ditimpa.
- ID dibuat di klien (UUID), sehingga operasi sinkron idempoten.

## Dokumen

| Dokumen | Isi |
|---|---|
| [`SPEC.md`](SPEC.md) | Sumber kebenaran: fitur, skema, aturan bisnis |
| [`DOCUMENTATION.md`](DOCUMENTATION.md) | Tools, MCP, dan cara kerja |
| [`AGENTS.md`](AGENTS.md) | Aturan singkat untuk AI agent |

## Status pengerjaan

| Tahap | Isi | Status |
|---|---|---|
| 0 | Repo, skema Drift + migrasi Supabase, impor Excel, RLS | ✅ Selesai |
| 1 | Produk, scan, kasir tunai, struk Bluetooth, SQLite lokal | ✅ Selesai (di `main`) |
| 2 | Barang masuk, stok, penataan, retur, stok minimum, opname, riwayat harga | ✅ Selesai (branch `tahap2-stock`, menunggu merge) |
| 3 | Login, peran, sinkron multi-perangkat, backup | ⬜ Belum |
| 4 | Pelanggan/utang, diskon, laba rugi, biaya, cetak barcode | ⬜ Belum |
| 5 | QRIS/e-wallet/transfer/kartu (pencatatan) | ⬜ Belum |
| 6 | Web admin (laporan, produk) | ⬜ Belum |

### Detail Tahap 2

- Barang masuk: `purchases` + `purchase_items` + mutasi `purchase_in` +
  `price_history`.
- Daftar stok, pencarian nama/merek/barcode, filter per lokasi rak, ubah stok
  minimum, dan tab "Perlu dibeli" (dikelompokkan per pemasok).
- Banner peringatan stok menipis di beranda.
- Penataan barang: `products.shelf_location` + riwayat `putaway_log`.
- Stok opname: sesi, hitung fisik, selisih menjadi `opname_adjust`; sesi
  selesai terkunci.
- Retur penjualan (dengan/tanpa struk) dan retur pembelian.
- Riwayat harga beli/jual per produk.
- HPP rata-rata bergerak dihitung ulang dari ledger
  (`replayMovingAverage`), bukan kolom tersimpan.

### Verifikasi

- `dart analyze`: bersih (`No issues found`).
- Tes unit: **56 tes lulus**, termasuk akurasi stok vs hitungan manual, HPP
  rata-rata, filter rak, pencarian barcode, dan cakupan opname per rak/kategori.
- Tes perangkat (`integration_test/stock_flows_test.dart`): alur pembelian,
  stok, minimum/rak, riwayat harga, dan penataan lulus; langkah opname dan
  retur masih diverifikasi.
- Belum diklaim lulus: printer/kamera (manual), sinkron nyata ke Supabase dan
  tes RLS (menunggu kredensial).

## Menjalankan

```bash
flutter pub get
flutter analyze
flutter test
```

Menjalankan di perangkat Android:

```bash
flutter run -d <device-id>
```

Tes alur stok di perangkat nyata (butuh HP tersambung dan tidak sedang dipakai):

```bash
flutter test integration_test/stock_flows_test.dart -d <device-id>
```

## Struktur singkat

```
lib/
  core/        # database Drift, uang, ID, store lokal
  features/
    home/      # beranda + banner stok menipis
    stock/     # barang masuk, stok, penataan, opname, retur
    products/  # data produk
supabase/
  migrations/  # perubahan skema server (wajib via file)
test/          # tes unit & widget
integration_test/  # tes alur di perangkat
```
