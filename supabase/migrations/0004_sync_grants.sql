-- SPEC §8 — batasi RPC sinkron hanya untuk pengguna login.
--
-- Default privileges Supabase memberi EXECUTE ke anon/authenticated saat fungsi
-- dibuat, sehingga `revoke ... from PUBLIC` saja tidak cukup. Cabut eksplisit
-- dari anon agar RPC tidak bisa dipanggil tanpa login.

revoke all on function public.sync_push(jsonb) from anon;
revoke all on function public.sync_pull(text, bigint, integer) from anon;
revoke all on function public.sync_allowed_tables() from anon;

revoke all on function public.sync_push(jsonb) from public;
revoke all on function public.sync_pull(text, bigint, integer) from public;
revoke all on function public.sync_allowed_tables() from public;

grant execute on function public.sync_push(jsonb) to authenticated;
grant execute on function public.sync_pull(text, bigint, integer) to authenticated;
grant execute on function public.sync_allowed_tables() to authenticated;

-- Catatan: `applied_ops` sengaja punya RLS tanpa policy (deny-by-default).
-- Hanya sync_push (security definer) yang boleh membacanya; advisor akan
-- menampilkan WARN `rls_enabled_no_policy` dan itu diterima.
