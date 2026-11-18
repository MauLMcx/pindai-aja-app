# SPEC.md — Aplikasi Kasir & Stok Petshop (Offline-First)

> Dokumen ini adalah **sumber kebenaran tunggal** untuk AI agent. Jika kode bertentangan dengan dokumen ini, dokumen ini yang benar. Jika dokumen ini ambigu atau salah, **berhenti dan tanyakan** ke pemilik, jangan menebak. Perubahan keputusan dicatat di bagian "Log Keputusan" (paling bawah).

Versi: 0.1 · Bahasa UI: Indonesia · Mata uang: Rupiah (IDR)

---

## 1. Tujuan

Aplikasi untuk toko petshop (pakan kucing, pakan ikan, pakan kelinci, pasir kucing, dll.) yang mencakup: barang masuk, penataan barang per barcode, barang keluar (kasir), harga beli dan jual, scan barcode lewat kamera HP, beberapa metode bayar, stok minimum, stok opname, retur, diskon, pelanggan dan utang, laporan laba rugi, cetak struk Bluetooth, cetak barcode sendiri, dan sinkron ke cloud.

**Prioritas mutlak:** kasir harus tetap berfungsi penuh saat **mati lampu dan tanpa internet**.

## 2. Konteks Bisnis

- 1 toko saat ini. Struktur data harus **siap multi-cabang** (kolom `store_id`) tetapi UI cabang belum dibuat.
- 2–3 pengguna, pekerjaannya sama (pemilik merangkap kasir/gudang).
- Puncak transaksi sekitar 100 per hari. Skala ini kecil: **jangan over-engineer** (tidak perlu microservice, queue, cache terdistribusi).
- Perangkat: HP Android (utama), web/desktop (admin dan laporan).
- Printer: printer struk thermal Bluetooth kecil. **Asumsi awal: 58 mm, ESC/POS, Bluetooth klasik (SPP).** Model pasti belum diketahui, jadi printer harus di belakang interface yang bisa diganti (lihat §11).
- Tidak ada scanner fisik. Scan memakai kamera HP.
- Anggaran: Rp0 sampai maksimal Rp200 ribu per bulan. Wajib memakai layanan gratis. Distribusi Android lewat **APK langsung**, bukan Play Store.

### 2.1 Data awal (file `Data_Harga_Pakan.xlsx`)

Empat sheet, masing-masing dari pemasok berbeda. Aturan impor ada di §14. Temuan penting yang memengaruhi desain:

1. Tiga sheet memakai **ribuan rupiah** (430 = Rp430.000), satu sheet (Sungai Ulin) memakai rupiah penuh.
2. Satu merek punya banyak **varian** (rasa/warna). Setiap varian adalah produk tersendiri dengan barcode sendiri.
3. Ada **konversi satuan** (misalnya pasir "3 liter, isi 10": beli per dus, jual per pcs).
4. Ada harga kosong, dicoret, atau tulisan kurang jelas. Data tidak boleh ditebak.
5. File hanya berisi **harga beli**. Harga jual belum ada.

## 3. Prinsip Wajib (tidak boleh dilanggar)

| # | Prinsip | Alasan |
|---|---|---|
| P1 | **Offline-first.** Semua operasi kasir/stok menulis ke SQLite lokal lebih dulu. UI tidak boleh menunggu jaringan. | Sering mati lampu |
| P2 | **Stok = buku mutasi (ledger) append-only.** Stok tidak pernah ditimpa. Stok saat ini = jumlah semua `qty_base_delta`. | Menghindari konflik antar HP offline |
| P3 | **ID dibuat di klien (UUID v4/v7).** Nomor struk memakai kode perangkat + tanggal + counter lokal. | Tidak bentrok antar perangkat |
| P4 | **Uang = integer rupiah.** Tidak ada `double` untuk uang. Biaya per satuan dasar boleh `numeric(14,4)` lalu dibulatkan di total baris. | Menghindari selisih desimal |
| P5 | **Kuantitas = integer dalam satuan dasar** (pcs, gram, ml). Tidak ada float untuk stok. | Presisi |
| P6 | **Soft delete.** Data tidak dihapus fisik, pakai `deleted_at`. Transaksi dibatalkan lewat status `void` + mutasi balik. | Audit dan sinkron |
| P7 | **Penjualan saat stok minus tetap boleh** (peringatan, bukan blokir). | Stok fisik bisa belum dicatat saat offline |
| P8 | **Semua operasi sinkron idempoten.** Mengirim ulang operasi yang sama tidak boleh menggandakan data. | Jaringan putus-sambung |
| P9 | **Tidak ada rahasia di klien.** Hanya `anon key` Supabase di app, semua tabel dilindungi RLS. `service_role` key tidak pernah masuk kode app atau repo. | Keamanan |

