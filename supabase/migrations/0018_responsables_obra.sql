-- DEMACO — Migración 0018: responsables de la herramienta por obra.
--
-- Jerarquía de la renta: cliente → obra/dirección de entrega →
-- responsable (persona del cliente que recibe y responde por la
-- herramienta en esa obra). El contrato referencia a los tres.

create table site_contacts (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  site_id uuid not null references customer_sites (id),
  name text not null,
  id_number text,      -- cédula del responsable
  phone text,
  role text,           -- "Residente de obra", "Bodeguero"…
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index site_contacts_site_idx on site_contacts (site_id);

alter table rental_contracts add column contact_id uuid
  references site_contacts (id);

create trigger site_contacts_updated before update on site_contacts
  for each row execute function set_updated_at();
alter table site_contacts enable row level security;
create policy "org select" on site_contacts for select
  using (organization_id = current_org_id());
create policy "org insert" on site_contacts for insert
  with check (organization_id = current_org_id());
create policy "org update" on site_contacts for update
  using (organization_id = current_org_id());
create policy "org delete" on site_contacts for delete
  using (organization_id = current_org_id());
