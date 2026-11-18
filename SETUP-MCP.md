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
4. Simpan token di `.env` lokal, **jangan commit**. Isi `PROJECT_REF_DEV` dan `SUPABASE_ACCESS_TOKEN` di `mcp.json` (atau lewat variabel lingkungan sistem).

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
- MCP `supabase` sengaja dinonaktifkan sampai Project Ref proyek DEV dan `SUPABASE_ACCESS_TOKEN` diisi.

## 10. Status konfigurasi OpenCode (2026-11-18)

OpenCode memakai `opencode.json` di root proyek. Berkas `mcp.json` tetap dipakai untuk agent lain (misalnya Claude Code) dan tidak dibaca otomatis oleh OpenCode. Perubahan `opencode.json` langsung dimuat ulang, tidak perlu restart.

| Server | Status | Catatan |
|---|---|---|
| `context7` | connected | Remote `https://mcp.context7.com/mcp`. |
| `playwright` | connected | Lokal via `cmd /c npx -y @playwright/mcp@latest`. |
| `petshop-dev` | connected | Venv dibuat di `tools/petshop_dev_mcp/.venv`; `mcp 2.3.0` + `openpyxl 3.1.5`. Tes: `Ran 18 tests ... OK (skipped=8)`. Delapan tes impor diskip karena `data/Data_Harga_Pakan.xlsx` belum ada di repo (folder `data/` memang di-ignore). |
| `dart` | connected | Flutter 3.50.0 + Dart 3.14.0 terpasang di `C:\Users\MyBook Hype\flutter`. `dart.exe` dipanggil langsung dari `bin\cache\dart-sdk\bin\dart.exe`, dengan `timeout.startup = 120000` (handshake awal lebih lama dari default 30 detik). `flutter\bin` juga ditambahkan ke PATH user. |
| `supabase` | disabled | Perlu env var `SUPABASE_PROJECT_REF_DEV` dan `SUPABASE_ACCESS_TOKEN`. Token tidak boleh ditulis ke repo. |

Smoke test `petshop-dev`: `gen_ean13_internal("07", 1)` menghasilkan `2070000000018`; `receipt_preview` lebar 32 menghasilkan semua baris ≤ 32 karakter.

Smoke test `dart`: tool `analyze_files` berhasil dijalankan terhadap root proyek. Diagnostic yang muncul (`uri_does_not_exist` untuk `package:drift/...`, `package:flutter_lints/...`, dst.) berasal dari dependensi yang belum diunduh — jalankan `flutter pub get` sebelum mengharapkan `dart analyze` bersih. Ini bukan masalah koneksi MCP.

## 11. Android SDK (2026-11-18)

Dipakai **command-line tools saja**, tanpa Android Studio. Lokasi: `C:\Android\Sdk` (path tanpa spasi supaya aman untuk Gradle/NDK).

| Komponen | Versi | Catatan |
|---|---|---|
| `cmdline-tools` | 23.0.0 (`latest`) | Berisi `sdkmanager`. Sejak versi ini `sdkmanager` hanya pembungkus **Android CLI** dan mencetak peringatan deprecated. |
| `platform-tools` | 37.0.1 | Menyediakan `adb`. |
| `platforms` | android-36, android-35 | Flutter 3.50 memakai compileSdk 36; android-35 ikut terpasang otomatis oleh plugin Gradle. |
| `build-tools` | 36.0.0, 36.1.0 | |
| `ndk` | 28.2.13676358 | Sesuai `flutter.ndkVersion`. **Wajib dipasang manual** — lihat catatan di bawah. |
| `cmake` | 3.22.1 | Terpasang otomatis saat build pertama. |

Variabel lingkungan (level User):

```
ANDROID_HOME=C:\Android\Sdk
ANDROID_SDK_ROOT=C:\Android\Sdk
Path += C:\Android\Sdk\platform-tools;C:\Android\Sdk\cmdline-tools\latest\bin;C:\Users\MyBook Hype\flutter\bin
```

Selain itu: `flutter config --android-sdk C:\Android\Sdk` dan `flutter config --jdk-dir "C:\Program Files\Java\jdk-21"`.
`android/local.properties` (di-ignore git) sudah memuat `sdk.dir=C:\\Android\\Sdk`.

**Cara cek:**

```powershell
flutter doctor          # Android toolchain harus [√]
adb version
flutter build apk --debug
```

Hasil 2026-11-18: `flutter doctor` menunjukkan `[√] Android toolchain ... build-tools 36.1.0`, dan `flutter build apk --debug` berhasil menghasilkan `build\app\outputs\flutter-apk\app-debug.apk` (170 MB, debug).

**Catatan penting — sintaks paket berubah.** `sdkmanager` versi baru memakai garis miring, bukan titik koma:

```powershell
sdkmanager "platforms/android-36" "build-tools/36.1.0" "ndk/28.2.13676358"   # benar
sdkmanager "platforms;android-36"                                            # gagal: "Package platforms not found"
```

Karena itu build pertama gagal dengan `Android sdkmanager did not install NDK 28.2.13676358` — plugin Gradle masih memanggil sintaks lama. Solusinya memasang NDK manual dengan sintaks baru di atas. `--licenses` juga tidak diperlukan lagi (Android CLI menerima lisensi otomatis), tetapi Flutter tetap melaporkan "All Android licenses accepted".

Belum dipasang: `emulator` + system image, dan belum ada perangkat Android fisik tersambung. Untuk uji kamera dan printer Bluetooth nanti tetap perlu HP sungguhan (`flutter devices` harus menampilkan perangkat Android).

Cara mengaktifkan Supabase nanti:

1. Set env var `SUPABASE_PROJECT_REF_DEV` (project ref proyek **DEV**) dan `SUPABASE_ACCESS_TOKEN` (Personal Access Token Supabase) di lingkungan yang menjalankan OpenCode. Jangan taruh token di `opencode.json` maupun git.
2. Hapus `"disabled": true` dari entri `supabase` di `opencode.json` (argumen sudah memakai `{env:SUPABASE_PROJECT_REF_DEV}` dan environment sudah memakai `{env:SUPABASE_ACCESS_TOKEN}`).
3. Jalankan `opencode mcp list`; status harus `connected` dan flag `--read-only` tetap ada.