## 4. Tech Stack

| Lapisan | Pilihan | Catatan |
|---|---|---|
| App | **Flutter** (Android, web, desktop dari satu kode) | Gunakan versi stabil terbaru. Verifikasi API paket lewat Context7, jangan dari ingatan |
| State | Riverpod | |
| DB lokal | **SQLite via Drift** | Migrasi skema ber-versi |
| Cloud | **Supabase** (PostgreSQL + Auth + RLS), paket gratis | Cek batas paket gratis sebelum rilis |
| Scan | `mobile_scanner` | |
| Printer | `print_bluetooth_thermal` + `esc_pos_utils_plus` (atau setara) | Verifikasi paket aktif dan mendukung Bluetooth klasik. Bungkus di interface |
| Cetak label | `pdf` + `printing` | |
| Web admin | Flutter web, deploy ke Cloudflare Pages atau Firebase Hosting | |
| Alternatif sinkron | PowerSync (hanya jika sinkron buatan sendiri terbukti rumit) | Keputusan harus dicatat di Log |

**Struktur folder yang diharapkan**

```
lib/
  core/            # db, sync, uuid, money, errors, theme
  features/
    products/ purchasing/ inventory/ sales/ payments/
    customers/ returns/ opname/ reports/ printing/ barcode/ settings/ auth/
  main.dart
supabase/
  migrations/      # SQL ber-versi, satu-satunya cara ubah skema server
  seed/
test/ integration_test/
tools/             # skrip bantu (impor Excel, dll.)
docs/
```

## 5. Peran Pengguna

- `owner`: semua akses termasuk laporan laba rugi, HPP, pengaturan, dan pengelolaan pengguna.
- `staff`: kasir, barang masuk, stok, pelanggan. **UI menyembunyikan HPP dan laba.**
- Catatan: penyembunyian HPP hanya di UI (RLS tidak menyembunyikan kolom). Ini risiko yang diterima pada skala toko ini. Dicatat agar tidak dianggap bug.
- Login lewat Supabase Auth (email + password). **Setelah login pertama, app harus bisa dibuka offline** dengan sesi tersimpan. Tambahkan kunci PIN lokal opsional.

## 6. Fitur dan Kriteria Penerimaan

Setiap fitur dianggap selesai hanya jika semua kriteria penerimaan (KP) lulus, termasuk saat **offline**.

### 6.1 Produk dan Satuan
- Produk: nama, merek, varian, kategori, satuan dasar, stok minimum, lokasi rak (teks), status aktif.
- Satu produk punya banyak satuan (`product_units`), contoh: pcs (faktor 1), dus isi 10 (faktor 10), kg = 1000 gram. Tiap satuan bisa punya barcode dan harga jual sendiri.
- KP1: Tambah produk baru, jual, dan stok berkurang tepat tanpa internet.
- KP2: Barcode unik per toko. Barcode ganda ditolak dengan pesan jelas.
- KP3: Produk dengan harga belum lengkap ditandai `needs_price_review` dan muncul di daftar "Perlu dilengkapi".

### 6.2 Barang Masuk (pembelian)
- Pilih pemasok, tanggal, item (scan atau cari), jumlah, satuan, harga beli per satuan.
- Menghasilkan mutasi stok `purchase_in` dan baris `price_history` jenis `buy`.
- **HPP memakai rata-rata bergerak (weighted average)** per satuan dasar: `avg_baru = (max(stok,0) × avg_lama + qty_masuk × biaya_masuk) / (max(stok,0) + qty_masuk)`.
- Opsi "perbarui harga jual otomatis" memakai aturan margin (persen atas harga beli, default dapat diubah per produk/kategori). Hasilnya selalu bisa diedit manual.
- KP: Harga beli naik dari pembelian sebelumnya menampilkan peringatan selisih.

### 6.3 Penataan Barang (putaway)
- Layar "Susun Barang": scan barcode, isi atau ubah lokasi rak. Riwayat perubahan disimpan di `putaway_log`.
- Pencarian produk di kasir/stok bisa difilter per lokasi rak.
- KP: Scan barcode produk, lokasi tampil, bisa diubah dalam kurang dari 3 ketukan.

