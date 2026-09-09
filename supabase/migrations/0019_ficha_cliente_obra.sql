-- DEMACO — Migración 0019: ficha completa de cliente y de obra.
--
-- customers: nombre legal (name) + nombre comercial + clasificación
--   (maestro | constructora | diyer | mantenimiento | obra_eventual).
-- postal_codes: códigos postales INTERNOS de DEMACO (código → ciudad
--   y parroquia); lista administrable.
-- customer_sites: código postal, GPS, contacto (copiable de la
--   facturación del cliente), nº de orden de compra / documento de
--   solicitud y forma de pago (credito | prepago).

alter table customers add column trade_name text;   -- nombre comercial
alter table customers add column kind text
  check (kind in ('maestro', 'constructora', 'diyer',
                  'mantenimiento', 'obra_eventual'));

create table postal_codes (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  code text not null,
  city text not null,
  parish text,          -- parroquia
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index postal_codes_code_idx on postal_codes (code);

alter table customer_sites add column postal_code text;
alter table customer_sites add column gps_lat numeric(10,6);
alter table customer_sites add column gps_lng numeric(10,6);
alter table customer_sites add column contact_email text;
alter table customer_sites add column purchase_order text;
alter table customer_sites add column payment_method text
  not null default 'prepago'
  check (payment_method in ('credito', 'prepago'));

create trigger postal_codes_updated before update on postal_codes
  for each row execute function set_updated_at();
alter table postal_codes enable row level security;
create policy "org select" on postal_codes for select
  using (organization_id = current_org_id());
create policy "org insert" on postal_codes for insert
  with check (organization_id = current_org_id());
create policy "org update" on postal_codes for update
  using (organization_id = current_org_id());
create policy "org delete" on postal_codes for delete
  using (organization_id = current_org_id());
