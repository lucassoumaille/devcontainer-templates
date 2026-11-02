-- Security rules that every schema in this project must satisfy. Objects created by
-- extensions (e.g. PostGIS spatial_ref_sys) are ignored: they are not ours to secure.
begin;
create extension if not exists pgtap with schema extensions;

select plan(4);

select is_empty(
  $$
    select c.relname::text
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind in ('r', 'p')
      and not c.relrowsecurity
      and not exists (select 1 from pg_depend d where d.objid = c.oid and d.deptype = 'e')
  $$,
  'RLS is enabled on every table in public'
);

-- Without security_invoker a view runs with its owner's rights and bypasses RLS.
select is_empty(
  $$
    select c.relname::text
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind = 'v'
      and not exists (
        select 1 from unnest(coalesce(c.reloptions, '{}')) as o
        where o ~* '^security_invoker=(true|on|1|yes)$'
      )
      and not exists (select 1 from pg_depend d where d.objid = c.oid and d.deptype = 'e')
  $$,
  'every view in public uses security_invoker'
);

-- A security definer function without a fixed search_path can be hijacked through objects
-- created in a schema that comes first in the caller's search_path.
select is_empty(
  $$
    select p.proname::text
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.prosecdef
      and not exists (
        select 1 from unnest(coalesce(p.proconfig, '{}')) as c where c like 'search_path=%'
      )
      and not exists (select 1 from pg_depend d where d.objid = p.oid and d.deptype = 'e')
  $$,
  'every security definer function in public sets search_path'
);

-- Security definer functions bypass RLS: anonymous callers must not reach them, unless the
-- function is listed here on purpose (e.g. a public sign-up check).
select is_empty(
  $$
    select p.proname::text
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.prosecdef
      and has_function_privilege('anon', p.oid, 'execute')
      and not exists (select 1 from pg_depend d where d.objid = p.oid and d.deptype = 'e')
      and p.proname <> all (array[]::name[])
  $$,
  'anon cannot execute security definer functions in public'
);

select * from finish();
rollback;
