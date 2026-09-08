-- DEMACO — Migración 0012: se retiran TODAS las unicidades por clave
-- natural. En offline-first multi-dispositivo, cualquier unique que no
-- sea la PK termina bloqueando la cola de un teléfono (23505) cuando
-- dos dispositivos crean "lo mismo" sin conexión. La prevención pasa
-- al app y la de-duplicación es administrativa. Quedan índices
-- normales para las búsquedas.

alter table assets
  drop constraint if exists assets_organization_id_asset_tag_key;
create index if not exists assets_tag_idx
  on assets (organization_id, asset_tag) where deleted_at is null;

alter table consumables
  drop constraint if exists consumables_organization_id_code_key;
create index if not exists consumables_code_idx
  on consumables (organization_id, code) where deleted_at is null;

alter table canonicals
  drop constraint if exists canonicals_organization_id_code_key;
create index if not exists canonicals_code_idx
  on canonicals (organization_id, code) where deleted_at is null;

alter table canonical_attributes
  drop constraint if exists
    canonical_attributes_organization_id_canonical_code_name_key;
create index if not exists canonical_attributes_idx
  on canonical_attributes (organization_id, canonical_code)
  where deleted_at is null;

alter table tool_model_attributes
  drop constraint if exists tool_model_attributes_tool_model_id_name_key;
create index if not exists tool_model_attributes_idx
  on tool_model_attributes (tool_model_id) where deleted_at is null;

alter table tool_model_consumables
  drop constraint if exists
    tool_model_consumables_tool_model_id_consumable_id_key;
create index if not exists tool_model_consumables_idx
  on tool_model_consumables (tool_model_id) where deleted_at is null;

alter table tool_model_categories
  drop constraint if exists
    tool_model_categories_tool_model_id_category_id_key;
create index if not exists tool_model_categories_idx
  on tool_model_categories (tool_model_id) where deleted_at is null;