### 6.4 Kasir (barang keluar)
- Scan kamera menambah item. Scan ulang barcode yang sama menaikkan jumlah. Cari manual juga tersedia.
- Pilih satuan jual per baris, ubah jumlah, diskon per baris dan per transaksi, pilih pelanggan (opsional).
- Pembayaran campuran (split) didukung. Kembalian untuk tunai.
- Setelah bayar: simpan, kurangi stok (mutasi `sale_out`), cetak struk (jika printer tersambung), tombol "kirim ulang/cetak ulang".
- Transaksi dalam keadaan belum selesai bisa **ditahan (hold)** dan dilanjutkan.
- KP1: 10 transaksi berturut-turut dalam mode pesawat berjalan tanpa error, lalu sinkron setelah online tanpa duplikasi.
- KP2: Barcode tidak dikenal menampilkan opsi "Buat produk baru dengan barcode ini".
- KP3: Waktu dari scan ke baris tampil di keranjang di bawah 500 ms pada HP menengah.

### 6.4.1 Pembatalan (void)
- Hanya `owner`. Transaksi berstatus `void` + mutasi stok `void_in` yang membalik penjualan. Tidak ada penghapusan.

### 6.5 Retur
- **Retur penjualan** (pelanggan mengembalikan): pilih transaksi asal atau tanpa transaksi, pilih item dan jumlah, stok kembali (`return_in`) dengan biaya sesuai `cost_per_base` pada baris penjualan asal. Refund: tunai/metode lain atau mengurangi utang pelanggan.
- **Retur pembelian** (ke pemasok): mutasi `purchase_return_out`. Utang ke pemasok di luar cakupan versi 1.
- KP: Laporan laba rugi mengurangi omzet dan HPP sesuai retur.

### 6.6 Diskon
- Diskon baris dan diskon transaksi, dalam nominal atau persen. **Disimpan sebagai nominal rupiah hasil hitung** agar laporan tidak berubah jika preset diedit.
- Preset diskon (opsional) di pengaturan.

### 6.7 Stok Minimum
- Produk di bawah stok minimum (dalam satuan dasar) muncul di daftar "Perlu dibeli", dikelompokkan per pemasok utama.
- Notifikasi lokal saat app dibuka, tanpa server push.

### 6.8 Stok Opname
- Buat sesi opname (seluruh toko atau per kategori/rak). Scan barcode, input jumlah fisik.
- Saat selesai: selisih = fisik − stok buku **pada waktu selesai**, dicatat sebagai mutasi `opname_adjust` dengan alasan. Hasil opname tidak bisa diedit setelah selesai, hanya bisa dikoreksi dengan opname baru.
- KP: Laporan selisih opname (nilai rupiah memakai HPP).

### 6.9 Pelanggan dan Utang (kasbon)
- Data pelanggan (nama, HP, catatan, batas kasbon opsional).
- Penjualan kredit menambah utang. Pembayaran utang (cicilan) mengurangi. Semua lewat `debt_ledger` (append-only, saldo = jumlah delta).
- KP: Layar utang menampilkan saldo, riwayat, dan tombol cetak/kirim rincian.

### 6.10 Laporan
- Harian/mingguan/bulanan/rentang bebas: omzet, diskon, retur, HPP, **laba kotor**, biaya operasional, **laba bersih**, jumlah transaksi, produk terlaris, produk stok lambat, nilai persediaan, rekap per metode bayar.
- `expenses` (biaya operasional: listrik, gaji, dll.) diinput manual.
- HPP diambil dari `sale_items.cost_per_base` (snapshot saat penjualan), **bukan dihitung ulang**.
- Laporan dihitung dari data lokal. Beri penanda "data terakhir disinkron pada …".
- Ekspor: CSV (wajib), PDF (opsional).

### 6.11 Cetak Barcode
- Untuk produk tanpa barcode pabrik, buat barcode internal **EAN-13 dengan awalan `2`** (rentang 20–29 untuk pemakaian dalam toko). Format: `2` + kode toko 2 digit + nomor urut 9 digit + digit cek.
- Cetak label PDF (ukuran dapat diatur: kolom per halaman, ukuran label) atau lewat printer thermal bila mendukung.
- Setiap barcode internal tercatat dengan `barcode_source = 'internal'`.

## 7. Model Data

Konvensi semua tabel: `id uuid pk` (dibuat klien), `store_id uuid`, `created_at`, `updated_at`, `deleted_at null`, `device_id`, dan di server `server_seq bigint` (diisi trigger dari sequence global, naik setiap insert/update). Tabel ledger (`stock_movements`, `debt_ledger`, `putaway_log`, `price_history`) **append-only**: tidak ada UPDATE/DELETE.

