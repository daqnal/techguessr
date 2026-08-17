-- Profiles extension (add these columns)
alter table profiles
  add column if not exists avatar_timeout_until timestamptz,
  add column if not exists last_avatar_change_at timestamptz;

-- Action log (used for rate limiting)
create table if not exists user_actions (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users on delete cascade,
  action text not null,
  ip inet,
  created_at timestamptz not null default now()
);

create index on user_actions (user_id, action, created_at desc);
create index on user_actions (ip, action, created_at desc);

-- alter table user_actions enable row level security;