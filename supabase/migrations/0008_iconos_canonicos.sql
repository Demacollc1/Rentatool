-- DEMACO — Migración 0008: ícono por canónico (se reutiliza en el
-- catálogo). El binario vive en el bucket photos: <org>/canonicos/<id>.
alter table canonicals add column icon_path text;
