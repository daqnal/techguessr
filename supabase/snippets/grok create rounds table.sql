create table public.game_rounds (
  id uuid primary key default gen_random_uuid(),
  game_id uuid not null references public.games (id) on delete cascade,
  round_index int not null check (round_index between 0 and 4),
  photo_id uuid not null references public.photos (id),
  guess_lat double precision,
  guess_lng double precision,
  score int not null default 0,
  distance_m double precision,
  -- future: duration_ms int,
  created_at timestamptz not null default now(),
  unique (game_id, round_index)
);

alter table public.game_rounds enable row level security;

create policy "Users read own rounds"
  on public.game_rounds for select to authenticated
  using (
    exists (
      select 1 from public.games g
      where g.id = game_id and g.user_id = auth.uid()
    )
  );

create policy "Users insert own rounds"
  on public.game_rounds for insert to authenticated
  with check (
    exists (
      select 1 from public.games g
      where g.id = game_id and g.user_id = auth.uid()
    )
  );