---
description: Row Level Security, grants and functions
paths:
  - "supabase/migrations/**"
  - "supabase/tests/**"
---

- `alter table ... enable row level security` for every table in `public`, in the migration that creates it.
- Supabase grants new tables to `anon` and `authenticated` by default: `revoke` what a role must not have, then `grant` the minimum. RLS policies come on top of grants, not instead of them.
- One policy per operation and role (`for select to authenticated using (...)`), named for what it allows. `insert`/`update` policies need `with check` so users cannot write rows they could not read (e.g. forge `owner_id`/`sender_id`).
- Use `(select auth.uid())` in policies (evaluated once per query, not per row). Never trust `auth.jwt() -> 'user_metadata'` for authorization: users can edit it.
- Columns users must not change (ids, owner, status set by the server): no `update` grant on them (`grant update (col_a, col_b)`), or a trigger that rejects the change.
- Server-side invariants (e.g. creating a row only as the result of a business rule) belong to triggers or `security definer` functions, with no direct `insert` grant for users.
- `security definer` functions: `set search_path = ''`, fully qualified names, check `auth.uid()` inside, and `revoke execute ... from public, anon` unless anonymous access is intended.
- Views in `public` use `with (security_invoker = true)`.
- The `service_role` / secret key bypasses RLS: only Edge Functions and backends use it, never the mobile app.
- Storage: one bucket per access pattern, policies on `storage.objects` scoped by `bucket_id` and the owner's folder (`(storage.foldername(name))[1] = (select auth.uid())::text`).