```sql
-- ===== Inti (server: PostgreSQL; klien: Drift dengan bentuk setara) =====
create type movement_type as enum (
  'purchase_in','sale_out','return_in','purchase_return_out',
  'opname_adjust','void_in','manual_adjust','initial'
);
create type pay_method as enum ('cash','qris','ewallet','transfer','card','credit');

create table stores(id uuid primary key, name text not null, code2 text not null);
create table profiles(user_id uuid primary key references auth.users, store_id uuid not null,
  role text not null check (role in ('owner','staff')), display_name text);
create table devices(id uuid primary key, store_id uuid not null, code text not null, name text);

create table suppliers(id uuid primary key, store_id uuid not null, name text not null, phone text, note text, /*konvensi*/);
create table categories(id uuid primary key, store_id uuid not null, name text not null, default_margin_pct numeric(6,2));

create table products(
  id uuid primary key, store_id uuid not null,
  name text not null, brand text, variant text, category_id uuid,
  base_unit text not null,                 -- pcs | gram | ml
  min_stock_base integer not null default 0,
  shelf_location text, main_supplier_id uuid,
  needs_price_review boolean not null default false,
  is_active boolean not null default true, note text
);
create table product_units(
  id uuid primary key, product_id uuid not null references products,
  unit_name text not null,                 -- pcs, dus, kg, karung
  factor_to_base integer not null check (factor_to_base > 0),
  barcode text, barcode_source text check (barcode_source in ('factory','internal')),
  sell_price integer,                      -- rupiah, boleh null jika belum ditentukan
  is_default_sale boolean default false, is_default_purchase boolean default false,
  unique (store_id, barcode)
);
create table price_history(id uuid primary key, product_unit_id uuid not null, kind text check (kind in ('buy','sell')),
  price integer not null, effective_at timestamptz not null, source_ref text);

create table purchases(id uuid primary key, supplier_id uuid, doc_no text, purchased_at timestamptz not null,
  total integer not null, note text, status text not null default 'completed');
create table purchase_items(id uuid primary key, purchase_id uuid not null, product_id uuid not null, unit_id uuid not null,
  qty integer not null, unit_cost integer not null, qty_base integer not null, cost_per_base numeric(14,4) not null);

create table stock_movements(            -- APPEND-ONLY
  id uuid primary key, store_id uuid not null, product_id uuid not null,
  qty_base_delta integer not null, type movement_type not null,
  ref_type text, ref_id uuid, cost_per_base numeric(14,4),
  occurred_at timestamptz not null, note text, device_id uuid, server_seq bigint
);
create table putaway_log(id uuid primary key, product_id uuid not null, from_location text, to_location text, occurred_at timestamptz not null);

create table customers(id uuid primary key, store_id uuid not null, name text not null, phone text, note text, credit_limit integer);
create table debt_ledger(id uuid primary key, customer_id uuid not null, delta integer not null,  -- + utang, - bayar
  type text not null check (type in ('sale_credit','payment','return_offset','adjustment')),
  ref_id uuid, method pay_method, occurred_at timestamptz not null, note text);

create table sales(id uuid primary key, store_id uuid not null, receipt_no text not null, device_id uuid not null,
  cashier_id uuid not null, customer_id uuid, sold_at timestamptz not null,
  subtotal integer not null, discount_total integer not null default 0, total integer not null,
  paid_total integer not null, change_amount integer not null default 0,
  status text not null default 'completed' check (status in ('completed','void','hold')), note text,
  unique (store_id, receipt_no));
create table sale_items(id uuid primary key, sale_id uuid not null, product_id uuid not null, unit_id uuid not null,
  qty integer not null, qty_base integer not null, unit_price integer not null, discount integer not null default 0,
  line_total integer not null, cost_per_base numeric(14,4));   -- snapshot HPP
create table payments(id uuid primary key, sale_id uuid not null, method pay_method not null, amount integer not null,
  status text not null default 'confirmed' check (status in ('confirmed','pending')),
  reference text, paid_at timestamptz not null);

create table returns(id uuid primary key, kind text check (kind in ('sale','purchase')), sale_id uuid, purchase_id uuid,
  customer_id uuid, returned_at timestamptz not null, refund_method pay_method, refund_total integer not null default 0, reason text);
create table return_items(id uuid primary key, return_id uuid not null, product_id uuid not null, unit_id uuid not null,
  qty integer not null, qty_base integer not null, amount integer not null, cost_per_base numeric(14,4));

create table stock_opnames(id uuid primary key, started_at timestamptz not null, finished_at timestamptz,
  status text not null default 'open' check (status in ('open','finished')), scope text, note text);
create table stock_opname_items(id uuid primary key, opname_id uuid not null, product_id uuid not null,
  expected_base integer, counted_base integer not null, diff_base integer);

create table expenses(id uuid primary key, category text not null, amount integer not null, spent_at timestamptz not null, note text);
create table app_settings(store_id uuid, key text, value jsonb, primary key (store_id,key));  -- mis. gambar QRIS statis, margin default, info struk

-- View stok
create view stock_balance as
  select product_id, sum(qty_base_delta)::int as qty_base from stock_movements group by product_id;
```

