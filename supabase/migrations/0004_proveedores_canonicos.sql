-- DEMACO — Migración 0004: proveedores y códigos canónicos.
-- Código propio Rent a Tool = canónico del ERP + secuencial (AAQ-003).

create table suppliers (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  name text not null,
  ruc text,
  phone text,
  email text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (organization_id, ruc)
);

alter table tool_models add column rat_code text;
alter table tool_models add column canonical_code text;
alter table tool_models add column canonical_name text;
alter table tool_models add column variant text;
alter table tool_models add column supplier_id uuid references suppliers (id);
create unique index tool_models_rat_code_idx
  on tool_models (organization_id, rat_code) where deleted_at is null;

alter table assets add column supplier_id uuid references suppliers (id);
alter table assets add column invoice_number text;

alter table consumables add column canonical_code text;
alter table consumables add column supplier_id uuid references suppliers (id);

-- Trigger + RLS para suppliers (mismo patrón de 0003).
create trigger suppliers_updated before update on suppliers
  for each row execute function set_updated_at();
alter table suppliers enable row level security;
create policy "org select" on suppliers for select
  using (organization_id = current_org_id());
create policy "org insert" on suppliers for insert
  with check (organization_id = current_org_id());
create policy "org update" on suppliers for update
  using (organization_id = current_org_id());
create policy "org delete" on suppliers for delete
  using (organization_id = current_org_id());
