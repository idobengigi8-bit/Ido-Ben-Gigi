-- הרץ פעם אחת ב-Supabase SQL Editor (אצלך הטבלאות כבר קיימות, זו רק תוספת)
-- מוסיף סטטוס "אחר" (חופשה/מחלה/פציעה) + שדה הערה חופשית לכל רשומת נוכחות

alter table attendance add column if not exists note text;

alter table attendance drop constraint if exists attendance_status_check;
alter table attendance add constraint attendance_status_check
  check (status in ('present', 'late', 'absent', 'other'));
