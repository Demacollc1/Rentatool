-- DEMACO — Migración 0005: la marca y el modelo de fábrica pertenecen
-- a la UNIDAD física, no al producto. El producto es la especificación
-- de renta (ej. "Esmeriladora angular 4 1/2'' Industrial 1400-1500W");
-- las unidades pueden ser de fabricantes distintos con rendimiento
-- equivalente. En tool_models, brand/supplier_code quedan como
-- "modelo de referencia de compra" (informativo).

alter table assets add column brand text;
alter table assets add column mfr_model text;
