create or replace function get_random_photos(photo_count int default 5)
returns setof photos
language sql
stable
as $$
  select *
  from photos
  where status = 'approved'
  order by random()
  limit photo_count;
$$;

grant execute on function get_random_photos(int) to anon, authenticated;