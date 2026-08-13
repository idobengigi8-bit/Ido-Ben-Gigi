-- הרץ פעם אחת ב-Supabase SQL Editor
-- מוסיף סימון "תזכורת נשלחה" לשחקן בטאב "ציוד ותשלום"

alter table players add column if not exists reminder_sent boolean not null default false;
