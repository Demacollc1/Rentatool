-- ALIVIO — Migración 0025: políticas de storage para el bucket docs.
--
-- El app sube evidencias de entrega/recepción a
-- docs/contratos/<contract_id>/evidencias/*.jpg con el JWT del
-- usuario, pero el bucket docs (creado en 0017 para el portal, que
-- escribe con service role) no tenía NINGUNA política para
-- authenticated: cada subida fallaba con RLS y el sync abortaba el
-- push completo. Las rutas de docs no llevan prefijo de organización
-- (contratos/<id>/...), así que el alcance es "cualquier miembro con
-- organización" — suficiente para este despliegue de una sola org.

drop policy if exists "docs org select" on storage.objects;
drop policy if exists "docs org insert" on storage.objects;
drop policy if exists "docs org update" on storage.objects;
drop policy if exists "docs org delete" on storage.objects;

create policy "docs org select" on storage.objects for select
  using (bucket_id = 'docs' and current_org_id() is not null);
create policy "docs org insert" on storage.objects for insert
  with check (bucket_id = 'docs' and current_org_id() is not null);
create policy "docs org update" on storage.objects for update
  using (bucket_id = 'docs' and current_org_id() is not null);
create policy "docs org delete" on storage.objects for delete
  using (bucket_id = 'docs' and current_org_id() is not null);
