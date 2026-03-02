# Cheklovlar va sozlamalar

Hozirgi deployment dagi limitlar va cheklovlar.

---

## Auth

| Sozlama | Qiymat | Tavsif |
|---------|--------|--------|
| `ENABLE_AUTH` | `true` | Kirish talab qilinadi |
| `DISABLE_SIGNUP` | `false` | Ro'yxatdan o'tish ochiq — har kim qo'shilishi mumkin |
| `ALLOWED_AUTH_PROVIDERS` | `EMAIL` | Faqat magic link (OAuth yo'q) |

**O'zgartirish:** Admin → Auth sozlamalari yoki `.env` da `DISABLE_SIGNUP=true` — ro'yxatdan o'tishni yopish.

---

## CORS

| Sozlama | Qiymat | Tavsif |
|---------|--------|--------|
| `WHITELISTED_ORIGINS` | `*` | Barcha originlarga ruxsat — cheklov yo'q |

---

## Nginx

| Parametr | Qiymat | Tavsif |
|---------|--------|--------|
| `client_max_body_size` | 500M | So'rov body max 500 MB |
| `proxy_*_timeout` | 600s | Barcha proxy timeoutlar |

---

## Docker Swarm

| Servis | Replicas | Tavsif |
|--------|----------|--------|
| hoppscotch | 1 | Yagona instance |
| nginx | 1 | Yagona instance |
| postgres | 1 | Yagona DB |
| mailcatcher | 1 | Lokal SMTP mock |

**Yuqori yuk:** `services/config.yaml` da `replicas: 2` yoki undan ko'p — horizontal scaling.

---

## Pochta (Mailcatcher)

| Cheklov | Tavsif |
|---------|--------|
| Haqiqiy email yo'q | Mailcatcher faqat mock — xatlar 192.168.0.106:1080 da saqlanadi |
| Tarmoqda | Boshqa kompyuterlar http://192.168.0.106:1080 orqali magic link ko'rishi mumkin |

**Production:** Haqiqiy SMTP (Gmail, SendGrid, va hokazo) sozlash kerak — `.env` da `MAILER_USE_CUSTOM_CONFIGS=true`, `MAILER_SMTP_URL=smtps://...`.

---

## HTTPS

| Sozlama | Qiymat | Tavsif |
|---------|--------|--------|
| `ALLOW_SECURE_COOKIES` | `false` | HTTP — HTTPS yo'q |
| URL lar | `http://` | SSL/TLS ishlatilmayapti |

**Production:** Nginx oldida Let's Encrypt (Certbot) yoki boshqa reverse proxy (Traefik, Caddy) orqali HTTPS qo'shish kerak.

---

## Hoppscotch Community Edition

Rasmiy limitlar (ilova darajasida):

- **Team/workspace:** Community Edition da team va workspace funksiyalari mavjud
- **Foydalanuvchilar:** Cheksiz (DB va resurslar yetadi)
- **Request limit:** Ilova ichida rate limit yo'q (nginx/app darajasida alohida sozlash kerak)

---

## Nginx boshqasi

| Parametr | Qiymat | Tavsif |
|----------|--------|--------|
| `worker_connections` | 1024 | Bir worker uchun max ulanishlar |

---

## Postgres

| Parametr | Qiymat | Tavsif |
|----------|--------|--------|
| `max_connections` | 500 | Simultaneous ulanishlar max |

Storage: `volumes/postgres` bind mount hajmiga bog'liq.

---

## Xulosa

| Yo'nalish | Hozirgi holat | Tavsiya |
|-----------|---------------|---------|
| Ro'yxatdan o'tish | Ochiq | Kerak bo'lmasa `DISABLE_SIGNUP=true` |
| Body size | 500 MB | ✓ |
| Timeout | 600s | ✓ |
| HTTPS | Yo'q | Production uchun qo'shish |
| SMTP | Mailcatcher (mock) | Production uchun haqiqiy SMTP |
| Scaling | 1 replica | Yuqori yuk uchun replicas oshirish |
