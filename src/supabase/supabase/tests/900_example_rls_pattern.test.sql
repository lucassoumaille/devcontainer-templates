-- Example of a behavioural RLS test: copy this pattern for each table of the real schema,
-- then delete this file. It creates its own table so it runs on an empty project; real tests
-- use the tables created by the migrations instead.
--
-- Simulating users:
--   set local role authenticated;
--   set local request.jwt.claims = '{"sub": "<user uuid>", "role": "authenticated"}';
--   ... queries now run as that user, auth.uid() returns <user uuid> ...
--   reset role;   -- back to postgres (needed before switching to another role such as anon)
begin;
create extension if not exists pgtap with schema extensions;

select plan(5);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'alice@example.com'),
  ('22222222-2222-2222-2222-222222222222', 'bob@example.com');

create table public.example_notes (
  id bigint generated always as identity primary key,
  owner_id uuid not null default auth.uid() references auth.users (id),
  body text not null
);
alter table public.example_notes enable row level security;
create policy "owners read their notes" on public.example_notes
  for select to authenticated using (owner_id = (select auth.uid()));
create policy "owners create their notes" on public.example_notes
  for insert to authenticated with check (owner_id = (select auth.uid()));
-- Supabase grants every new public table to anon and authenticated by default: revoke what
-- each role should not have, RLS is then a second line of defence.
revoke all on public.example_notes from anon, authenticated;
grant select, insert on public.example_notes to authenticated;

-- Alice
set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111", "role": "authenticated"}';

select lives_ok(
  $$ insert into public.example_notes (body) values ('alice note') $$,
  'a user can create a note'
);

select throws_ok(
  $$ insert into public.example_notes (owner_id, body)
     values ('22222222-2222-2222-2222-222222222222', 'forged') $$,
  '42501',
  null,
  'a user cannot create a note owned by someone else'
);

-- Bob
set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222", "role": "authenticated"}';

select is_empty(
  $$ select id from public.example_notes $$,
  'another user does not see the note'
);

-- Anonymous visitor
reset role;
set local role anon;
set local request.jwt.claims = '{"role": "anon"}';

select throws_ok(
  $$ select id from public.example_notes $$,
  '42501',
  null,
  'anon has no access to the table'
);

reset role;

select is(
  (select count(*)::int from public.example_notes),
  1,
  'the note exists (checked as postgres, which bypasses RLS)'
);

select * from finish();
rollback;
