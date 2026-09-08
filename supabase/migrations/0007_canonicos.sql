-- DEMACO — Migración 0007: los canónicos son datos administrables
-- (antes solo semilla del ERP empaquetada en el app). Cada org puede
-- agregar/editar códigos; la semilla del ERP se carga en el cliente
-- con ids determinísticos (no se duplica).

create table canonicals (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  code text not null,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (organization_id, code)
);

create trigger canonicals_updated before update on canonicals
  for each row execute function set_updated_at();
alter table canonicals enable row level security;
create policy "org select" on canonicals for select
  using (organization_id = current_org_id());
create policy "org insert" on canonicals for insert
  with check (organization_id = current_org_id());
create policy "org update" on canonicals for update
  using (organization_id = current_org_id());
create policy "org delete" on canonicals for delete
  using (organization_id = current_org_id());
