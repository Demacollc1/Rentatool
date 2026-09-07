-- DEMACO — Migración 0002: bucket de fotos (equipos, ubicaciones).
-- Convención de rutas: <organization_id>/<resto>.

insert into storage.buckets (id, name, public)
values ('photos', 'photos', false)
on conflict (id) do nothing;

drop policy if exists "photos org select" on storage.objects;
drop policy if exists "photos org insert" on storage.objects;
drop policy if exists "photos org update" on storage.objects;
drop policy if exists "photos org delete" on storage.objects;

create policy "photos org select" on storage.objects for select
  using (bucket_id = 'photos'
    and (storage.foldername(name))[1] = current_org_id()::text);
create policy "photos org insert" on storage.objects for insert
  with check (bucket_id = 'photos'
    and (storage.foldername(name))[1] = current_org_id()::text);
create policy "photos org update" on storage.objects for update
  using (bucket_id = 'photos'
    and (storage.foldername(name))[1] = current_org_id()::text);
create policy "photos org delete" on storage.objects for delete
  using (bucket_id = 'photos'
    and (storage.foldername(name))[1] = current_org_id()::text);
