-- DEMACO — Migración 0003: inventario de renta.
-- categories, locations, tool_models, assets, consumables,
-- tool_model_consumables, inventory_movements.
-- Ids uuid generados en el CLIENTE (sin default), timestamps + soft
-- delete, RLS por organización y trigger de updated_at en bucle.

create table categories (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  parent_id uuid references categories (id),
  name text not null,
  level int not null default 0 check (level between 0 and 1),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table locations (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  parent_id uuid references locations (id),
  name text not null,
  level int not null default 0 check (level between 0 and 4),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table tool_models (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  name text not null,
  spec text,
  line text not null default 'ind' check (line in ('ind','diy')),
  brand text,
  supplier_code text,
  description text,
  category_id uuid references categories (id),
  list_cost numeric(12,2) not null default 0,
  -- Tarifas: 4h 14% · día 20% · semana 70% · mes 200% del costo
  -- (precarga editable).
  rate_half_day numeric(12,2),
  rate_day numeric(12,2),
  rate_week numeric(12,2),
  rate_month numeric(12,2),
  b87_qty numeric(12,3) not null default 0,
  published boolean not null default false,
  photo_path text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (organization_id, supplier_code)
);

create table assets (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  tool_model_id uuid not null references tool_models (id),
  asset_tag text not null,
  serial text,
  status text not null default 'available' check (status in
    ('available','reserved','rented','maintenance','retired')),
  condition text not null default 'new' check (condition in
    ('new','good','fair','poor')),
  location_id uuid references locations (id),
  purchase_date date,
  purchase_cost numeric(12,2) not null default 0,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (organization_id, asset_tag)
);

create table consumables (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  code text,
  name text not null,
  unit text not null default 'u',
  cost numeric(12,4) not null default 0,
  sale_price numeric(12,4) not null default 0,
  stock numeric(12,3) not null default 0,
  min_stock numeric(12,3) not null default 0,
  location_id uuid references locations (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (organization_id, code)
);

create table tool_model_consumables (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  tool_model_id uuid not null references tool_models (id),
  consumable_id uuid not null references consumables (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (tool_model_id, consumable_id)
);

-- Kardex: la historia de todo movimiento. La ubicación/estado del
-- asset es la foto; el movement es la historia.
create table inventory_movements (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  asset_id uuid references assets (id),
  consumable_id uuid references consumables (id),
  kind text not null check (kind in
    ('intake','transfer','rent_out','rent_return','maintenance_out',
     'maintenance_return','adjust','retire','consume','restock')),
  quantity numeric(12,3) not null default 1,
  from_location_id uuid references locations (id),
  to_location_id uuid references locations (id),
  contract_ref uuid, -- FK real a rental_contracts en fase 2
  moved_at timestamptz not null default now(),
  created_by uuid references profiles (id),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  check (asset_id is not null or consumable_id is not null)
);

create index assets_model_idx on assets (tool_model_id)
  where deleted_at is null;
create index assets_location_idx on assets (location_id)
  where deleted_at is null;
create index movements_asset_idx on inventory_movements (asset_id);
create index tool_models_org_idx on tool_models (organization_id)
  where deleted_at is null;

-- Trigger updated_at + RLS con 4 políticas por tabla.
do $$
declare t text;
begin
  foreach t in array array[
    'categories','locations','tool_models','assets','consumables',
    'tool_model_consumables','inventory_movements'
  ] loop
    execute format(
      'create trigger %I_updated before update on %I
         for each row execute function set_updated_at()', t, t);
    execute format('alter table %I enable row level security', t);
    execute format(
      'create policy "org select" on %I for select
         using (organization_id = current_org_id())', t);
    execute format(
      'create policy "org insert" on %I for insert
         with check (organization_id = current_org_id())', t);
    execute format(
      'create policy "org update" on %I for update
         using (organization_id = current_org_id())', t);
    execute format(
      'create policy "org delete" on %I for delete
         using (organization_id = current_org_id())', t);
  end loop;
end $$;

-- Diseñadas para fase 2 (NO construidas aún): rental_contracts
-- (client_id, status, start_at, due_at, deposit, delivery_code,
-- return_confirmed_at, doc_path) + rental_lines (contract_id,
-- asset_id, rate_kind, rate). assets.status='rented' y
-- movements.contract_ref ya dejan el espacio.
