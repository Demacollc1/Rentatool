-- DEMACO — Migración 0022: foto en miniatura de cada unidad física.
-- El archivo vive en el bucket photos (<org>/unidades/<asset_id>.jpg);
-- la sube el sync con el mismo patrón de los íconos de canónicos.
alter table assets add column photo_path text;
