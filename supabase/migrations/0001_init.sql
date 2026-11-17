-- SPEC §7 — skema awal aplikasi kasir petshop.
-- Semua tabel dilindungi RLS; isolasi berdasarkan store_id pengguna.
-- Tabel ledger bersifat append-only (tidak ada UPDATE/DELETE).

-- ============================================================ tipe & urutan

create type movement_type as enum (
  'purchase_in', 'sale_out', 'return_in', 'purchase_return_out',
  'opname_adjust', 'void_in', 'manual_adjust', 'initial'
);

create type pay_method as enum ('cash', 'qris', 'ewallet', 'transfer', 'card', 'credit');

create sequence server_seq;

-- ================================================================ tabel inti

create table stores (
  id uuid primary key,
  name text not null,
  code2 text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  store_id uuid not null,
  role text not null check (role in ('owner', 'staff')),
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table devices (
  id uuid primary key,
  store_id uuid not null,
  code text not null,
  name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table suppliers (
  id uuid primary key,
  store_id uuid not null,
  name text not null,
  phone text,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table categories (
  id uuid primary key,
  store_id uuid not null,
  name text not null,
  default_margin_pct numeric(6, 2),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table products (
  id uuid primary key,
  store_id uuid not null,
  name text not null,
  brand text,
  variant text,
  category_id uuid,
  base_unit text not null,
  min_stock_base integer not null default 0,
  shelf_location text,
  main_supplier_id uuid,
  needs_price_review boolean not null default false,
  is_active boolean not null default true,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table product_units (
  id uuid primary key,
  store_id uuid not null,
  product_id uuid not null references products (id),
  unit_name text not null,
  factor_to_base integer not null check (factor_to_base > 0),
  barcode text,
  barcode_source text check (barcode_source in ('factory', 'internal')),
  sell_price integer,
  is_default_sale boolean not null default false,
  is_default_purchase boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq'),
  unique (store_id, barcode)
);

-- Ledger harga: APPEND-ONLY.
create table price_history (
  id uuid primary key,
  store_id uuid not null,
  product_unit_id uuid not null references product_units (id),
  kind text not null check (kind in ('buy', 'sell')),
  price integer not null,
  effective_at timestamptz not null,
  source_ref text,
  created_at timestamptz not null default now(),
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table purchases (
  id uuid primary key,
  store_id uuid not null,
  supplier_id uuid,
  doc_no text,
  purchased_at timestamptz not null,
  total integer not null,
  note text,
  status text not null default 'completed',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table purchase_items (
  id uuid primary key,
  store_id uuid not null,
  purchase_id uuid not null references purchases (id),
  product_id uuid not null,
  unit_id uuid not null,
  qty integer not null,
  unit_cost integer not null,
  qty_base integer not null,
  cost_per_base numeric(14, 4) not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

-- Ledger stok: APPEND-ONLY. Stok = sum(qty_base_delta).
create table stock_movements (
  id uuid primary key,
  store_id uuid not null,
  product_id uuid not null,
  qty_base_delta integer not null,
  type movement_type not null,
  ref_type text,
  ref_id uuid,
  cost_per_base numeric(14, 4),
  occurred_at timestamptz not null,
  note text,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

-- Riwayat penataan barang: APPEND-ONLY.
create table putaway_log (
  id uuid primary key,
  store_id uuid not null,
  product_id uuid not null,
  from_location text,
  to_location text,
  occurred_at timestamptz not null,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table customers (
  id uuid primary key,
  store_id uuid not null,
  name text not null,
  phone text,
  note text,
  credit_limit integer,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

-- Ledger utang: APPEND-ONLY. Saldo = sum(delta).
create table debt_ledger (
  id uuid primary key,
  store_id uuid not null,
  customer_id uuid not null,
  delta integer not null,
  type text not null check (type in ('sale_credit', 'payment', 'return_offset', 'adjustment')),
  ref_id uuid,
  method pay_method,
  occurred_at timestamptz not null,
  note text,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table sales (
  id uuid primary key,
  store_id uuid not null,
  receipt_no text not null,
  device_id uuid not null,
  cashier_id uuid not null,
  customer_id uuid,
  sold_at timestamptz not null,
  subtotal integer not null,
  discount_total integer not null default 0,
  total integer not null,
  paid_total integer not null,
  change_amount integer not null default 0,
  status text not null default 'completed' check (status in ('completed', 'void', 'hold')),
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  server_seq bigint not null default nextval('server_seq'),
  unique (store_id, receipt_no)
);

create table sale_items (
  id uuid primary key,
  store_id uuid not null,
  sale_id uuid not null references sales (id),
  product_id uuid not null,
  unit_id uuid not null,
  qty integer not null,
  qty_base integer not null,
  unit_price integer not null,
  discount integer not null default 0,
  line_total integer not null,
  cost_per_base numeric(14, 4),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table payments (
  id uuid primary key,
  store_id uuid not null,
  sale_id uuid not null references sales (id),
  method pay_method not null,
  amount integer not null,
  status text not null default 'confirmed' check (status in ('confirmed', 'pending')),
  reference text,
  paid_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table returns (
  id uuid primary key,
  store_id uuid not null,
  kind text not null check (kind in ('sale', 'purchase')),
  sale_id uuid,
  purchase_id uuid,
  customer_id uuid,
  returned_at timestamptz not null,
  refund_method pay_method,
  refund_total integer not null default 0,
  reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table return_items (
  id uuid primary key,
  store_id uuid not null,
  return_id uuid not null references returns (id),
  product_id uuid not null,
  unit_id uuid not null,
  qty integer not null,
  qty_base integer not null,
  amount integer not null,
  cost_per_base numeric(14, 4),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table stock_opnames (
  id uuid primary key,
  store_id uuid not null,
  started_at timestamptz not null,
  finished_at timestamptz,
  status text not null default 'open' check (status in ('open', 'finished')),
  scope text,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table stock_opname_items (
  id uuid primary key,
  store_id uuid not null,
  opname_id uuid not null references stock_opnames (id),
  product_id uuid not null,
  expected_base integer,
  counted_base integer not null,
  diff_base integer,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table expenses (
  id uuid primary key,
  store_id uuid not null,
  category text not null,
  amount integer not null,
  spent_at timestamptz not null,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  device_id uuid,
  server_seq bigint not null default nextval('server_seq')
);

create table app_settings (
  store_id uuid not null,
  key text not null,
  value jsonb,
  updated_at timestamptz not null default now(),
  server_seq bigint not null default nextval('server_seq'),
  primary key (store_id, key)
);

-- ==================================================== server_seq & audit

create or replace function set_server_seq()
returns trigger
language plpgsql
as $$
begin
  new.server_seq := nextval('server_seq');
  return new;
end;
$$;

create or replace function touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- server_seq naik pada setiap insert/update.
do $$
declare
  t text;
begin
  foreach t in array array[
    'stores', 'profiles', 'devices', 'suppliers', 'categories', 'products',
    'product_units', 'price_history', 'purchases', 'purchase_items',
    'stock_movements', 'putaway_log', 'customers', 'debt_ledger', 'sales',
    'sale_items', 'payments', 'returns', 'return_items', 'stock_opnames',
    'stock_opname_items', 'expenses', 'app_settings'
  ]
  loop
    execute format(
      'create trigger %I_server_seq before insert or update on %I
         for each row execute function set_server_seq()', t, t);
  end loop;
end;
$$;

-- Tabel dengan updated_at diperbarui otomatis.
do $$
declare
  t text;
begin
  foreach t in array array[
    'stores', 'profiles', 'devices', 'suppliers', 'categories', 'products',
    'product_units', 'purchases', 'purchase_items', 'customers', 'sales',
    'sale_items', 'payments', 'returns', 'return_items', 'stock_opnames',
    'stock_opname_items', 'expenses'
  ]
  loop
    execute format(
      'create trigger %I_touch before update on %I
         for each row execute function touch_updated_at()', t, t);
  end loop;
end;
$$;

-- =========================================== larangan ubah tabel ledger

create or replace function forbid_ledger_mutation()
returns trigger
language plpgsql
as $$
begin
  raise exception 'Tabel % bersifat append-only (SPEC P2)', tg_table_name;
end;
$$;

create trigger stock_movements_append_only
  before update or delete on stock_movements
  for each row execute function forbid_ledger_mutation();

create trigger debt_ledger_append_only
  before update or delete on debt_ledger
  for each row execute function forbid_ledger_mutation();

create trigger putaway_log_append_only
  before update or delete on putaway_log
  for each row execute function forbid_ledger_mutation();

create trigger price_history_append_only
  before update or delete on price_history
  for each row execute function forbid_ledger_mutation();

-- =============================================================== indeks

create index products_store_name_idx on products (store_id, name);
create index product_units_store_barcode_idx on product_units (store_id, barcode);
create index stock_movements_product_idx on stock_movements (store_id, product_id);
create index sales_store_sold_at_idx on sales (store_id, sold_at);
create index debt_ledger_customer_idx on debt_ledger (store_id, customer_id);
create index sales_store_updated_idx on sales (store_id, updated_at);

-- ================================================================ RLS

-- Fungsi bantu: store milik pengguna yang login.
create or replace function current_store_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select store_id from profiles where user_id = auth.uid();
$$;

alter table stores enable row level security;
alter table profiles enable row level security;
alter table devices enable row level security;
alter table suppliers enable row level security;
alter table categories enable row level security;
alter table products enable row level security;
alter table product_units enable row level security;
alter table price_history enable row level security;
alter table purchases enable row level security;
alter table purchase_items enable row level security;
alter table stock_movements enable row level security;
alter table putaway_log enable row level security;
alter table customers enable row level security;
alter table debt_ledger enable row level security;
alter table sales enable row level security;
alter table sale_items enable row level security;
alter table payments enable row level security;
alter table returns enable row level security;
alter table return_items enable row level security;
alter table stock_opnames enable row level security;
alter table stock_opname_items enable row level security;
alter table expenses enable row level security;
alter table app_settings enable row level security;

create policy stores_isolation on stores
  for all using (id = current_store_id())
  with check (id = current_store_id());

create policy profiles_isolation on profiles
  for all using (store_id = current_store_id())
  with check (store_id = current_store_id());

do $$
declare
  t text;
begin
  foreach t in array array[
    'devices', 'suppliers', 'categories', 'products', 'product_units',
    'price_history', 'purchases', 'purchase_items', 'stock_movements',
    'putaway_log', 'customers', 'debt_ledger', 'sales', 'sale_items',
    'payments', 'returns', 'return_items', 'stock_opnames',
    'stock_opname_items', 'expenses', 'app_settings'
  ]
  loop
    execute format(
      'create policy %I_isolation on %I for all
         using (store_id = current_store_id())
         with check (store_id = current_store_id())', t, t);
  end loop;
end;
$$;

-- ================================================================ view stok

create view stock_balance as
  select store_id, product_id, sum(qty_base_delta)::int as qty_base
  from stock_movements
  group by store_id, product_id;
