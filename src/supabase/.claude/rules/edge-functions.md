---
description: Supabase Edge Functions (Deno)
paths:
  - "supabase/functions/**"
---

- One folder per function (`supabase/functions/<name>/index.ts`), shared code in `supabase/functions/_shared/`. Create with `supabase functions new <name>`, serve locally with `supabase functions serve`.
- Import dependencies with `npm:` or `jsr:` specifiers pinned to a version; use the generated `_shared/database.types.ts` (`make types`) for typed queries.
- Verify the caller: keep JWT verification on (default) and create the Supabase client with the caller's `Authorization` header so RLS applies. Use the secret / `service_role` key only for operations that must bypass RLS, and check authorization yourself first.
- Secrets come from `Deno.env.get(...)`, set with `supabase secrets set` remotely and `supabase/functions/.env` locally (ignored by git). Never hard-code them.
- Validate request bodies, return JSON errors with proper status codes, handle CORS preflight for browser callers.
- Keep `deno fmt --check` and `deno lint` clean (run by `scripts/agent-check.sh`).
