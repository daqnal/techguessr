create policy "photos users insert own"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'photos'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "photos users update own"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'photos'
  and owner_id = (select auth.uid()::text)
)
with check (
  bucket_id = 'photos'
  and owner_id = (select auth.uid()::text)
);

create policy "photos users delete own"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'photos'
  and owner_id = (select auth.uid()::text)
);