---
description: pgTAP tests and validation
paths:
  - "supabase/tests/**"
  - "supabase/migrations/**"
---

- Tests live in `supabase/tests/*.test.sql`, one file per table or feature, each wrapped in `begin; ... rollback;` with `select plan(n)` and `select * from finish()`.
- `000_security_baseline.test.sql` enforces project-wide rules (RLS on, security_invoker views, search_path on security definer functions, no anon access to them). Extend its allowlist only with the user's approval.
- Test behavior as each role, not just the presence of policies: `set local role authenticated; set local request.jwt.claims = '{"sub": "<uuid>", "role": "authenticated"}';`, `reset role` before switching to `anon`. See `900_example_rls_pattern.test.sql`.
- For each table cover: owner can read/write, another user cannot read/write, anon cannot, forged ownership columns are rejected (`throws_ok(..., '42501', ...)`), immutable columns cannot be updated.
- Create fixture users with fixed UUIDs in `auth.users` inside the test; do not depend on `seed.sql`.
- An `update`/`delete` blocked by RLS affects 0 rows without error: assert the row is unchanged afterwards, not only that no error was raised.
- Run `make test` while iterating and `make check` before completion. Never delete or weaken a test because it fails; report the failure.
