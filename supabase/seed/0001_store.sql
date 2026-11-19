-- Seed toko untuk Tahap 3 (jalankan SEKALI di proyek Supabase DEV).
--
-- Langkah:
--   1. Buat pengguna lewat Dashboard > Authentication > Add user
--      (email + password, centang "Auto Confirm User").
--   2. Ganti 'ganti@email.com' di bawah dengan email pengguna itu.
--   3. Jalankan file ini di SQL Editor.
--   4. Ulangi insert profiles untuk pengguna lain (staf) dengan role 'staff'.
--
-- ID toko sengaja memakai UUID deterministik yang sama dengan
-- `stableId('store', 'utama')` di aplikasi. Jadi data yang sudah diimpor
-- sebelum login tetap menjadi milik toko yang sama setelah sinkron pertama
-- (lihat SPEC §19, 2026-11-17).
--
-- Jangan pernah memakai service_role key di aplikasi. File ini dijalankan
-- manual oleh pemilik di dashboard, bukan dari app.

insert into stores (id, name, code2)
values ('5807696d-3bd5-568a-bb71-28efce36114b', 'Toko Utama', '01')
on conflict (id) do update
  set name = excluded.name,
      code2 = excluded.code2;

-- Pemilik toko.
insert into profiles (user_id, store_id, role, display_name)
select id,
       '5807696d-3bd5-568a-bb71-28efce36114b'::uuid,
       'owner',
       coalesce(nullif(raw_user_meta_data ->> 'display_name', ''), email)
  from auth.users
 where email = 'ganti@email.com'
on conflict (user_id) do update
  set store_id = excluded.store_id,
      role = excluded.role,
      display_name = excluded.display_name;

-- Contoh staf (buka komentar dan ganti emailnya bila dibutuhkan).
-- insert into profiles (user_id, store_id, role, display_name)
-- select id,
--        '5807696d-3bd5-568a-bb71-28efce36114b'::uuid,
--        'staff',
--        coalesce(nullif(raw_user_meta_data ->> 'display_name', ''), email)
--   from auth.users
--  where email = 'staf@email.com'
-- on conflict (user_id) do update
--   set store_id = excluded.store_id,
--       role = excluded.role,
--       display_name = excluded.display_name;
