-- DEMACO — Migración 0021: estado de cuarentena (adelanto de F4).
-- Unidad devuelta que espera revisión/mantenimiento antes de volver
-- al showroom. Kardex: quarantine_in / quarantine_out.

alter table assets drop constraint if exists assets_status_check;
alter table assets add constraint assets_status_check
  check (status in ('available', 'reserved', 'rented',
                    'maintenance', 'quarantine', 'retired'));

alter table inventory_movements
  drop constraint if exists inventory_movements_kind_check;
alter table inventory_movements add constraint inventory_movements_kind_check
  check (kind in ('intake', 'transfer', 'rent_out', 'rent_return',
                  'maintenance_out', 'maintenance_return',
                  'quarantine_in', 'quarantine_out',
                  'adjust', 'retire', 'consume', 'restock'));