**Tabel khusus klien (tidak ada di server):**
`outbox(op_id uuid pk, table_name, row_id, op, payload json, created_at, attempts, last_error, synced_at)` dan `sync_state(key, value)` (menyimpan `last_pulled_seq` per tabel).

**RLS:** semua tabel `enable row level security`; kebijakan: `store_id = (select store_id from profiles where user_id = auth.uid())`. Tidak ada akses anon tanpa login. Setiap tabel baru **wajib** disertai kebijakan RLS dan tes yang membuktikannya.

## 8. Desain Sinkron

**Alur tulis:** UI → transaksi SQLite lokal (data + baris `outbox` dalam **satu transaksi**) → pekerja latar belakang mengirim `outbox` berurutan.

**Push:** panggilan RPC `sync_push(ops jsonb)`; server menyimpan `applied_ops(op_id)` dan melewati op yang sudah diterapkan (idempoten, P8). Gagal sebagian tidak boleh merusak: setiap op diterapkan dalam transaksi sendiri, kegagalan dicatat di `last_error` dan dicoba ulang dengan backoff.

**Pull:** `sync_pull(table, since_seq, limit=500)` mengembalikan baris dengan `server_seq > since_seq`. Klien melakukan upsert, lalu menyimpan `last_pulled_seq`. Ulangi sampai kosong.

**Bentuk op (implementasi `0003_sync_rpc`–`0005_sync_push_robust`):**

```json
{ "op_id": "uuid", "table": "products", "row_id": "uuid",
  "op": "insert | update | upsert | delete", "payload": { "...": "kolom baris" } }
```

`sync_push` membalas array `{ "op_id", "status": "applied | skipped | error", "error"? }`. Aturan server:

- `op_id` yang sudah tercatat di `applied_ops` → `skipped` (idempoten, P8).
- `payload.store_id` (atau `payload.id` untuk `stores`) wajib sama dengan toko pengguna; selain itu `error`.
- `insert` memakai `on conflict (pk) do nothing`; pelanggaran unique lain (mis. barcode ganda) menghasilkan `error` dan **tidak** menimpa baris lama.
- `delete` hanya mengisi `deleted_at`; tabel ledger tanpa `deleted_at` ditolak.
- `profiles` tidak disinkronkan (dikelola server); daftar tabel ada di `sync_allowed_tables()`.
- Hanya role `authenticated` yang boleh memanggil RPC; `applied_ops` tidak bisa dibaca langsung (RLS tanpa policy).
- `sync_pull` berjalan dengan hak pengguna (RLS) dan menambahkan filter `store_id` eksplisit sebagai lapisan kedua.
- Satu op yang gagal (termasuk `op_id` tidak valid) hanya menghasilkan `error` untuk op itu; op lain dalam batch tetap diterapkan.

**Pemicu sinkron:** setelah setiap transaksi lokal, saat konektivitas kembali, saat app dibuka/kembali ke depan, dan periodik tiap beberapa menit. Realtime Supabase **tidak wajib**.

**Aturan konflik:**
| Jenis data | Aturan |
|---|---|
| Ledger append-only (`stock_movements`, `debt_ledger`, `price_history`, `putaway_log`) | Tidak ada konflik, cukup gabungkan (union) |
| Transaksi (`sales`, `purchases`, dst.) | Dibuat sekali, perubahan hanya lewat status (`void`) atau dokumen baru |
| Data master (`products`, `product_units`, `customers`, `suppliers`) | **Last-write-wins** berdasarkan `updated_at`; seri dimenangkan server |
| Barcode ganda dari dua perangkat | Server menolak yang kedua, klien menampilkan antrean "Perlu diselesaikan" ke pengguna. Jangan menimpa diam-diam |

**Indikator di UI:** ikon status sinkron (sinkron / menunggu N / gagal), halaman "Antrean sinkron" untuk melihat dan mencoba ulang yang gagal.

**Backup:** ekspor harian terjadwal seluruh data ke file (Google Drive/penyimpanan lain yang gratis), karena paket gratis tidak menjamin backup. Dokumentasikan prosedur pemulihan dan **uji pemulihan** sebelum rilis.

## 9. Pembayaran

