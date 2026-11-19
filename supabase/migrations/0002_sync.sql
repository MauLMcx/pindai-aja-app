-- SPEC Tahap 3 — sinkron multi-perangkat.
--
-- Berisi:
--   * applied_ops  : penanda operasi yang sudah diterima server (idempoten, SPEC P8).
--   * sync_push    : menerapkan operasi dari outbox klien satu per satu.
--   * sync_pull    : mengambil baris baru berdasarkan server_seq.
--
-- Semua fungsi memakai security definer agar bisa menulis ke tabel yang
-- dilindungi RLS, tetapi WAJIB memeriksa store milik pengguna sendiri.

-- ================================================== penanda operasi idempoten

create table applied_ops (
  op_id uuid primary key,
  store_id uuid not null,
  applied_at timestamptz not null default now()
);

alter table applied_ops enable row level security;

create policy applied_ops_isolation on applied_ops
  for all using (store_id = current_store_id())
  with check (store_id = current_store_id());

create index applied_ops_store_idx on applied_ops (store_id, applied_at);

-- ============================================================== push
-- p_ops: [{"op_id":uuid, "table":text, "row_id":uuid, "op":text, "payload":{...}}]
--
-- Setiap operasi diterapkan dalam transaksi sendiri (blok exception), jadi satu
-- baris gagal tidak membatalkan baris lain. Hasilnya array:
--   {"op_id":..., "status":"applied"|"duplicate"|"error", "error":..., "code":...}

