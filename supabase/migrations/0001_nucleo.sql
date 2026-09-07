-- DEMACO Rent a Tool — Migración 0001: núcleo multi-tenant.
-- Mismo patrón que YASTA: organizations + profiles + current_org_id()
-- + RLS por organización en toda tabla de negocio.

create table organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  ruc text,
  phone text,
  email text,
  address text,
  logo_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  organization_id uuid not null references organizations (id),
  full_name text,
  -- Roles reales del negocio (fase 1 todos operan como owner; las
  -- políticas por rol llegan en la fase multi-rol).
  role text not null default 'owner' check (role in
    ('owner','admin','manager','sales','custodian','technician','logistics')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function current_org_id() returns uuid
language sql stable security definer set search_path = public as $$
  select organization_id from profiles where id = auth.uid();
$$;

create or replace function set_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

alter table organizations enable row level security;
alter table profiles enable row level security;

create policy "leer mi organizacion" on organizations
  for select using (id = current_org_id());
create policy "actualizar mi organizacion" on organizations
  for update using (id = current_org_id());
create policy "leer perfiles de mi org" on profiles
  for select using (organization_id = current_org_id());
create policy "actualizar mi perfil" on profiles
  for update using (id = auth.uid());
