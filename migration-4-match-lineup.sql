-- הרץ פעם אחת ב-Supabase SQL Editor
-- טבלאות חדשות עבור "הרכב למשחק" — סגל + מיקום שחקנים על מגרש דיגיטלי

create table if not exists matches (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  opponent text,
  note text,
  created_at timestamptz not null default now()
);

create table if not exists lineup (
  id uuid primary key default gen_random_uuid(),
  match_id uuid not null references matches(id) on delete cascade,
  player_id uuid not null references players(id) on delete cascade,
  x real,
  y real,
  created_at timestamptz not null default now(),
  unique (match_id, player_id)
);

alter table matches enable row level security;
alter table lineup enable row level security;

create policy "allow all matches" on matches for all using (true) with check (true);
create policy "allow all lineup" on lineup for all using (true) with check (true);
