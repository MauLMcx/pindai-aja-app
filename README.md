<div align="center">

# 🐾 Pindai Aja

**Aplikasi kasir & stok petshop — tetap jalan saat mati lampu dan tanpa internet.**

[![CI](https://github.com/MauLMcx/pindai-aja-app/actions/workflows/ci.yml/badge.svg)](https://github.com/MauLMcx/pindai-aja-app/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.50-02569B?logo=flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Postgres%20%2B%20RLS-3ECF8E?logo=supabase&logoColor=white)
![Offline-first](https://img.shields.io/badge/offline--first-wajib-brightgreen)
![Tahap](https://img.shields.io/badge/tahap-3%20dari%206-orange)

</div>

## 📈 Progres

**Posisi sekarang: Tahap 3 — login, peran, sinkron, dan backup sudah ada; uji ke proyek Supabase nyata belum.**

`████████████░░░░░░░░` **±60%** dari seluruh tahap

| Tahap | Fokus | Progres | Status |
|:---:|---|:---:|:---:|
| **0** | Fondasi: Flutter, Drift, impor Excel, RLS, CI | `██████████` 100% | ✅ |
| **1** | Kasir tunai, scan, struk Bluetooth | `█████░░░░░` 50% | 🚧 |
| **2** | Barang masuk, stok, opname, retur | `███░░░░░░░` 30% | 🚧 |
| **3** | Login, peran, sinkron, backup | `████████░░` 80% | 🚧 |
| **4** | Pelanggan/utang, laporan, barcode | `██░░░░░░░░` 20% | 🚧 |
| **5** | Pembayaran non-tunai | `░░░░░░░░░░` 0% | ⏳ |
| **6** | Web admin | `░░░░░░░░░░` 0% | ⏳ |

> Angka progres adalah rata-rata kasar status tahap, bukan janji rilis. Bukti per butir ada di [`DOCUMENTATION.md`](DOCUMENTATION.md#6-daftar-tugas-awal-tahap-0); rencana tahap di [`SPEC.md`](SPEC.md) §15.

## ✅ Sudah jalan

- **Database lokal (Drift)** — 25 tabel, ledger stok/utang *append-only*, migrasi ber-versi.
- **Sinkron** — push/pull idempoten per `op_id`, tarik per `server_seq`; jaringan putus tidak membuang antrean.
- **Server Supabase** — migrasi `0001`–`0005`, RLS aktif di 24 tabel, tes isolasi antar-toko ada di `supabase/tests/`.
- **Login & peran** — Supabase Auth email+password; sesi disimpan sehingga app tetap terbuka tanpa internet (S8). Staf tidak melihat impor/backup.
- **Antrean sinkron** — layar "Antrean sinkron" dengan label "Perlu diselesaikan" untuk barcode bentrok; jeda coba ulang eksponensial.
- **Backup** — file JSON harian (disimpan 14 hari) + ekspor/impor manual; tema & ID perangkat tidak ikut diganti.
- **Impor Excel** — 86 produk dari `Data_Harga_Pakan.xlsx`; impor ulang melewati produk yang sudah ada.
- **Kasir tunai** — cari produk, keranjang, uang diterima, kembalian, struk di layar.
- **Nomor struk lokal** — `<kode perangkat>-<yyyyMMdd>-<counter>`, unik walau dua HP offline.
- **Harga jual kosong** — dialog "Atur harga jual", tersimpan ke `price_history` + `outbox`.
- **Tema** — terang / gelap / ikut sistem.

## 🚧 Berikutnya

- **Tahap 1** — scan kamera, diskon baris/transaksi, pelanggan, bayar campuran, tahan (hold), void dari layar, cetak & cetak ulang struk.
- **Tahap 2** — layar barang masuk, susun barang, stok opname, retur, stok minimum.
- **Tahap 3** — uji ke proyek Supabase DEV (S1–S8 nyata), unggah backup otomatis, PIN lokal opsional.
- **Tahap 4** — layar pelanggan/utang, laporan laba rugi, biaya operasional, cetak barcode.
- **Tahap 5–6** — pembayaran non-tunai, web admin.

## 🧪 Tes

| Jenis | Jumlah | Status |
|---|:---:|---|
| Host (`flutter test`) | 88 | ✅ lulus |
| Perangkat Android (`integration_test`) | 6 | ✅ lulus di PKG110 / Android 16 |
| `dart analyze` / `flutter analyze` | — | ✅ bersih |
| Kamera & printer Bluetooth | — | 🖐️ **manual**, belum diklaim selesai |

## 🚀 Jalankan

```bash
flutter pub get
flutter run                    # app di HP/emulator
flutter analyze                # analisis statis
flutter test                   # tes host
flutter test integration_test -d <serial>   # tes di HP tersambung
```

Dengan server (opsional; tanpa ini app berjalan mode lokal):

```bash
flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co \
            --dart-define=SUPABASE_ANON_KEY=eyJ...
```

Hanya `anon key` yang boleh dipakai di app. Jangan pernah memakai `service_role` di aplikasi atau menyimpan rahasia di repo.

Data awal: ikuti [`DOCUMENTATION.md`](DOCUMENTATION.md#63-login-sinkron-dan-backup-tahap-3) §6.3 (impor CSV → koreksi harga → opname pertama).

## 📚 Dokumen

| Dokumen | Isi |
|---|---|
| [`SPEC.md`](SPEC.md) | Sumber kebenaran: fitur, model data, sinkron, tahap |
| [`DOCUMENTATION.md`](DOCUMENTATION.md) | Tools, MCP, status pelaksanaan, cara menguji |
| [`AGENTS.md`](AGENTS.md) | Aturan kerja AI agent di repo ini |
| [`docs/agents/`](docs/agents) | Panduan issue tracker, label triage, dan domain |
| [`SETUP-MCP.md`](SETUP-MCP.md) | Pemasangan MCP `petshop-dev` |

---

Dibuat untuk toko petshop sungguhan: **1 toko, 2–3 pengguna, ±100 transaksi/hari**. Uang disimpan sebagai `int` rupiah, stok sebagai `int` satuan dasar, dan semua ID dibuat di klien.
