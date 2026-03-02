# Hoppscotch Self-Host (Docker Swarm)

## Talablar

- Docker, Docker Swarm (`docker swarm init` qilingan boʻlishi kerak)
- Hoppscotch image: `hoppscotch/hoppscotch`

## Ishga tushirish

```bash
cp .env.example .env
# .env ni tahrirlang (parol, URL, secrets)

make postgres-up    # Postgres
make migrates-up   # Prisma migrate (postgres tayyor boʻlsin)
make services-up   # App, nginx, mailcatcher
```

## Arxitektura

| Servis     | Tavsif                           |
|------------|----------------------------------|
| postgres   | PostgreSQL 16                    |
| hoppscotch | App (backend + frontend)         |
| nginx      | Reverse proxy, 3300 → 80         |
| mailcatcher| SMTP mock (1080 — web, 1025 — SMTP) |
| postfix    | O'z SMTP (587, STARTTLS)             |
| migrate    | Prisma migrate (bir marta, keyin 0/1) |

## Fayl tuzilishi

```
databases/postgres-config.yaml   # Postgres
services/config.yaml              # hoppscotch, nginx, mailcatcher
migrates/migrate-config.yaml      # Prisma migrate
volumes/postgres/                 # DB (bind)
volumes/hoppscotch/               # App data (bind)
volumes/mailcatcher/              # Mailcatcher xatlar (bind)
nginx.conf
.env
```

## Oʻchirish

```bash
docker stack rm hoppscotch
```

## VM / tarmoqda (LAN)

Tarmoqda boshqa foydalanuvchilar kirishi uchun `.env` da `localhost` o‘rniga VM IP ni yozing:

- `VITE_BASE_URL`, `VITE_SHORTCODE_BASE_URL`, `VITE_ADMIN_URL` → `http://192.168.0.106:3300` (o‘z IP ingiz)
- `VITE_BACKEND_GQL_URL`, `VITE_BACKEND_API_URL` → `http://192.168.0.106:3300/backend/...`
- `VITE_BACKEND_WS_URL` → `ws://192.168.0.106:3300/backend/graphql`
- `REDIRECT_URL` → `http://192.168.0.106:3300`

`WHITELISTED_ORIGINS=*` bo‘lsa barcha clientlar kirishi mumkin.

## Parolni oʻzgartirish

Postgres parolini `.env` da oʻzgartirsangiz, mavjud volume eski parol bilan qoladi. Yangilash uchun:

```bash
docker stack rm hoppscotch
# volumes/postgres ni oʻchiring (sudo kerak boʻlishi mumkin)
# make postgres-up, migrates-up, services-up
```

## Auth (EMAIL + magic link)

Admin: http://localhost:3300/admin → Onboarding → SMTP: `smtp://mailcatcher:1025`  
Magic link: http://localhost:1080 (Mailcatcher web UI)

Batafsil: [AUTH_EMAIL.md](AUTH_EMAIL.md)

## O'z SMTP (Postfix)

Postfix ham `make services-up` bilan ishga tushadi. `.env` da `MAILER_SMTP_URL=smtp://postfix:587` qiling. Batafsil: [SMTP.md](SMTP.md)

## Cheklovlar

Limitlar, sozlamalar va production tavsiyalari: [LIMITS.md](LIMITS.md)
