-- הרץ פעם אחת ב-Supabase SQL Editor
-- מוסיף תמיכה בתמונת פרופיל לכל שחקן

alter table players add column if not exists photo_url text;

-- אחסון (Storage) לתמונות
insert into storage.buckets (id, name, public)
values ('player-photos', 'player-photos', true)
on conflict (id) do nothing;

create policy "public read player photos" on storage.objects for select using (bucket_id = 'player-photos');
create policy "anon upload player photos" on storage.objects for insert with check (bucket_id = 'player-photos');
create policy "anon update player photos" on storage.objects for update using (bucket_id = 'player-photos');
