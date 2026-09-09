-- DEMACO — Migración 0014: contract_ref del kardex pasa a texto.
-- 0003 lo creó uuid, pero desde F2 guarda el número humano del
-- contrato (CTR-0001) para leer el kardex sin joins.
alter table inventory_movements
  alter column contract_ref type text using contract_ref::text;
