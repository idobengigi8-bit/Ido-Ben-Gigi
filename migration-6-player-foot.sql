-- הרץ פעם אחת ב-Supabase SQL Editor
-- מוסיף רגל חזקה (ימין/שמאל/שתי הרגליים) לכל שחקן

alter table players add column if not exists foot text;
alter table players drop constraint if exists players_foot_check;
alter table players add constraint players_foot_check check (foot in ('right', 'left', 'both'));
