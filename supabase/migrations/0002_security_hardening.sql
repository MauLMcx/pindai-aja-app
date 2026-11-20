-- SPEC §7 — perbaikan dari Supabase security & performance advisor.
-- Diterapkan setelah 0001_init.

-- =========================================== view stok mengikuti RLS pengguna
-- Sebelumnya view berjalan dengan hak pemilik (postgres) sehingga pembacaan
-- bisa melewati RLS stock_movements dan memperlihatkan stok toko lain.
-- security_invoker membuat RLS dievaluasi sebagai pengguna yang bertanya.
alter view public.stock_balance set (security_invoker = true);

-- ==================================================== kunci search_path fungsi
-- Fungsi trigger/utilitas tidak butuh search_path yang bisa diubah pemanggil.
alter function public.set_server_seq() set search_path = public, pg_temp;
alter function public.touch_updated_at() set search_path = public, pg_temp;
alter function public.forbid_ledger_mutation() set search_path = public, pg_temp;

-- Catatan: public.current_store_id() tetap SECURITY DEFINER dan dapat dipanggil
-- anon/authenticated. Itu disengaja: dipakai policy RLS dan harus menghindari
-- rekursi ke tabel profiles. Fungsinya hanya mengembalikan store_id pengguna
-- yang sedang login (null untuk anon), bukan data toko lain.

-- =============================================== indeks untuk foreign key umum
create index if not exists product_units_product_id_idx
  on public.product_units (product_id);
create index if not exists price_history_product_unit_id_idx
  on public.price_history (product_unit_id);
create index if not exists purchase_items_purchase_id_idx
  on public.purchase_items (purchase_id);
create index if not exists sale_items_sale_id_idx
  on public.sale_items (sale_id);
create index if not exists payments_sale_id_idx
  on public.payments (sale_id);
create index if not exists return_items_return_id_idx
  on public.return_items (return_id);
create index if not exists stock_opname_items_opname_id_idx
  on public.stock_opname_items (opname_id);
