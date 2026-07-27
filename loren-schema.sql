-- ניהול חוזים ותשלומים — לורן
-- הרץ פעם אחת בפרויקט ה-Supabase הנפרד של לורן (Project → SQL Editor → New query → Run)

create table if not exists clients (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  contact_name text,
  phone text,
  email text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists contracts (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references clients(id) on delete cascade,
  title text not null,
  amount numeric,
  currency text not null default 'ILS',
  status text not null default 'draft'
    check (status in ('draft', 'sent', 'signed', 'in_progress', 'completed', 'cancelled')),
  start_date date,
  due_date date,
  deliverables text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists payments (
  id uuid primary key default gen_random_uuid(),
  contract_id uuid not null references contracts(id) on delete cascade,
  amount numeric not null,
  due_date date,
  paid_date date,
  status text not null default 'pending'
    check (status in ('pending', 'paid', 'overdue', 'cancelled')),
  notes text,
  created_at timestamptz not null default now()
);

alter table clients enable row level security;
alter table contracts enable row level security;
alter table payments enable row level security;

create policy "allow all clients" on clients for all using (true) with check (true);
create policy "allow all contracts" on contracts for all using (true) with check (true);
create policy "allow all payments" on payments for all using (true) with check (true);
