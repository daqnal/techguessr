create or replace function get_random_photos(
  photo_count int default 5,
  exclude_user_id uuid default null
)
returns setof photos
language sql
stable
as $$
  select *
  from photos
  where status = 'approved'
    and (exclude_user_id is null or user_id is distinct from exclude_user_id)
  order by random()
  limit photo_count;
$$;

grant execute on function get_random_photos(int, uuid) to anon, authenticated;