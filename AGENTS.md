# AGENTS.md — Aturan Ringkas untuk AI Agent

(Jika memakai Claude Code, salin isi ini ke `CLAUDE.md` atau buat `CLAUDE.md` berisi `@AGENTS.md`.)

## Baca dulu
1. `SPEC.md` — apa yang dibangun (sumber kebenaran).
2. `DOCUMENTATION.md` — tools, MCP, dan cara kerja.

## Proyek
Aplikasi kasir dan stok petshop. Flutter + Drift (SQLite) + Supabase. **Offline-first**: kasir wajib jalan tanpa internet.

## Aturan yang tidak boleh dilanggar
- Tulis ke SQLite lokal + `outbox` dalam satu transaksi, sinkron di latar belakang. UI tidak menunggu jaringan.
- Stok adalah ledger append-only (`stock_movements`). Jangan menimpa angka stok.
- ID dibuat di klien (UUID). Operasi sinkron harus idempoten.
- Uang = `int` rupiah. Stok = `int` satuan dasar. **Tidak ada `double`** untuk keduanya.
- Soft delete (`deleted_at`). Pembatalan transaksi lewat status `void` + mutasi balik.
- Penjualan saat stok minus tetap boleh (beri peringatan).
- Perubahan skema server hanya lewat file di `supabase/migrations/`. Setiap tabel baru wajib RLS + tes.
- Tidak ada rahasia di app/repo. Hanya `anon key`.
- Jangan menebak API paket: cek Context7 dulu.
- Jangan menghapus/melemahkan tes agar lulus.
- Jangan sentuh data produksi atau jalankan perintah destruktif tanpa izin.
- Printer dan kamera hanya bisa diuji manual: jangan mengklaim sudah diuji.

## Cara kerja
Rencana singkat → tes → implementasi kecil → `dart analyze` + tes → skenario offline relevan (SPEC §16) → perbarui dokumen → commit kecil.

## Bahasa
UI dan pesan ke pemilik: Bahasa Indonesia sederhana. Nama kode/tabel: Inggris `snake_case`.

## Jika ragu
Berhenti dan tanya. Jangan mengubah perilaku di SPEC secara diam-diam. Catat keputusan di SPEC §19.
