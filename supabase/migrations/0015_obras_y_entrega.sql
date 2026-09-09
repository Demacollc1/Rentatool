-- DEMACO — Migración 0015: obras del cliente y método de entrega.
--
-- customer_sites : proyectos/obras de un cliente (un cliente puede
--                  tener varias), con la dirección donde estará la
--                  herramienta rentada.
-- rental_contracts += delivery_method (retiro en local o envío por
--                  transporte), site_id (obra destino) y delivery_fee
--                  (costo del transporte, suma al total).

create table customer_sites (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  customer_id uuid not null references customers (id),
  name text not null,          -- "Edificio Norte", "Casa Cumbayá"
  address text,
  contact_name text,
  contact_phone text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index customer_sites_customer_idx on customer_sites (customer_id);

alter table rental_contracts add column delivery_method text
  not null default 'pickup'
  check (delivery_method in ('pickup', 'delivery'));
alter table rental_contracts add column site_id uuid
  references customer_sites (id);
alter table rental_contracts add column delivery_fee numeric(12,2)
  not null default 0;

create trigger customer_sites_updated before update on customer_sites
  for each row execute function set_updated_at();
alter table customer_sites enable row level security;
create policy "org select" on customer_sites for select
  using (organization_id = current_org_id());
create policy "org insert" on customer_sites for insert
  with check (organization_id = current_org_id());
create policy "org update" on customer_sites for update
  using (organization_id = current_org_id());
create policy "org delete" on customer_sites for delete
  using (organization_id = current_org_id());
