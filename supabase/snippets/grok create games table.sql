create table public.games (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users (id) on delete set null, -- null = anonymous
  total_score int not null default 0,
  created_at timestamptz not null default now()
);

alter table public.games enable row level security;

-- Logged-in users: only their games
create policy "Users read own games"
  on public.games for select to authenticated
  using (auth.uid() = user_id);

create policy "Users insert own games"
  on public.games for insert to authenticated
  with check (auth.uid() = user_id);

-- Optional: allow anon inserts if you want guest games stored
-- (use a policy carefully; often you only insert when logged in)