-- DEMACO — Migración 0016: fecha de retiro pactada del contrato.
-- El cálculo de tarifa necesita DOS fechas explícitas: retiro
-- (pickup_at, pactada) y devolución (due_at). start_at sigue siendo
-- el momento real de la entrega; si existe, manda sobre pickup_at.
alter table rental_contracts add column pickup_at timestamptz;
