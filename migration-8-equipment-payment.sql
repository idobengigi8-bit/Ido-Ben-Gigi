-- הרץ פעם אחת ב-Supabase SQL Editor
-- מוסיף מספר חולצה, מידה, וסטטוס תשלום לכל שחקן (טאב "ציוד ותשלום")

alter table players add column if not exists jersey_number text;
alter table players add column if not exists jersey_size text;
alter table players add column if not exists paid boolean not null default false;