| Metode | Versi awal | Tahap lanjut |
|---|---|---|
| Tunai | Langsung, hitung kembalian | |
| QRIS | Tampilkan **QRIS statis toko** (gambar di pengaturan), kasir konfirmasi manual, status `confirmed`. Jika belum yakin: `pending`, lalu dikonfirmasi nanti | QRIS dinamis lewat gateway (Midtrans/Xendit/dll.) hanya saat online |
| E-wallet | Dicatat dengan referensi (opsional) | Gateway |
| Transfer | Dicatat dengan referensi (opsional) | Gateway |
| Kartu | Dicatat saja (mesin EDC terpisah) | Tidak ada integrasi |
| Kredit (kasbon) | Menambah utang pelanggan | |

Pembayaran `pending` muncul di daftar "Perlu dikonfirmasi" dan tidak dihitung sebagai kas masuk sampai dikonfirmasi. **Integrasi gateway hanya dikerjakan di Tahap 5** dan semua kunci rahasia gateway hanya boleh ada di server (Edge Function), tidak di app.

## 10. Alur Layar Utama (ringkas)

`Beranda` (omzet hari ini, status sinkron, stok menipis) · `Kasir` · `Produk` · `Barang Masuk` · `Susun Barang` · `Stok & Opname` · `Retur` · `Pelanggan & Utang` · `Laporan` · `Pengaturan` (printer, QRIS, margin, pengguna, backup).

Prinsip UI: layar kasir **satu tangan, tombol besar, tanpa dialog yang tidak perlu**. Teks dalam Bahasa Indonesia. Angka rupiah diformat `Rp 1.250.000`.

## 11. Printer Struk (Bluetooth)

- Interface: `ReceiptPrinter { connect(device), disconnect(), printReceipt(ReceiptData), printLabel(...), isConnected }`. Implementasi awal: ESC/POS Bluetooth klasik Android. Lebar kertas dan jumlah karakter per baris **dapat dikonfigurasi** (default 58 mm = 32 karakter, mode 80 mm = 48 karakter).
- Pengaturan: pilih printer dari daftar perangkat terpasang, tes cetak, simpan printer terakhir, sambung ulang otomatis.
- Jika printer tidak tersambung: transaksi **tetap tersimpan**, tampilkan opsi "cetak nanti". Kegagalan cetak tidak boleh membatalkan transaksi.
- Tata letak struk: nama toko dan alamat, nomor struk, tanggal/jam, kasir, daftar item (nama, qty × harga, subtotal), diskon, total, metode bayar, kembalian, catatan kaki. Nama produk dipotong rapi, bukan dipatah di tengah kata bila memungkinkan.
- Izin Android (Bluetooth connect/scan, kamera) diminta saat dibutuhkan dengan penjelasan jelas, kompatibel Android lama dan baru.
- **Pengujian printer tidak bisa diotomatisasi.** Sediakan checklist manual (cetak struk panjang, karakter khusus, banyak item, putus koneksi di tengah cetak).

## 12. Aturan Barcode dan Scan

- Format dibaca: EAN-13, EAN-8, UPC-A, Code 128, QR.
- Pembacaan memakai debounce (hindari baca ganda), bunyi/getar singkat saat sukses.
- Pencarian barcode dari tabel lokal dengan indeks pada `(store_id, barcode)`.
- Satu barcode mengacu ke **satu `product_unit`** (satuan tertentu).

## 13. Non-Fungsional

- **Performa:** daftar produk beberapa ribu baris harus tetap mulus (paginasi/lazy list, indeks di kolom pencarian).
- **Keandalan:** tidak ada kehilangan data saat app dimatikan paksa di tengah transaksi (transaksi atomik).
- **Keamanan:** P9, RLS, data sensitif tidak dicetak ke log, `.env` tidak masuk git.
- **Aksesibilitas dasar:** ukuran sentuh minimal 48 dp, kontras cukup.
- **Pembaruan app:** APK diberi nomor versi, skema Drift bermigrasi aman tanpa menghapus data.
- **Zona waktu:** simpan UTC, tampilkan WITA/lokal (zona toko dapat diatur).

## 14. Impor Data Awal (Excel)

Skrip: `tools/import_excel.py`, hasil CSV dikoreksi manual oleh pemilik **sebelum** dimuat ke app.

1. Baca semua sheet. Setiap sheet punya skala berbeda: tiga sheet "ribuan" (×1000), sheet Sungai Ulin "rupiah penuh". Skala ditentukan eksplisit per sheet di konfigurasi, jangan ditebak otomatis.
2. Harga kosong dibiarkan kosong dan `needs_price_review = true`. Jangan mengisi nol.
3. Baris yang dicoret (misalnya "Meo Ikan (dicoret)") **dilewati**, dengan laporan yang menjelaskan.
4. Tulisan bertanda "kurang jelas" diimpor tetapi diberi flag `needs_price_review`.
5. Varian di dalam tanda kurung (warna/rasa) dipisah menjadi kolom `variant`.
6. Teks "isi N" dan "N liter/gr/kg" diurai menjadi faktor satuan dan ukuran, bila gagal ditandai manual.
7. Kolom hasil: `supplier, brand, name, variant, size, pack_qty, buy_price_idr, needs_price_review, source_sheet, source_row, notes`.
8. Hasil impor menghasilkan laporan: jumlah baris, dilewati, perlu dicek. Tidak ada harga jual (diisi pakai aturan margin setelah pemilik menyetujui).
9. Stok awal dimasukkan lewat mutasi `initial` (hasil opname pertama), bukan dari file harga.

