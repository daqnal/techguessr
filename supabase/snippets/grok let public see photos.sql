create policy "photos public select"
on storage.objects
for select
to public
using (
  bucket_id = 'photos'
);