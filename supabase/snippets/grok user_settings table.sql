create table public.user_settings (
  user_id uuid primary key references auth.users (id) on delete cascade,
  theme text not null default 'tokyonight'
    check (theme in ('tokyonight', 'andromeda', 'ayudark', 'catppuccin', 'everforest', 'flexoki', 'gruvbox', 'kanagawa', 'monokai', 'nightfox', 'nightowl', 'onedarkpro', 'rosepine', 'solarized', 'nord', 'emerald')),
  unit_system text not null default 'metric'
    check (unit_system in ('metric', 'imperial')),
  updated_at timestamptz not null default now()
);

alter table public.user_settings enable row level security;

create policy "Users read own settings"
  on public.user_settings for select to authenticated
  using (auth.uid() = user_id);

create policy "Users insert own settings"
  on public.user_settings for insert to authenticated
  with check (auth.uid() = user_id);

create policy "Users update own settings"
  on public.user_settings for update to authenticated
  using (auth.uid() = user_id);