# Xavfsizlik — LAN uchun tekshiruv

Tarmoq: ichki (192.168.x.x), domain yo'q. RDS (tashqi Postgres) ishlatish mumkin.

---

## Hozirgi holat ✓

| Element | Holat | Xavf |
|---------|-------|------|
| Auth | ✓ ENABLE_AUTH=true | Kirish talab qilinadi |
| Signup | ✓ DISABLE_SIGNUP=true | Faqat admin invite |
| CORS | ✓ whitelist (3 ta origin) | CSRF cheklangan |
| JWT/Session | ✓ Alohida secrets | Cookie takrorlash qiyin |
| DB shifrlash | ✓ DATA_ENCRYPTION_KEY | Ma'lumotlar shifrlangan |
| Nginx headers | ✓ X-Frame, X-Content-Type | Clickjacking, MIME oldi olinadi |
| Postfix | ✓ 587 STARTTLS | App → SMTP shifrlangan |
| Postgres port | ✓ Faqat Docker ichida | Tashqidan ulanib bo'lmaydi |

---

## LAN uchun kam xavfli

| Element | Sabab |
|---------|-------|
| HTTPS | Tarmoq yopiq — HTTP yetarli |
| Domain | Ichki IP (192.168.x.x) kifoya |
| Rate limit | Ichki foydalanuvchilar — past ehtiyoj |

---

## Diqqat qilish kerak

### 1. Postgres — RDS ga o'tkazish

Agar AWS RDS yoki boshqa tashqi Postgres ishlatilsa:

```
DATABASE_URL=postgresql://user:pass@your-rds-endpoint.rds.amazonaws.com:5432/hoppscotch
```

- RDS Security Group: faqat app server IP dan 5432 ga ruxsat
- Parol kuchli bo'lsin
- SSL: `?sslmode=require` qo'shish mumkin

**Eslatma:** RDS ishlatilsa, `databases/postgres-config.yaml` dan postgres servisini olib tashlash yoki Makefile ni RDS uchun moslashtirish kerak.

### 2. Port 1080 (Mailcatcher)

Tarmoqdagilar http://192.168.0.106:1080 orqali boshqalarning magic linklarini ko'rishi mumkin.

**Postfix** ishlatilsa — haqiqiy pochta yuboriladi, 1080 da ko'rinmaydi. Mailcatcher faqat dev/test uchun.

### 3. .env va .gitignore

`.env` git ga commit qilinmasligi kerak. `.gitignore` da `.env` qo'shilgan.

### 4. Admin panel

`/admin` — login qilgan har kim kiradi. Hoppscotch da birinchi user admin bo'ladi. Ichki tarmoqda odatda yetarli.

---

## Xulosa

**LAN uchun hozirgi sozlash xavfsiz:** Auth, DISABLE_SIGNUP, CORS cheklovi, secrets, DB shifrlash yoqilgan. HTTPS va rate limit ichki tarmoqda majburiy emas.

**RDS ulash:** `DATABASE_URL` ni RDS endpoint ga o'zgartiring, postgres servisini stack dan olib tashlang.
