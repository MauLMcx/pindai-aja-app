-- Tes RPC sinkron (SPEC §8).
--
-- Yang diuji:
--   * S2 idempotensi: op_id yang sama tidak diterapkan dua kali.
--   * Isolasi toko: klien tidak boleh menulis/membaca data toko lain.
--   * Barcode ganda ditolak (tidak menimpa baris lama).
--   * Tabel ledger append-only menolak update/delete.
--   * Tabel di luar daftar sinkron ditolak.
--   * `applied_ops` tidak bisa dibaca langsung oleh pengguna login.
--   * Anon tidak boleh memanggil RPC sinkron.
--
-- Prasyarat pada proyek Supabase DEV: dua pengguna Auth dan dua toko uji
-- seperti pada `rls_test.sql`, masing-masing toko punya minimal satu produk.
--
-- Jalankan (contoh):
--   psql "$DATABASE_URL" \
--     -v user_a='...' -v user_b='...' \
--     -v store_a='...' -v store_b='...' \
--     -v product_a='...' -v product_b='...' \
--     -f supabase/tests/sync_test.sql
--
-- Skrip ini hanya menulis di dalam transaksi dan diakhiri ROLLBACK.

\set ON_ERROR_STOP on

begin;

select set_config('test.user_a', :'user_a', true);
select set_config('test.user_b', :'user_b', true);
select set_config('test.store_a', :'store_a', true);
select set_config('test.store_b', :'store_b', true);
select set_config('test.product_a', :'product_a', true);
select set_config('test.product_b', :'product_b', true);

-- ======================================================= sebagai pengguna A
set local role authenticated;
select set_config(
  'request.jwt.claims',
  json_build_object('sub', current_setting('test.user_a'))::text,
  true
);

do $$
declare
  store_a uuid := current_setting('test.store_a')::uuid;
  store_b uuid := current_setting('test.store_b')::uuid;
  product_a uuid := current_setting('test.product_a')::uuid;
  move_id uuid;
  v_new_product constant uuid := '44444444-4444-4444-4444-444444444444';
  v_unit_1 constant uuid := '55555555-5555-5555-5555-555555555551';
  v_unit_2 constant uuid := '55555555-5555-5555-5555-555555555552';
  v_other_product constant uuid := '44444444-4444-4444-4444-444444444445';
  v_batch_product_1 constant uuid := '44444444-4444-4444-4444-444444444446';
  v_batch_product_2 constant uuid := '44444444-4444-4444-4444-444444444447';
  v_op_product constant uuid := '66666666-6666-6666-6666-666666666661';
  v_op_product_again constant uuid := '66666666-6666-6666-6666-666666666661';
  v_op_unit_1 constant uuid := '66666666-6666-6666-6666-666666666662';
  v_op_unit_dup constant uuid := '66666666-6666-6666-6666-666666666663';
  v_op_other_store constant uuid := '66666666-6666-6666-6666-666666666664';
  v_op_ledger constant uuid := '66666666-6666-6666-6666-666666666665';
  v_op_profiles constant uuid := '66666666-6666-6666-6666-666666666666';
  v_op_delete_ledger constant uuid := '66666666-6666-6666-6666-666666666667';
  v_op_product_update constant uuid := '66666666-6666-6666-6666-666666666668';
  v_op_batch_1 constant uuid := '77777777-7777-7777-7777-777777777771';
  v_op_batch_2 constant uuid := '77777777-7777-7777-7777-777777777772';
  r jsonb;
  n integer;
  pulled_name text;