## 15. Rencana Tahap dan Definition of Done

Setiap tahap harus ditutup dengan: semua KP lulus, `dart analyze` bersih, tes unit dan integrasi lulus, skenario offline di §16 yang relevan lulus, dokumen diperbarui, dan commit rapi.

| Tahap | Isi | Kriteria selesai utama |
|---|---|---|
| 0 | Repo, skema Drift + migrasi Supabase, skrip impor Excel, RLS, CI sederhana | Data hasil impor terlihat di app, tes RLS lulus |
| 1 | Produk, scan, kasir tunai, struk Bluetooth, SQLite lokal | 10 transaksi offline + cetak struk di perangkat nyata |
| 2 | Barang masuk, stok, penataan, retur, stok minimum, opname, riwayat harga | Stok akurat vs perhitungan manual |
| 3 | Login, peran, sinkron multi-perangkat, backup | Skenario S1–S8 lulus |
| 4 | Pelanggan/utang, diskon, laba rugi, biaya, cetak barcode | Laporan cocok dengan hitungan manual contoh |
| 5 | QRIS/e-wallet/transfer/kartu (pencatatan; gateway opsional) | Pembayaran campuran tercatat benar |
| 6 | Web admin (laporan, produk) | Laporan dapat dibuka dari laptop |

## 16. Skenario Uji Wajib (sinkron/offline)

| ID | Skenario | Hasil yang diharapkan |
|---|---|---|
| S1 | Mode pesawat, 10 penjualan, lalu online | Semua tersinkron, tidak ada duplikat |
| S2 | Kirim ulang `outbox` yang sama dua kali | Server tidak menggandakan (idempoten) |
| S3 | Dua HP offline menjual produk yang sama, lalu online | Stok akhir = stok awal − total keduanya (boleh minus + peringatan) |
| S4 | Dua HP membuat barcode yang sama saat offline | Satu diterima, satu masuk antrean "Perlu diselesaikan" |
| S5 | App dimatikan paksa di tengah simpan transaksi | Tidak ada transaksi setengah jadi |
| S6 | Dua HP mengubah harga produk yang sama | Yang `updated_at` terbaru menang, tidak crash |
| S7 | Jaringan putus di tengah sinkron | Lanjut dari posisi terakhir saat tersambung |
| S8 | Mati lampu: buka app tanpa internet setelah sebelumnya login | App terbuka, kasir berfungsi |
| S9 | Printer mati/di luar jangkauan saat bayar | Transaksi tersimpan, struk bisa dicetak ulang |
| S10 | Impor data awal lalu opname pertama | Stok awal tercatat sebagai `initial`/`opname_adjust`, tidak negatif |

## 17. Di Luar Cakupan (jangan dikerjakan)

Multi-cabang di UI, utang ke pemasok, integrasi kartu langsung, e-commerce/marketplace, program loyalitas, promosi kompleks (beli X gratis Y), pajak/PPN, akuntansi penuh, notifikasi push server, aplikasi iOS.

## 18. Asumsi Terbuka (konfirmasi ke pemilik)

1. Model dan ukuran printer (asumsi 58 mm, Bluetooth klasik, ESC/POS).
2. Apakah `staff` boleh melihat HPP (asumsi: tidak).
3. Aturan margin default (persen) per kategori.
4. Apakah pakan ikan/kelinci dijual per kg (eceran) atau hanya per karung, menentukan satuan dasar gram.
5. Info pada struk (nama toko, alamat, nomor HP, pesan penutup).
6. Zona waktu toko (asumsi WITA).
7. Perlu tidaknya kunci PIN lokal.

## 19. Log Keputusan

