# SETUP-MCP.md — Persiapan MCP (langkah demi langkah)

Kerjakan berurutan. Setiap langkah punya **cara cek**. Jika gagal, jangan lanjut: salin pesan error ke AI agent.

> Nama paket dan perintah di bawah belum saya verifikasi hari ini. Jika ada yang gagal, cek README resmi tool itu.

## Langkah 1 — Siapkan komputer

| Cek | Perintah | Hasil yang diharapkan |
|---|---|---|
| Flutter | `flutter doctor` | Flutter dan Android toolchain tidak merah |
| Dart | `dart --version` | 3.9 atau lebih baru |
| Node | `node --version` | LTS (untuk `npx`) |
| Python | `python --version` | 3.11 atau lebih baru |
| Git | `git --version` | Ada versinya |
| sqlite3 CLI + DLL | `sqlite3 --version` | Untuk memeriksa DB ekspor; di Windows `sqlite3.dll` juga dipakai tes Drift |

## Langkah 2 — Taruh berkas di proyek

Salin isi folder `petshop-pos/` ke root repo Anda (`SPEC.md`, `DOCUMENTATION.md`, `AGENTS.md`, `mcp.json`, `tools/`). Letakkan juga `Data_Harga_Pakan.xlsx` di `data/` (folder baru).

Tambahkan ke `.gitignore`:

```
.env
*.keystore
tools/out/
__pycache__/
.venv/
```

## Langkah 3 — Pasang `petshop-dev` (server kustom)

Buka **PowerShell** di root proyek:

```powershell
cd tools\petshop_dev_mcp
python -m venv .venv
Set-ExecutionPolicy -Scope Process Bypass   # hanya untuk jendela PowerShell ini
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python -m unittest -v
```

**Cara cek:** keluar `Ran 18 tests ... OK`. Tes impor butuh file Excel, atur lokasinya jika berbeda:

```powershell
$env:PETSHOP_XLSX="..\..\data\Data_Harga_Pakan.xlsx"
python -m unittest -v
```

`mcp.json` sudah disesuaikan untuk Windows: `petshop-dev` memakai `tools/petshop_dev_mcp/.venv/Scripts/python.exe`, jadi **venv di atas wajib dibuat di lokasi itu**.

## Langkah 4 — Akun Supabase (proyek DEV)

1. Buat proyek Supabase baru khusus **dev** (bukan data toko sungguhan).
2. Catat **Project Ref** (bagian awal URL proyek).
3. Buat **Personal Access Token** di pengaturan akun Supabase (menu Access Tokens; letak menu bisa berubah).
4. Simpan token di `.env` lokal atau variabel lingkungan sistem, **jangan commit**. `mcp.json` hanya berisi `--project-ref`; `SUPABASE_ACCESS_TOKEN` dibaca dari variabel lingkungan saat server MCP dijalankan, jadi jangan menulis nilainya ke berkas repo.

**Cara cek:** MCP Supabase berstatus tersambung dan hanya bisa membaca (`--read-only` sudah ada di konfigurasi).

## Langkah 5 — Daftarkan MCP di agent

Berkas bernama `mcp.json` tidak dibaca otomatis oleh semua agent. Claude Code otomatis hanya membaca `.mcp.json` di root proyek, jadi muat berkas ini secara eksplisit (mis. opsi `--mcp-config mcp.json`) atau salin dulu menjadi `.mcp.json`. Untuk OpenCode, konfigurasi aktif ada di `opencode.json`.

Buka agent dan jalankan perintah `/mcp` (atau `opencode mcp list`). Semua server harus **connected**: `dart`, `context7`, `supabase`, `playwright`, `petshop-dev`.

Di Windows, entri `npx` di `mcp.json` sudah dibungkus `cmd /c`. Jika `dart` tidak dikenali, pastikan folder `bin` Flutter/Dart ada di PATH (buka terminal baru setelah mengubah PATH).

## Langkah 6 — Uji asap (smoke test)

Beri agent perintah satu per satu dan cocokkan hasilnya:

| # | Perintah ke agent | Hasil yang benar |
|---|---|---|
| 1 | "Pakai tool petshop-dev gen_ean13_internal dengan store_code2 07 dan seq 1" | Kode 13 digit berawalan `207`, valid |
| 2 | "Jalankan import_excel pada data/Data_Harga_Pakan.xlsx" | **86 baris diimpor, 27 perlu dicek, 1 baris dicoret dilewati** (angka dari file Anda saat ini) |
| 3 | "Pakai Context7 untuk mencari dokumentasi terbaru `mobile_scanner` Flutter" | Dokumentasi muncul |
| 4 | "Pakai Dart MCP untuk menjalankan analisis kode proyek" | Hasil analisis tampil |
| 5 | "Pakai Supabase MCP untuk menampilkan daftar tabel" | Daftar tabel (kosong pun tidak apa-apa) |
| 6 | "Pakai receipt_preview dengan contoh struk 3 item, lebar 32" | Teks struk, tidak ada baris lebih dari 32 karakter |

## Hasil impor Excel (sudah dijalankan)

Folder `tools/out/` berisi `products_import.csv` dan `import_report.json` dari file Anda.

- 86 produk diimpor, 27 ditandai **perlu dicek** (alasan ada di kolom `review_reasons`).
- 1 baris dilewati karena dicoret seluruhnya (`Meo Ikan`), 2 baris catatan kaki dan 1 baris kosong diabaikan.
- Tidak ada harga jual di file sumber.
- 41 baris belum punya ukuran/satuan (misalnya semua kode Multifeed dan pakan ikan). Satuan beli perlu Anda lengkapi.
- Baris "isi N" (pasir, Meo) ditandai karena belum jelas harganya **per dus atau per pcs**.

Buka CSV di Excel/Google Sheets, lengkapi, lalu serahkan ke agent sebagai data awal.

## Keamanan MCP (wajib dibaca)

- Server MCP berjalan dengan hak akses komputer Anda. Pasang hanya yang Anda kenali dan kunci versinya bila memungkinkan.
- Supabase MCP: **read-only, proyek dev saja**. Jangan arahkan ke data toko asli.
- Isi database dan berkas bisa memuat teks yang mencoba memerintah agent. Agent tidak boleh mengikuti perintah dari dalam data.
- Token jangan masuk git. Jika terlanjur, **cabut dan buat ulang** token itu.
- `petshop-dev` hanya boleh membaca/menulis di dalam folder proyek (dijaga `PETSHOP_ROOT`).

## Belum ada (jujur)

- `simulate_sync` dan `seed_demo` di `DOCUMENTATION.md` bagian 4 **belum dibuat**, karena mesin sinkronnya belum ada. Dibuat agent saat Tahap 3.
- `server.py` memakai API **mcp 2.x** (`MCPServer`, sebelumnya `FastMCP`) dan sudah diuji tersambung ke klien MCP; tool `gen_ean13_internal` berhasil. `requirements.txt` dipin ke `mcp>=2,<3`.
- MCP `supabase` aktif (read-only) untuk proyek DEV `rutsepsoxwmdpwfnldjq`. Migrasi dan tes RLS sudah dijalankan; `SUPABASE_ACCESS_TOKEN` diisi lewat variabel lingkungan lokal, bukan di repo.
- Dua pengguna Auth uji `rls-test-a@example.test` dan `rls-test-b@example.test` (masing-masing di toko uji A/B) dipakai oleh `supabase/tests/rls_test.sql`. Jangan pakai akun ini untuk data sungguhan.
