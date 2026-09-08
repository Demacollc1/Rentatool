-- DEMACO — Migración 0010: link a la ficha técnica de cada unidad.
alter table assets add column datasheet_url text;
