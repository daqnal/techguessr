-- Check photo upload limit
create or replace function can_upload_photo(p_user_id uuid)
returns boolean
language plpgsql
security definer
as $$
declare
  count int;
begin
  select count(*) into count
  from user_actions
  where user_id = p_user_id
    and action = 'photo_upload'
    and created_at > now() - interval '1 hour';

  return count < 15;   -- change the number here too if you prefer
end;
$$;

-- Record an action
create or replace function record_action(
  p_user_id uuid,
  p_action text,
  p_ip inet default null
)
returns void
language sql
security definer
as $$
  insert into user_actions (user_id, action, ip)
  values (p_user_id, p_action, p_ip);
$$;