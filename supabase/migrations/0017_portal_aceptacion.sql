-- DEMACO — Migración 0017 (F2b): portal de aceptación del contrato.
--
-- El cliente abre el contrato en SU dispositivo (QR en mostrador o
-- link por WhatsApp/email), acepta términos, confirma recepción,
-- firma y —si no está registrado— fotografía su cédula.
--
-- acceptance_token : secreto del link público (lo genera el app).
-- contract_acceptances : resultado documental, escrito SOLO por la
--   Edge Function contract-portal (el app la lee vía pull; así el
--   push del app nunca pisa lo que firmó el cliente).

alter table rental_contracts add column acceptance_token uuid
  default gen_random_uuid();
create index rental_contracts_token_idx
  on rental_contracts (acceptance_token);

create table contract_acceptances (
  -- id = contract_id (1 a 1) para que el upsert de la función sea
  -- idempotente sin unicidades naturales extra.
  id uuid primary key,
  organization_id uuid not null references organizations (id),
  contract_id uuid not null references rental_contracts (id),
  accepted_at timestamptz,
  signer_name text,
  signer_id_number text,
  terms_accepted boolean not null default false,
  receipt_confirmed boolean not null default false,
  signature_path text,
  id_photo_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create trigger contract_acceptances_updated
  before update on contract_acceptances
  for each row execute function set_updated_at();
alter table contract_acceptances enable row level security;
create policy "org select" on contract_acceptances for select
  using (organization_id = current_org_id());
create policy "org insert" on contract_acceptances for insert
  with check (organization_id = current_org_id());
create policy "org update" on contract_acceptances for update
  using (organization_id = current_org_id());
create policy "org delete" on contract_acceptances for delete
  using (organization_id = current_org_id());

-- Buckets: portal (HTML público) y docs (firmas y cédulas, privado).
insert into storage.buckets (id, name, public)
  values ('portal', 'portal', true)
  on conflict (id) do nothing;
insert into storage.buckets (id, name, public)
  values ('docs', 'docs', false)
  on conflict (id) do nothing;
