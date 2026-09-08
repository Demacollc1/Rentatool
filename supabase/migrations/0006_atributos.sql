-- DEMACO — Migración 0006: atributos por canónico y por producto.
-- El canónico define QUÉ atributos importan en su familia (plantilla);
-- el producto define los VALORES mínimos que cualquier modelo
-- alternativo debe cumplir para pertenecer a ese código.

create table canonical_attributes (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  canonical_code text not null,
  name text not null,           -- ej. "Potencia (W)", "Disco (mm)"
  position int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (organization_id, canonical_code, name)
);

create table tool_model_attributes (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  tool_model_id uuid not null references tool_models (id),
  name text not null,
  value text not null,          -- ej. "1400-1500 W", "≥115 mm"
  position int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (tool_model_id, name)
);

do $$
declare t text;
begin
  foreach t in array array['canonical_attributes','tool_model_attributes']
  loop
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