create or replace function sync_push(p_ops jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_store uuid := current_store_id();
  v_op jsonb;
  v_op_id uuid;
  v_table text;
  v_payload jsonb;
  v_inserted uuid;
  v_result jsonb := '[]'::jsonb;
  v_error text;
  v_code text;
begin
  if auth.uid() is null then
    raise exception 'login diperlukan' using errcode = '42501';
  end if;
  if v_store is null then
    raise exception 'akun belum terhubung ke toko' using errcode = '42501';
  end if;
  if p_ops is null or jsonb_typeof(p_ops) <> 'array' then
    raise exception 'p_ops harus berupa array JSON';
  end if;

  for v_op in select * from jsonb_array_elements(p_ops)
  loop
    v_op_id := (v_op ->> 'op_id')::uuid;
    v_table := v_op ->> 'table';
    v_payload := v_op -> 'payload';
    v_inserted := null;

    -- Klaim op_id lebih dulu. Bila sudah ada, operasi ini pernah diterima.
    insert into applied_ops (op_id, store_id)
    values (v_op_id, v_store)
    on conflict (op_id) do nothing
    returning op_id into v_inserted;

    if v_inserted is null then
      v_result := v_result || jsonb_build_object(
        'op_id', v_op_id,
        'status', 'duplicate'
      );
      continue;
    end if;

    begin
      -- Kolom waktu wajib: lengkapi bila klien lama tidak mengirimnya.
      -- (jsonb_populate_record memakai NULL untuk kolom yang tidak ada.)
      if (v_payload ? 'created_at') is false then
        v_payload := jsonb_set(v_payload, '{created_at}', to_jsonb(now()));
      end if;
      if (v_payload ? 'updated_at') is false then
        v_payload := jsonb_set(v_payload, '{updated_at}', to_jsonb(now()));
      end if;

      -- Tolak data milik toko lain.
      if v_table = 'stores' then
        if (v_payload ->> 'id')::uuid <> v_store then
          raise exception 'toko tidak cocok dengan akun';
        end if;
      elsif v_table is null then
        raise exception 'nama tabel kosong';
      else
        if (v_payload ->> 'store_id')::uuid <> v_store then
          raise exception 'data bukan milik toko akun ini';
        end if;
      end if;

      case v_table
        -- ---------------------------------------------------------- master
        when 'stores' then
          insert into stores
          select * from jsonb_populate_record(null::stores, v_payload)
          on conflict (id) do update set
            name = excluded.name,
            code2 = excluded.code2,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= stores.updated_at;

        when 'devices' then
          insert into devices
          select * from jsonb_populate_record(null::devices, v_payload)
          on conflict (id) do update set
            code = excluded.code,
            name = excluded.name,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= devices.updated_at;

        when 'suppliers' then
          insert into suppliers
          select * from jsonb_populate_record(null::suppliers, v_payload)
          on conflict (id) do update set
            name = excluded.name,
            phone = excluded.phone,
            note = excluded.note,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= suppliers.updated_at;

        when 'categories' then
          insert into categories
          select * from jsonb_populate_record(null::categories, v_payload)
          on conflict (id) do update set
            name = excluded.name,
            default_margin_pct = excluded.default_margin_pct,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= categories.updated_at;

        when 'products' then
          insert into products
          select * from jsonb_populate_record(null::products, v_payload)
          on conflict (id) do update set
            name = excluded.name,
            brand = excluded.brand,
            variant = excluded.variant,
            category_id = excluded.category_id,
            base_unit = excluded.base_unit,
            min_stock_base = excluded.min_stock_base,
            shelf_location = excluded.shelf_location,
            main_supplier_id = excluded.main_supplier_id,
            needs_price_review = excluded.needs_price_review,
            is_active = excluded.is_active,
            note = excluded.note,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= products.updated_at;

        when 'product_units' then
          insert into product_units
          select * from jsonb_populate_record(null::product_units, v_payload)
          on conflict (id) do update set
            product_id = excluded.product_id,
            unit_name = excluded.unit_name,
            factor_to_base = excluded.factor_to_base,
            barcode = excluded.barcode,
            barcode_source = excluded.barcode_source,
            sell_price = excluded.sell_price,
            is_default_sale = excluded.is_default_sale,
            is_default_purchase = excluded.is_default_purchase,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= product_units.updated_at;

        when 'customers' then
          insert into customers
          select * from jsonb_populate_record(null::customers, v_payload)
          on conflict (id) do update set
            name = excluded.name,
            phone = excluded.phone,
            note = excluded.note,
            credit_limit = excluded.credit_limit,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= customers.updated_at;

        when 'expenses' then
          insert into expenses
          select * from jsonb_populate_record(null::expenses, v_payload)
          on conflict (id) do update set
            category = excluded.category,
            amount = excluded.amount,
            spent_at = excluded.spent_at,
            note = excluded.note,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= expenses.updated_at;

        -- ------------------------------------------------------------ ledger
        when 'price_history' then
          insert into price_history
          select * from jsonb_populate_record(null::price_history, v_payload)
          on conflict (id) do nothing;

        when 'stock_movements' then
          insert into stock_movements
          select * from jsonb_populate_record(null::stock_movements, v_payload)
          on conflict (id) do nothing;

        when 'putaway_log' then
          insert into putaway_log
          select * from jsonb_populate_record(null::putaway_log, v_payload)
          on conflict (id) do nothing;

        when 'debt_ledger' then
          insert into debt_ledger
          select * from jsonb_populate_record(null::debt_ledger, v_payload)
          on conflict (id) do nothing;

        -- ------------------------------------------------------- transaksi
        when 'purchases' then
          insert into purchases
          select * from jsonb_populate_record(null::purchases, v_payload)
          on conflict (id) do update set
            status = excluded.status,
            note = excluded.note,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= purchases.updated_at;

        when 'purchase_items' then
          insert into purchase_items
          select * from jsonb_populate_record(null::purchase_items, v_payload)
          on conflict (id) do nothing;

        when 'sales' then
          insert into sales
          select * from jsonb_populate_record(null::sales, v_payload)
          on conflict (id) do update set
            status = excluded.status,
            note = excluded.note,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= sales.updated_at;

        when 'sale_items' then
          insert into sale_items
          select * from jsonb_populate_record(null::sale_items, v_payload)
          on conflict (id) do nothing;

        when 'payments' then
          insert into payments
          select * from jsonb_populate_record(null::payments, v_payload)
          on conflict (id) do update set
            status = excluded.status,
            reference = excluded.reference,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= payments.updated_at;

        when 'returns' then
          insert into returns
          select * from jsonb_populate_record(null::returns, v_payload)
          on conflict (id) do nothing;

        when 'return_items' then
          insert into return_items
          select * from jsonb_populate_record(null::return_items, v_payload)
          on conflict (id) do nothing;

        when 'stock_opnames' then
          insert into stock_opnames
          select * from jsonb_populate_record(null::stock_opnames, v_payload)
          on conflict (id) do update set
            finished_at = excluded.finished_at,
            status = excluded.status,
            note = excluded.note,
            updated_at = excluded.updated_at,
            deleted_at = excluded.deleted_at,
            device_id = excluded.device_id
          where excluded.updated_at >= stock_opnames.updated_at;

        when 'stock_opname_items' then
          insert into stock_opname_items
          select * from jsonb_populate_record(null::stock_opname_items, v_payload)
          on conflict (id) do nothing;

        else
          raise exception 'tabel tidak didukung untuk sinkron: %', v_table;
      end case;

      v_result := v_result || jsonb_build_object(
        'op_id', v_op_id,
        'status', 'applied'
      );
    exception
      when others then
        -- Gagal: hapus klaim supaya bisa dicoba ulang, lalu laporkan.
        delete from applied_ops where op_id = v_op_id;
        get stacked diagnostics v_error = message_text;
        v_code := sqlstate;
        v_result := v_result || jsonb_build_object(
          'op_id', v_op_id,
          'status', 'error',
          'code', v_code,
          'error', v_error
        );
    end;
  end loop;

  return v_result;
end;
$$;

-- ============================================================== pull
-- Mengembalikan array baris dengan server_seq > p_since, hanya untuk toko
-- pengguna. Tabel divalidasi terhadap daftar putih (tidak ada SQL injection).

create or replace function sync_pull(
  p_table text,
  p_since bigint default 0,
  p_limit integer default 500
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_store uuid := current_store_id();
  v_allowed constant text[] := array[
    'stores', 'profiles', 'devices', 'suppliers', 'categories', 'products',
    'product_units', 'price_history', 'purchases', 'purchase_items',
    'stock_movements', 'putaway_log', 'customers', 'debt_ledger', 'sales',
    'sale_items', 'payments', 'returns', 'return_items', 'stock_opnames',
    'stock_opname_items', 'expenses'
  ];
  v_limit integer := least(greatest(coalesce(p_limit, 500), 1), 1000);
  v_rows jsonb;
begin
  if auth.uid() is null then
    raise exception 'login diperlukan' using errcode = '42501';
  end if;
  if v_store is null then
    raise exception 'akun belum terhubung ke toko' using errcode = '42501';
  end if;
  if p_table is null or not (p_table = any (v_allowed)) then
    raise exception 'tabel tidak didukung untuk sinkron: %', p_table;
  end if;

  if p_table = 'stores' then
    select coalesce(jsonb_agg(to_jsonb(t) order by t.server_seq), '[]'::jsonb)
      into v_rows
      from (
        select *
          from stores
         where id = v_store
           and server_seq > coalesce(p_since, 0)
         order by server_seq
         limit v_limit
      ) t;
  else
    execute format(
      'select coalesce(jsonb_agg(to_jsonb(t) order by t.server_seq), ''[]''::jsonb)
         from (
           select *
             from %I
            where store_id = $1
              and server_seq > $2
            order by server_seq
            limit $3
         ) t',
      p_table
    )
    into v_rows
    using v_store, coalesce(p_since, 0), v_limit;
  end if;

  return coalesce(v_rows, '[]'::jsonb);
end;
$$;

-- ==================================================== peran & izin tulis
-- Staf boleh membaca data toko, tetapi hanya pemilik yang boleh mengubah
-- identitas toko dan profil pengguna (SPEC §5). Fungsi dibuat security definer
-- agar tidak memicu rekursi RLS pada tabel profiles.

create or replace function current_is_owner()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from profiles
     where user_id = auth.uid()
       and role = 'owner'
       and deleted_at is null
  );
$$;

drop policy profiles_isolation on profiles;
create policy profiles_read on profiles
  for select using (store_id = current_store_id());
create policy profiles_write_owner on profiles
  for all using (store_id = current_store_id() and current_is_owner())
  with check (store_id = current_store_id() and current_is_owner());

drop policy stores_isolation on stores;
create policy stores_read on stores
  for select using (id = current_store_id());
create policy stores_write_owner on stores
  for all using (id = current_store_id() and current_is_owner())
  with check (id = current_store_id() and current_is_owner());

-- ============================================================ izin fungsi
-- Hanya pengguna yang login. Anon tidak boleh memanggil.

revoke all on function sync_push(jsonb) from public;
revoke all on function sync_pull(text, bigint, integer) from public;
grant execute on function sync_push(jsonb) to authenticated;
grant execute on function sync_pull(text, bigint, integer) to authenticated;
