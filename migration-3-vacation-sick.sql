-- הרץ פעם אחת ב-Supabase SQL Editor
-- מחליף את "אחר" הכללי בשני סטטוסים נפרדים: חופשה (נספר כחיסרון) ומחלה/פציעה (מוצדק, לא נספר)
-- רשומות ישנות עם סטטוס "other" נשארות תקינות ונספרות כמו "חופשה" בדוחות

alter table attendance drop constraint if exists attendance_status_check;
alter table attendance add constraint attendance_status_check
  check (status in ('present', 'late', 'absent', 'vacation', 'sick', 'other'));
