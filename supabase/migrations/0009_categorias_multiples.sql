-- DEMACO — Migración 0009: un producto puede pertenecer a varias
-- categorías (oficios). tool_models.category_id queda como categoría
-- principal (legado del import); las adicionales van aquí.

create table tool_model_categories (
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  tool_model_id uuid not null references tool_models (id),
  category_id uuid not null references categories (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  unique (tool_model_id, category_id)
);

create trigger tool_model_categories_updated before update
  on tool_model_categories
  for each row execute function set_updated_at();
alter table tool_model_categories enable row level security;
create policy "org select" on tool_model_categories for select
  using (organization_id = current_org_id());
create policy "org insert" on tool_model_categories for insert
  with check (organization_id = current_org_id());
create policy "org update" on tool_model_categories for update
  using (organization_id = current_org_id());
create policy "org delete" on tool_model_categories for delete
  using (organization_id = current_org_id());
