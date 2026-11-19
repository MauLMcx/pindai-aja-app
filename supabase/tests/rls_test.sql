-- Tes isolasi RLS (SPEC §7: setiap tabel wajib RLS + tes).
--
-- Prasyarat pada proyek Supabase DEV:
--   * Dua pengguna Auth sungguhan (user_a, user_b) dari dua toko berbeda.
--   * Masing-masing toko punya minimal satu baris `products`.
--   * Data lain boleh kosong.
--
-- Jalankan (contoh):
--   psql "$DATABASE_URL" \
--     -v user_a='11111111-1111-1111-1111-111111111111' \
--     -v user_b='22222222-2222-2222-2222-222222222222' \
--     -v store_a='aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' \
--     -v store_b='bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' \
--     -f supabase/tests/rls_test.sql
--
-- Skrip ini hanya membaca (kecuali percobaan UPDATE yang harus gagal) dan
-- diakhiri ROLLBACK.

\set ON_ERROR_STOP on

begin;

select set_config('test.user_a', :'user_a', true);
select set_config('test.user_b', :'user_b', true);
select set_config('test.store_a', :'store_a', true);
select set_config('test.store_b', :'store_b', true);

-- 1) Setiap tabel yang punya kolom store_id wajib mengaktifkan RLS.
do $$
declare
  r record;
begin
  for r in
    select c.relname as table_name
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind = 'r'
      and exists (
        select 1
        from information_schema.columns col
        where col.table_schema = 'public'
          and col.table_name = c.relname
          and col.column_name = 'store_id'
      )
      and not c.relrowsecurity
  loop
    raise exception 'RLS tidak aktif pada tabel %', r.table_name;
  end loop;
end;
$$;

-- 2) Pengguna toko A tidak boleh melihat data toko B.
set local role authenticated;
select set_config(
  'request.jwt.claims',
  json_build_object('sub', current_setting('test.user_a'))::text,
  true
);

do $$
declare
  n integer;
  store_a uuid := current_setting('test.store_a')::uuid;
  store_b uuid := current_setting('test.store_b')::uuid;
begin
  select count(*) into n from products where store_id = store_b;
  if n <> 0 then
    raise exception 'isolasi gagal: user A melihat % produk toko B', n;
  end if;

  select count(*) into n from products where store_id = store_a;
  if n = 0 then
    raise exception 'user A tidak bisa melihat produk tokonya sendiri';
  end if;
end;
$$;

reset role;

-- 3) Anon tanpa login tidak boleh melihat data apa pun.
set local role anon;
select set_config('request.jwt.claims', '', true);

do $$
declare
  n integer;
begin
  select count(*) into n from products;
  if n <> 0 then
    raise exception 'anon dapat membaca % baris products', n;
  end if;
end;
$$;

reset role;

-- 4) Tabel ledger menolak UPDATE (append-only).
do $$
declare
  target_id uuid;
begin
  select id into target_id from stock_movements limit 1;
  if target_id is null then
    raise notice 'lewati tes append-only: stock_movements kosong';
    return;
  end if;

  begin
    update stock_movements set note = note where id = target_id;
    raise exception 'UPDATE pada stock_movements seharusnya ditolak';
  exception
    when others then
      if sqlerrm not like '%append-only%' then
        raise;
      end if;
  end;
end;
$$;

-- 5) Anon tidak boleh memanggil fungsi sinkron.
set local role anon;
select set_config('request.jwt.claims', '', true);

do $$
begin
  begin
    perform sync_push('[]'::jsonb);
    raise exception 'anon seharusnya tidak bisa memanggil sync_push';
  exception
    when insufficient_privilege then null;
    when others then
      if sqlerrm like '%seharusnya%' then
        raise;
      end if;
  end;

  begin
    perform sync_pull('products', 0, 10);
    raise exception 'anon seharusnya tidak bisa memanggil sync_pull';
  exception
    when insufficient_privilege then null;
    when others then
      if sqlerrm like '%seharusnya%' then
        raise;
      end if;
  end;
end;
$$;

reset role;

-- 6) Push yang sama dua kali bersifat idempoten (SPEC P8/S2).
set local role authenticated;
select set_config(
  'request.jwt.claims',
  json_build_object('sub', current_setting('test.user_a'))::text,
  true
);

do $$
declare
  v_store uuid := current_setting('test.store_a')::uuid;
  v_op uuid := gen_random_uuid();
  v_product uuid := gen_random_uuid();
  v_result jsonb;
  n integer;
begin
  v_result := sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op,
    'table', 'products',
    'row_id', v_product,
    'op', 'insert',
    'payload', jsonb_build_object(
      'id', v_product,
      'store_id', v_store,
      'name', 'Produk Uji Sinkron',
      'base_unit', 'pcs',
      'created_at', now(),
      'updated_at', now()
    )
  )));

  if v_result -> 0 ->> 'status' <> 'applied' then
    raise exception 'push pertama gagal: %', v_result;
  end if;

  v_result := sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', v_op,
    'table', 'products',
    'row_id', v_product,
    'op', 'insert',
    'payload', '{}'::jsonb
  )));

  if v_result -> 0 ->> 'status' <> 'duplicate' then
    raise exception 'push kedua seharusnya duplicate: %', v_result;
  end if;

  select count(*) into n from products
   where id = v_product and store_id = v_store;
  if n <> 1 then
    raise exception 'push idempoten menghasilkan % baris (harus 1)', n;
  end if;

  -- Payload toko lain harus ditolak.
  v_result := sync_push(jsonb_build_array(jsonb_build_object(
    'op_id', gen_random_uuid(),
    'table', 'products',
    'row_id', gen_random_uuid(),
    'op', 'insert',
    'payload', jsonb_build_object(
      'id', gen_random_uuid(),
      'store_id', current_setting('test.store_b')::uuid,
      'name', 'Produk Toko Lain',
      'base_unit', 'pcs',
      'created_at', now(),
      'updated_at', now()
    )
  )));

  if v_result -> 0 ->> 'status' <> 'error' then
    raise exception 'push lintas toko seharusnya error: %', v_result;
  end if;
end;
$$;

reset role;

rollback;