| Tanggal | Keputusan | Alasan |
|---|---|---|
| 2026-11-17 | Flutter + Drift + Supabase, sinkron buatan sendiri berbasis ledger | Gratis, offline kuat, skala kecil |
| 2026-11-17 | Tabel ledger (`stock_movements`, `debt_ledger`, `price_history`, `putaway_log`) **tidak** memakai `updated_at`/`deleted_at` | Append-only: baris tidak boleh diubah atau dihapus, jadi kolom audit itu menyesatkan. Konvensi umum §7 tetap berlaku untuk tabel lain |
| 2026-11-17 | Tahap 0: database klien memakai Drift native (Android/desktop). Dukungan web (`WasmDatabase`) ditunda ke Tahap 6 | Web admin baru dibutuhkan di Tahap 6; fokus Tahap 0 pada Android |
| 2026-11-17 | `petshop-dev` dipindah ke `tools/petshop_dev_mcp/` dan memakai `mcp` 2.x (`MCPServer`) | Menyatukan kode tool dengan venv-nya; API `FastMCP` sudah diganti di mcp 2.x |
| 2026-11-17 | Sebelum login (Tahap 3), aplikasi memakai satu toko lokal dengan ID deterministik (`Toko Utama`, kode `01`) | Dua perangkat yang menyala offline tetap memakai baris toko yang sama saat sinkron pertama, bukan membuat dua toko |
| 2026-11-17 | Identitas produk hasil impor = `brand + name + variant + size_text + category` (UUID v5) | Nama yang sama bisa dijual dalam kemasan berbeda (contoh: Meo pouch vs Meo kaleng, Life Cat). Tanpa kategori, dua produk sah akan saling menimpa saat impor |
| 2026-11-17 | Impor: ukuran menjadi satuan dasar (`gram`/`ml`), `pack_qty > 1` dipecah menjadi satuan jual `pcs` dan satuan beli `dus isi N`; `old_price_idr` tidak disimpan | Mengikuti §2 contoh "3 liter, isi 10": beli per dus, jual per pcs. Harga lama hanya informasi, menyimpannya butuh tanggal berlaku yang tidak ada di file |
| 2026-11-17 | Impor tidak mengisi stok; stok awal hanya lewat `initial`/`opname_adjust` | Sesuai §14.9: file hanya berisi harga, bukan jumlah fisik |
| 2026-11-17 | Tahap 1 wajib membuat ID perangkat lokal saat app pertama dijalankan, sebelum login Tahap 3 ada | Server mewajibkan `sales.device_id` (§7). Tanpa ID perangkat, penjualan offline tidak akan bisa disinkronkan |
| 2026-11-18 | Pilihan tema (ikut sistem/terang/gelap) disimpan di `app_settings` dengan kunci `theme_mode`, bukan tabel baru | Setelan tampilan hanya milik perangkat, tidak perlu disinkronkan; tabel `app_settings` sudah tersedia dan tidak mengubah skema server |
| 2026-11-18 | Migrasi server dijalankan berurutan: `0001_init`, lalu `0002_security_hardening`; view `stock_balance` diubah menjadi `security_invoker` | Advisor Supabase menemukan view berjalan dengan hak pemilik sehingga bisa melewati RLS dan membocorkan stok antar-toko. View wajib mengikuti RLS pengguna |
| 2026-11-18 | Tes RLS memakai dua pengguna Auth uji (`rls-test-a@example.test`, `rls-test-b@example.test`) dan dua toko uji di proyek dev; tes juga memeriksa isolasi view `stock_balance` | Membuktikan isolasi antar-toko pada tabel dan view. Data uji hanya di proyek dev, bukan data toko sungguhan |
| 2026-11-18 | Proteksi kata sandi bocor (HaveIBeenPwned) tidak diaktifkan | Fitur ini hanya tersedia di paket Pro; proyek memakai paket gratis. Dicatat sebagai risiko yang diterima sampai ada anggaran |
| 2026-11-18 | RPC sinkron: `sync_push` SECURITY DEFINER dengan validasi toko eksplisit; `sync_pull` SECURITY INVOKER + filter `store_id`; `applied_ops` RLS tanpa policy | Push perlu menulis banyak tabel dalam satu panggilan, jadi hak pemilik dipakai tetapi toko divalidasi per op. Pull cukup mengandalkan RLS pengguna. `applied_ops` hanya untuk idempotensi internal |
| 2026-11-18 | `sync_push` tidak menyinkronkan `profiles` dan menolak tabel di luar `sync_allowed_tables()` | Profil dibuat/dikelola server (peran & toko); daftar tertutup mencegah klien menulis tabel internal |
| 2026-11-18 | Barcode ganda dari klien ditolak sebagai `error`, bukan ditimpa | Sesuai §8: server menolak yang kedua dan klien menampilkan antrean "Perlu diselesaikan" |
| 2026-11-18 | `EXECUTE` pada `sync_push`/`sync_pull` dicabut dari `anon` (migrasi `0004_sync_grants`) | Default privileges Supabase memberi akses ke anon; RPC sinkron hanya untuk pengguna login |
