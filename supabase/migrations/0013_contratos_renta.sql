-- DEMACO — Migración 0013 (F2): contratos de renta.
--
-- customers        : cliente de la renta (persona o empresa).
-- rental_contracts : contrato CTR-0001 con estado draft→active→closed.
-- rental_lines     : una línea por unidad física rentada, con la
--                    tarifa aplicada (4h/día/semana/mes) y períodos.
--
-- El kardex sigue en inventory_movements (rent_out/rent_return con
-- contract_ref = número de contrato). Sin unicidades por clave natural
-- (offline multi-dispositivo, ver 0011/0012): solo PKs.

create table customers (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  name text not null,
  -- Cédula o RUC (Ecuador).
  id_number text,
  phone text,
  email text,
  address text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table rental_contracts (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  -- Correlativo humano: CTR-0001…
  contract_number text not null,
  customer_id uuid not null references customers (id),
  status text not null default 'draft'
    check (status in ('draft', 'active', 'closed', 'cancelled')),
  start_at timestamptz,
  due_at timestamptz,
  returned_at timestamptz,
  -- Garantía recibida (se devuelve al cierre).
  deposit numeric(12,2) not null default 0,
  notes text,
  created_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index rental_contracts_org_idx
  on rental_contracts (organization_id, status);

create table rental_lines (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  contract_id uuid not null references rental_contracts (id),
  asset_id uuid not null references assets (id),
  tool_model_id uuid not null references tool_models (id),
  -- Tarifa aplicada: half_day (bloque 4-5h) | day | week | month.
  rate_kind text not null default 'day'
    check (rate_kind in ('half_day', 'day', 'week', 'month')),
  rate numeric(12,2) not null default 0,
  periods numeric(8,2) not null default 1,
  amount numeric(12,2) not null default 0,
  delivered_at timestamptz,
  returned_at timestamptz,
  condition_out text,
  condition_in text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index rental_lines_contract_idx on rental_lines (contract_id);
create index rental_lines_asset_idx on rental_lines (asset_id);

-- Trigger + RLS, mismo patrón de 0003/0004.
do $$
declare t text;
begin
  foreach t in array
      array['customers', 'rental_contracts', 'rental_lines'] loop
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
