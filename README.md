# pindai-aja-app

Aplikasi kasir dan stok petshop (Flutter + Drift/SQLite + Supabase). Dirancang
**offline-first**: kasir tetap jalan tanpa internet, lalu data disinkronkan saat
jaringan tersedia.

Dokumen utama:

- `SPEC.md` — sumber kebenaran fitur, peran, model data, dan skenario uji.
- `DOCUMENTATION.md` — cara kerja tools, impor Excel, login/sinkron/backup.
- `AGENTS.md` — aturan kerja untuk AI agent.

## Menjalankan

```powershell
flutter pub get
flutter run
```

Tanpa konfigurasi Supabase, app berjalan dalam mode lokal. Untuk mengaktifkan
login dan sinkron:

```powershell
flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co `
            --dart-define=SUPABASE_ANON_KEY=eyJ...
```

Hanya `anon key` yang boleh dipakai di app. Jangan pernah memakai
`service_role` di aplikasi atau menyimpan rahasia di repo.

## Pemeriksaan

```powershell
dart format .
flutter analyze
flutter test
```

Printer Bluetooth dan kamera hanya bisa diuji manual di perangkat nyata; jangan
mengklaim sudah diuji lewat tes otomatis.
