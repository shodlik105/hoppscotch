# Volumes — ma'lumotlar saqlash joyi

Loyiha papkasida bind mount orqali saqlanadi.

| Papka       | Maqsad                          | Servis     |
|-------------|---------------------------------|------------|
| postgres/   | PostgreSQL ma'lumotlar bazasi   | postgres   |
| hoppscotch/ | App data (logs, cache, uploads) | hoppscotch |
| mailcatcher/| Qabul qilingan xatlar (SQLite)  | mailcatcher|

**Eslatma:** `docker stack rm hoppscotch` qilsangiz ham ma'lumotlar saqlanadi. To'liq o'chirish uchun `volumes/*` papkalarni o'chiring.
