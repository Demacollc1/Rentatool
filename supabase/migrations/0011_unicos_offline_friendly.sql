-- DEMACO — Migración 0011: reglas de unicidad compatibles con
-- offline multi-dispositivo. Dos teléfonos pueden crear "el mismo"
-- proveedor o producto sin conexión; rechazar el push del segundo
-- bloquea su cola. Se retiran esas restricciones del servidor (la
-- prevención de duplicados es del app; la de-duplicación, un proceso
-- administrativo). Se conservan: canonicals(code) —administrado— y
-- assets(asset_tag) —identidad de la etiqueta física—.

alter table suppliers
  drop constraint if exists suppliers_organization_id_ruc_key;
create index if not exists suppliers_ruc_idx
  on suppliers (organization_id, ruc) where deleted_at is null;

alter table tool_models
  drop constraint if exists tool_models_organization_id_supplier_code_key;
create index if not exists tool_models_supplier_code_idx
  on tool_models (organization_id, supplier_code)
  where deleted_at is null;
