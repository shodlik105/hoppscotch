# Hoppscotch Self-Host (Docker Swarm)

## Talablar

- Docker, Docker Swarm (`docker swarm init` qilingan boʻlishi kerak)
- Hoppscotch image: `hoppscotch/hoppscotch`

## Ishga tushirish

```bash
cp .env.example .env
# .env: parollar, JWT, va PUBLIC_ORIGIN / PUBLIC_PATH (brauzerdagi manzil)

make postgres-up    # Postgres
make migrates-up   # Prisma migrate (postgres tayyor boʻlsin)
make services-up   # .env.urls generatsiya + app, nginx, mailcatcher
```

**Brauzer manzili:** `PUBLIC_ORIGIN` — foydalanuvchi **qaysi URL dan** ochadi (odatda gateway, masalan `http://192.168.63.218:7000`). Datacenterdagi `172.16.80.8:3300` faqat ichki nginx; unda emas, gateway orqali kirasiz. `PUBLIC_PATH=hoppscotch` → `.../hoppscotch/admin`, `.../hoppscotch/...`. Mailcatcher: `.../mailcatcher/` (shu gateway hostida). `make services-up` `scripts/gen-env-urls.sh` bilan `VITE_*` / `REDIRECT_URL` ni `.env.urls` ga yozadi.

**CORS:** `WHITELISTED_ORIGINS=*` — `Origin` bo‘yicha cheklov yo‘q; tarmoqni o‘zingiz yopasiz.

## Arxitektura

| Servis     | Tavsif                           |
|------------|----------------------------------|
| postgres   | PostgreSQL 16                    |
| hoppscotch | App (backend + frontend)         |
| nginx      | Reverse proxy, 3300 → 80         |
| mailcatcher| SMTP mock (1080 — web, 1025 — SMTP) |
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

## Tarmoq: datacenter + tashqi gateway

| Qatlam | Tavsif |
|--------|--------|
| Swarm nginx (DC) | Masalan `172.16.80.8:3300` — **`/hoppscotch/`**, **`/mailcatcher/`** |
| Gateway | Masalan `192.168.63.218:7000` — brauzer shu yerda; `.env` da **`PUBLIC_ORIGIN=http://192.168.63.218:7000`** |

**`PUBLIC_ORIGIN`** — mijoz `scheme://host:port` (gateway). **Tashqi nginx** `Host`, `X-Forwarded-Host` (`$http_host`), `X-Forwarded-Proto`, `X-Forwarded-Port` uzatishi kerak. Namuna: [docs/gateway-front.conf.example](docs/gateway-front.conf.example).

Subpathni o‘zgartirsangiz (`PUBLIC_PATH`), `nginx.conf` dagi `hoppscotch` location bilan bir xil qiling.

## VM / tarmoqda (LAN)

Gateway ishlatmasangiz: `PUBLIC_ORIGIN=http://SERVER:3300`, `PUBLIC_PATH=hoppscotch`, `make services-up`.

## Parolni oʻzgartirish

Postgres parolini `.env` da oʻzgartirsangiz, mavjud volume eski parol bilan qoladi. Yangilash uchun:

```bash
docker stack rm hoppscotch
# volumes/postgres ni oʻchiring (sudo kerak boʻlishi mumkin)
# make postgres-up, migrates-up, services-up
```

## Auth (EMAIL + magic link)

Asosiy ilova: `PUBLIC_ORIGIN` + `/hoppscotch/` (masalan `http://192.168.63.218:7000/hoppscotch/`)  
Admin: `.../hoppscotch/admin` → Onboarding → SMTP: `smtp://mailcatcher:1025`  
Mailcatcher: shu gateway da `.../mailcatcher/` (ichki `:1080` ham mavjud)

Batafsil: [AUTH_EMAIL.md](AUTH_EMAIL.md)

## Cheklovlar

Limitlar, sozlamalar va production tavsiyalari: [LIMITS.md](LIMITS.md)
