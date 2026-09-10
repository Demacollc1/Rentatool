-- ALIVIO — Migración 0024 (F4): mantenimiento y cuarentena.
--
-- maintenance_orders : orden de trabajo sobre una unidad (revisión
--   post-renta, preventivo o correctivo) con costos de mano de obra,
--   repuestos, otros y depreciación, y lectura de horómetro.
-- maintenance_plans  : planes preventivos POR PRODUCTO (cada N días
--   y/o cada N horas de trabajo).
-- assets             : horómetro acumulado y última revisión.

alter table assets add column hours_meter numeric(10,1)
  not null default 0;
alter table assets add column last_maintenance_at timestamptz;

create table maintenance_orders (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  asset_id uuid not null references assets (id),
  kind text not null default 'revision'
    check (kind in ('revision', 'preventivo', 'correctivo')),
  status text not null default 'open'
    check (status in ('open', 'done')),
  contract_ref text,
  opened_at timestamptz not null default now(),
  closed_at timestamptz,
  hours_meter numeric(10,1),      -- lectura al cierre
  labor_cost numeric(12,2) not null default 0,
  parts_cost numeric(12,2) not null default 0,
  other_cost numeric(12,2) not null default 0,
  depreciation_cost numeric(12,2) not null default 0,
  total_cost numeric(12,2) not null default 0,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index maintenance_orders_asset_idx
  on maintenance_orders (asset_id);
create index maintenance_orders_status_idx
  on maintenance_orders (organization_id, status);

create table maintenance_plans (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  tool_model_id uuid not null references tool_models (id),
  name text not null,             -- "Cambio de carbones", "Engrase"
  every_days int,                 -- cada N días calendario
  every_hours numeric(10,1),      -- cada N horas de trabajo
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index maintenance_plans_model_idx
  on maintenance_plans (tool_model_id);

do $$
declare t text;
begin
  foreach t in array
      array['maintenance_orders', 'maintenance_plans'] loop
    execute format('create trigger %I_updated before update on %I
                    for each row execute function set_updated_at()', t, t);
    execute format('alter table %I enable row level security', t);
    execute format('create policy "org select" on %I for select
                    using (organization_id = current_org_id())', t);
    execute format('create policy "org insert" on %I for insert
                    with check (organization_id = current_org_id())', t);
    execute format('create policy "org update" on %I for update
                    using (organization_id = current_org_id())', t);
    execute format('create policy "org delete" on %I for delete
                    using (organization_id = current_org_id())', t);
  end loop;
end;
$$;
