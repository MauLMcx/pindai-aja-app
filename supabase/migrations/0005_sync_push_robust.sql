-- SPEC §8 — perbaikan ketahanan sync_push.
--
-- Sebelumnya `op_id`/`store_id` di-cast ke uuid di luar blok exception per op.
-- Satu op rusak (mis. op_id bukan UUID) membatalkan seluruh panggilan dan
-- mengembalikan HTTP 500, sehingga op lain yang sudah sah ikut hilang.
-- Sekarang seluruh pemrosesan satu op berada dalam blok exception, jadi
-- kesalahan hanya menghasilkan status `error` untuk op itu (SPEC §8).

create or replace function public.sync_push(p_ops jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_store uuid := public.current_store_id();
  v_op jsonb;
  v_op_id uuid;
  v_table text;
  v_kind text;
  v_payload jsonb;
  v_cols text;
  v_set_cols text;
  v_pk_cols text;
  v_pk_where text;
  v_sql text;
  v_rows integer;
  v_result jsonb := '[]'::jsonb;
begin
  if v_store is null then
    raise exception 'sync_push: pengguna belum login';
  end if;
  if p_ops is null or jsonb_typeof(p_ops) <> 'array' then
    raise exception 'sync_push: ops harus berupa array JSON';
  end if;

  for v_op in select value from jsonb_array_elements(p_ops)
  loop
    begin
      v_op_id := nullif(v_op ->> 'op_id', '')::uuid;
      v_table := v_op ->> 'table';
      v_kind := v_op ->> 'op';
      v_payload := v_op -> 'payload';

      if v_op_id is null or v_table is null or v_kind is null
         or v_payload is null or jsonb_typeof(v_payload) <> 'object' then
        raise exception 'op tidak lengkap';
      end if;

      -- Idempoten: op yang sudah pernah diterapkan dilewati (SPEC P8/S2).
      if exists (select 1 from public.applied_ops a where a.op_id = v_op_id) then
        v_result := v_result || jsonb_build_object(
          'op_id', v_op_id, 'status', 'skipped');
        continue;
      end if;

      if not (v_table = any(public.sync_allowed_tables())) then
        raise exception 'tabel tidak diizinkan: %', v_table;
      end if;

      -- Isolasi toko: klien hanya boleh menulis ke tokonya sendiri.
      if v_table = 'stores' then
        if (v_payload ->> 'id')::uuid is distinct from v_store then
          raise exception 'store tidak cocok';
        end if;
      else
        if (v_payload ->> 'store_id')::uuid is distinct from v_store then
          raise exception 'store tidak cocok';
        end if;
      end if;

      v_pk_cols := case
        when v_table = 'app_settings' then 'store_id, "key"'
        else 'id'
      end;

      -- Syarat baris lama juga dibatasi ke toko pemanggil, agar id baris toko
      -- lain tidak bisa dibajak lewat payload.
      v_pk_where := case
        when v_table = 'stores' then 't.id = $2'
        when v_table = 'app_settings'
          then 't.store_id = $2 and t."key" = $1 ->> ''key'''
        else 't.id = ($1 ->> ''id'')::uuid and t.store_id = $2'
      end;

      -- Kolom insert: hanya kolom valid yang dikirim klien.
      select string_agg(format('%I', c.column_name), ', ')
        into v_cols
        from information_schema.columns c
       where c.table_schema = 'public'
         and c.table_name = v_table
         and c.is_generated = 'NEVER'
         and c.column_name <> 'server_seq'
         and c.column_name in (select jsonb_object_keys(v_payload));

      if v_cols is null then
        raise exception 'payload kosong atau tanpa kolom yang dikenal';
      end if;

      -- Kolom update: identitas dan created_at tidak boleh berubah.
      select string_agg(format('%I', c.column_name), ', ')
        into v_set_cols
        from information_schema.columns c
       where c.table_schema = 'public'
         and c.table_name = v_table
         and c.is_generated = 'NEVER'
         and c.column_name <> 'server_seq'
         and c.column_name not in ('id', 'store_id', 'created_at', 'key')
         and c.column_name in (select jsonb_object_keys(v_payload));

      if v_kind = 'insert' then
        v_sql := format(
          'insert into public.%I (%s) select %s from jsonb_populate_record(null::public.%I, $1) on conflict (%s) do nothing',
          v_table, v_cols, v_cols, v_table, v_pk_cols);
        execute v_sql using v_payload;

      elsif v_kind in ('update', 'upsert') then
        if v_set_cols is not null then
          v_sql := format(
            'update public.%I t set (%s) = (select %s from jsonb_populate_record(null::public.%I, $1)) where %s',
            v_table, v_set_cols, v_set_cols, v_table, v_pk_where);
          execute v_sql using v_payload, v_store;
          get diagnostics v_rows = row_count;
        else
          v_rows := 0;
        end if;

        if v_rows = 0 then
          v_sql := format(
            'insert into public.%I (%s) select %s from jsonb_populate_record(null::public.%I, $1) on conflict (%s) do nothing',
            v_table, v_cols, v_cols, v_table, v_pk_cols);
          execute v_sql using v_payload;
        end if;

      elsif v_kind = 'delete' then
        if not exists (
          select 1 from information_schema.columns c
           where c.table_schema = 'public'
             and c.table_name = v_table
             and c.column_name = 'deleted_at'
        ) then
          raise exception 'tabel % bersifat append-only; delete ditolak', v_table;
        end if;
        v_sql := format(
          'update public.%I t set deleted_at = now() where %s', v_table, v_pk_where);
        execute v_sql using v_payload, v_store;

      else
        raise exception 'op tidak dikenal: %', v_kind;
      end if;

      insert into public.applied_ops (op_id) values (v_op_id)
        on conflict (op_id) do nothing;
      v_result := v_result || jsonb_build_object(
        'op_id', v_op_id, 'status', 'applied');

    exception when others then
      v_result := v_result || jsonb_build_object(
        'op_id', coalesce(v_op ->> 'op_id', ''),
        'status', 'error',
        'error', sqlerrm);
    end;
  end loop;

  return v_result;
end;
$$;

-- ACL dipertahankan saat create or replace, tetapi ditulis ulang agar migrasi
-- ini tetap benar bila dijalankan ulang di lingkungan baru.
revoke all on function public.sync_push(jsonb) from anon;
revoke all on function public.sync_push(jsonb) from public;
grant execute on function public.sync_push(jsonb) to authenticated;
