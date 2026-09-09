-- DEMACO — Migración 0020 (F2c): evidencias fotográficas y garantía.
--
-- rental_line_photos : fotos del estado del equipo al ENTREGAR y al
--   RECIBIR cada unidad (archivo en el bucket docs).
-- rental_contracts   : ciclo de la garantía — recibida al crear,
--   liberada (o retenida parcial/total) al cierre, con motivo.

create table rental_line_photos (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  line_id uuid not null references rental_lines (id),
  kind text not null check (kind in ('delivery', 'return')),
  photo_path text,       -- ruta en el bucket docs
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index rental_line_photos_line_idx on rental_line_photos (line_id);

alter table rental_contracts add column deposit_released_at timestamptz;
alter table rental_contracts add column deposit_retained numeric(12,2)
  not null default 0;
alter table rental_contracts add column deposit_notes text;

create trigger rental_line_photos_updated
  before update on rental_line_photos
  for each row execute function set_updated_at();
alter table rental_line_photos enable row level security;
create policy "org select" on rental_line_photos for select
  using (organization_id = current_org_id());
create policy "org insert" on rental_line_photos for insert
  with check (organization_id = current_org_id());
create policy "org update" on rental_line_photos for update
  using (organization_id = current_org_id());
create policy "org delete" on rental_line_photos for delete
  using (organization_id = current_org_id());
