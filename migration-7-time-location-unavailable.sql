-- הרץ פעם אחת ב-Supabase SQL Editor
-- מוסיף: שעה + מיקום לאימונים, וסטטוס זמינות מתמשך לשחקן (פציעה/מחלה/חופשה)

alter table sessions add column if not exists time text;
alter table sessions add column if not exists location text;

alter table players add column if not exists unavailable_reason text;
alter table players drop constraint if exists players_unavailable_reason_check;
alter table players add constraint players_unavailable_reason_check
  check (unavailable_reason in ('injury', 'sick', 'vacation', 'other'));
alter table players add column if not exists unavailable_until date;
alter table players add column if not exists unavailable_note text;