begin
  -- 1) Insert produk baru lewat push -> applied.
  r := public.sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op_product,
    'table', 'products',
    'row_id', v_new_product,
    'op', 'insert',
    'payload', jsonb_build_object(
      'id', v_new_product,
      'store_id', store_a,
      'name', 'Produk Sinkron Uji',
      'base_unit', 'pcs'))));

  if not (jsonb_array_length(r) = 1 and r -> 0 ->> 'status' = 'applied') then
    raise exception 'insert produk lewat sync_push gagal: %', r;
  end if;

  -- 2) S2 idempotensi: op_id sama dikirim ulang -> skipped, tidak dobel.
  r := public.sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op_product_again,
    'table', 'products',
    'row_id', v_new_product,
    'op', 'insert',
    'payload', jsonb_build_object(
      'id', v_new_product,
      'store_id', store_a,
      'name', 'Produk Sinkron Uji',
      'base_unit', 'pcs'))));

  if not (jsonb_array_length(r) = 1 and r -> 0 ->> 'status' = 'skipped') then
    raise exception 'op ganda seharusnya skipped: %', r;
  end if;

  select count(*) into n from products where id = v_new_product;
  if n <> 1 then
    raise exception 'idempotensi gagal: produk yang sama muncul % kali', n;
  end if;

  -- 3) Update baris yang sama -> applied dan nilainya berubah.
  r := public.sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op_product_update,
    'table', 'products',
    'row_id', v_new_product,
    'op', 'update',
    'payload', jsonb_build_object(
      'id', v_new_product,
      'store_id', store_a,
      'name', 'Produk Sinkron Uji v2'))));

  if not (jsonb_array_length(r) = 1 and r -> 0 ->> 'status' = 'applied') then
    raise exception 'update produk lewat sync_push gagal: %', r;
  end if;

  select name into pulled_name from products where id = v_new_product;
  if pulled_name <> 'Produk Sinkron Uji v2' then
    raise exception 'update tidak tersimpan, nama = %', pulled_name;
  end if;

  -- 4) Menulis ke toko lain -> error, bukan diam-diam masuk.
  r := public.sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op_other_store,
    'table', 'products',
    'row_id', v_other_product,
    'op', 'insert',
    'payload', jsonb_build_object(
      'id', v_other_product,
      'store_id', store_b,
      'name', 'Produk Toko Lain',
      'base_unit', 'pcs'))));

  if not (jsonb_array_length(r) = 1 and r -> 0 ->> 'status' = 'error') then
    raise exception 'penulisan ke toko lain seharusnya ditolak: %', r;
  end if;

  select count(*) into n from products where id = v_other_product;
  if n <> 0 then
    raise exception 'data toko lain berhasil ditulis lewat sync_push';
  end if;

  -- 4b) Satu op rusak tidak boleh membatalkan op lain di batch yang sama.
  r := public.sync_push(jsonb_build_array(
    jsonb_build_object(
      'op_id', v_op_batch_1,
      'table', 'products',
      'row_id', v_batch_product_1,
      'op', 'insert',
      'payload', jsonb_build_object(
        'id', v_batch_product_1,
        'store_id', store_a,
        'name', 'Produk Batch 1',
        'base_unit', 'pcs')),
    jsonb_build_object(
      'op_id', 'bukan-uuid',
      'table', 'products',
      'row_id', v_batch_product_2,
      'op', 'insert',
      'payload', jsonb_build_object(
        'id', v_batch_product_2,
        'store_id', store_a,
        'name', 'Produk Batch 2',
        'base_unit', 'pcs')),
    jsonb_build_object(
      'op_id', v_op_batch_2,
      'table', 'products',
      'row_id', v_batch_product_2,
      'op', 'insert',
      'payload', jsonb_build_object(
        'id', v_batch_product_2,
        'store_id', store_a,
        'name', 'Produk Batch 2',
        'base_unit', 'pcs'))));

  if jsonb_array_length(r) <> 3
     or r -> 0 ->> 'status' <> 'applied'
     or r -> 1 ->> 'status' <> 'error'
     or r -> 2 ->> 'status' <> 'applied' then
    raise exception 'op rusak membatalkan batch: %', r;
  end if;

  select count(*) into n
    from products
   where id in (v_batch_product_1, v_batch_product_2);
  if n <> 2 then
    raise exception 'op sah di batch tidak tersimpan (% dari 2)', n;
  end if;

  -- 5) Barcode ganda ditolak, baris lama tidak tertimpa.
  r := public.sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op_unit_1,
    'table', 'product_units',
    'row_id', v_unit_1,
    'op', 'insert',
    'payload', jsonb_build_object(
      'id', v_unit_1,
      'store_id', store_a,
      'product_id', product_a,
      'unit_name', 'pcs',
      'factor_to_base', 1,
      'barcode', '8990000000001',
      'barcode_source', 'factory'))));

  if not (jsonb_array_length(r) = 1 and r -> 0 ->> 'status' = 'applied') then
    raise exception 'insert product_units pertama gagal: %', r;
  end if;

  r := public.sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op_unit_dup,
    'table', 'product_units',
    'row_id', v_unit_2,
    'op', 'insert',
    'payload', jsonb_build_object(
      'id', v_unit_2,
      'store_id', store_a,
      'product_id', product_a,
      'unit_name', 'pcs',
      'factor_to_base', 1,
      'barcode', '8990000000001',
      'barcode_source', 'factory'))));

  if not (jsonb_array_length(r) = 1 and r -> 0 ->> 'status' = 'error') then
    raise exception 'barcode ganda seharusnya ditolak: %', r;
  end if;

  select count(*) into n from product_units where id = v_unit_2;
  if n <> 0 then
    raise exception 'barcode ganda menimpa/menambah baris tanpa izin';
  end if;

  -- 6) Tabel ledger append-only menolak update dan delete.
  select id into move_id
    from stock_movements
   where store_id = store_a
   order by occurred_at
   limit 1;

  if move_id is null then
    raise notice 'lewati tes ledger: stock_movements toko A kosong';
  else
    r := public.sync_push(jsonb_build_array(jsonb_build_object(
      'op_id', v_op_ledger,
      'table', 'stock_movements',
      'row_id', move_id,
      'op', 'update',
      'payload', jsonb_build_object(
        'id', move_id,
        'store_id', store_a,
        'note', 'diubah lewat sync'))));

    if not (jsonb_array_length(r) = 1
            and r -> 0 ->> 'status' = 'error'
            and r -> 0 ->> 'error' like '%append-only%') then
      raise exception 'update ledger seharusnya ditolak append-only: %', r;
    end if;

    r := public.sync_push(jsonb_build_array(jsonb_build_object(
      'op_id', v_op_delete_ledger,
      'table', 'stock_movements',
      'row_id', move_id,
      'op', 'delete',
      'payload', jsonb_build_object(
        'id', move_id,
        'store_id', store_a))));

    if not (jsonb_array_length(r) = 1
            and r -> 0 ->> 'status' = 'error'
            and r -> 0 ->> 'error' like '%append-only%') then
      raise exception 'delete ledger seharusnya ditolak append-only: %', r;
    end if;
  end if;

  -- 7) Tabel di luar daftar sinkron ditolak.
  r := public.sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op_profiles,
    'table', 'profiles',
    'row_id', current_setting('test.user_a')::uuid,
    'op', 'update',
    'payload', jsonb_build_object('user_id', current_setting('test.user_a')))));

  if not (jsonb_array_length(r) = 1 and r -> 0 ->> 'status' = 'error') then
    raise exception 'tabel profiles seharusnya tidak boleh disinkronkan: %', r;
  end if;

  -- 8) Pull hanya mengembalikan data toko sendiri.
  select count(*) into n
    from public.sync_pull('products', 0, 1000) e
   where (e ->> 'store_id')::uuid <> store_a;
  if n <> 0 then
    raise exception 'sync_pull membocorkan % produk toko lain', n;
  end if;

  select count(*) into n
    from public.sync_pull('products', 0, 1000) e
   where (e ->> 'id')::uuid = v_new_product;
  if n <> 1 then
    raise exception 'sync_pull tidak mengembalikan produk yang baru dipush';
  end if;

  -- 9) Pull tabel di luar daftar ditolak.
  begin
    perform public.sync_pull('profiles', 0, 10);
    raise exception 'sync_pull(profiles) seharusnya ditolak';
  exception
    when others then
      if sqlerrm not like '%tidak diizinkan%' then
        raise;
      end if;
  end;

  -- 10) applied_ops tidak boleh dibaca langsung oleh pengguna login.
  begin
    perform count(*) from public.applied_ops;
    raise exception 'authenticated seharusnya tidak bisa membaca applied_ops';
  exception
    when insufficient_privilege then
      null;
  end;
end;
$$;

-- ============================================================ sebagai anon
reset role;
set local role anon;
select set_config('request.jwt.claims', '', true);

do $$
begin
  begin
    perform public.sync_push('[]'::jsonb);
    raise exception 'anon seharusnya tidak boleh memanggil sync_push';
  exception
    when insufficient_privilege then
      null;
  end;

  begin
    perform count(*) from public.sync_pull('products', 0, 10);
    raise exception 'anon seharusnya tidak boleh memanggil sync_pull';
  exception
    when insufficient_privilege then
      null;
  end;
end;
$$;

reset role;

select 'SYNC_TEST_OK' as result;

rollback;
