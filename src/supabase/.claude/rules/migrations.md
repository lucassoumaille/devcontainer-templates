---
description: Writing SQL migrations
paths:
  - "supabase/migrations/**"
  - "supabase/seed.sql"
---

- One migration per logical change, created with `make new name=<snake_case_description>` (or `make diff name=...` after prototyping in local Studio, then review and clean the generated SQL).
- Migrations already on the base branch are immutable (`make migrations-check`). To fix one, write a new migration.
- Write migrations that apply on the remote database as it is: avoid `drop ... cascade`, data loss and long locks. For a breaking change (rename, type change, NOT NULL on a populated column), use expand/contract over several migrations and say so.
- Lower-case SQL, `snake_case` names, explicit schema (`public.profiles`), `timestamptz` for times, `uuid` keys referencing `auth.users (id)` with `on delete cascade` for user-owned data.
- Index every foreign key and every column used in RLS policies or frequent filters.
- Extensions go in the `extensions` schema: `create extension if not exists postgis with schema extensions;`.
- Do not put reference or test data in migrations; dev data goes to `supabase/seed.sql` (never applied remotely).
- Never create or alter objects in Supabase-managed schemas (`auth`, `storage`, `realtime`, `supabase_functions`) except triggers on `auth.users` and policies on `storage.objects`.
