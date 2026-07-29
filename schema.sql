-- מעקב הגעה — כפר יונה נוער
-- הרץ פעם אחת ב-Supabase (Project → SQL Editor → New query → Run)
-- זהו אותו פרויקט Supabase שכבר מחובר לאפליקציה (app.html).

create table if not exists players (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  position text,
  phone text,
  active boolean not null default true,
  photo_url text,
  foot text check (foot in ('right', 'left', 'both')),
  created_at timestamptz not null default now()
);

create table if not exists sessions (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  note text,
  created_at timestamptz not null default now()
);

create table if not exists attendance (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references sessions(id) on delete cascade,
  player_id uuid not null references players(id) on delete cascade,
  status text not null check (status in ('present', 'late', 'absent', 'vacation', 'sick', 'other')),
  note text,
  created_at timestamptz not null default now(),
  unique (session_id, player_id)
);

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

alter table players enable row level security;
alter table sessions enable row level security;
alter table attendance enable row level security;
alter table matches enable row level security;
alter table lineup enable row level security;

create policy "allow all players" on players for all using (true) with check (true);
create policy "allow all sessions" on sessions for all using (true) with check (true);
create policy "allow all attendance" on attendance for all using (true) with check (true);
create policy "allow all matches" on matches for all using (true) with check (true);
create policy "allow all lineup" on lineup for all using (true) with check (true);

-- אחסון תמונות פרופיל לשחקנים
insert into storage.buckets (id, name, public)
values ('player-photos', 'player-photos', true)
on conflict (id) do nothing;

create policy "public read player photos" on storage.objects for select using (bucket_id = 'player-photos');
create policy "anon upload player photos" on storage.objects for insert with check (bucket_id = 'player-photos');
create policy "anon update player photos" on storage.objects for update using (bucket_id = 'player-photos');
