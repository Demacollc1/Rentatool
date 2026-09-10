-- ALIVIO — Migración 0023: reglas de negocio de la renta.
--
-- 1) customers.qualification: nuevo (100% garantía) | frecuente
--    (50%, calificados/corporativos) | con_contrato (30%).
-- 2) rental_contracts: deposit_required (default true, desactivable
--    para calificados) y deposit_manual (el monto se editó a mano).
-- 3) tool_model_consumables: kind incluido|opcional + extra_price —
--    se configura EN EL PRODUCTO qué va amarrado y qué es opcional.
-- 4) contract_consumables: consumibles/accesorios del contrato.
-- 5) contract_addendums: extensiones/modificaciones de fechas como
--    addendum (historial), sin sobreescribir silenciosamente.
-- 6) rental_line_photos ahora admite fotos a nivel de contrato
--    (foto obligatoria de la entrega).

alter table customers add column qualification text
  not null default 'nuevo'
  check (qualification in ('nuevo', 'frecuente', 'con_contrato'));

alter table rental_contracts add column deposit_required boolean
  not null default true;
alter table rental_contracts add column deposit_manual boolean
  not null default false;

alter table tool_model_consumables add column kind text
  not null default 'incluido'
  check (kind in ('incluido', 'opcional'));
alter table tool_model_consumables add column extra_price numeric(12,2)
  not null default 0;

create table contract_consumables (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  contract_id uuid not null references rental_contracts (id),
  line_id uuid references rental_lines (id),
  consumable_id uuid not null references consumables (id),
  kind text not null default 'incluido'
    check (kind in ('incluido', 'opcional')),
  qty numeric(8,2) not null default 1,
  price numeric(12,2) not null default 0,
  amount numeric(12,2) not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index contract_consumables_contract_idx
  on contract_consumables (contract_id);

create table contract_addendums (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  contract_id uuid not null references rental_contracts (id),
  kind text not null default 'extension'
    check (kind in ('extension', 'modificacion')),
  old_pickup_at timestamptz,
  new_pickup_at timestamptz,
  old_due_at timestamptz,
  new_due_at timestamptz,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);
create index contract_addendums_contract_idx
  on contract_addendums (contract_id);

alter table rental_line_photos alter column line_id drop not null;
alter table rental_line_photos add column contract_id uuid
  references rental_contracts (id);

do $$
declare t text;
begin
  foreach t in array
      array['contract_consumables', 'contract_addendums'] loop
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
