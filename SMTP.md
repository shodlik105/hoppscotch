# O'z SMTP serveri (Postfix)

Postfix `make services-up` bilan ishga tushadi. Port 587 (STARTTLS).

## Sozlash

### 1. Hoppscotch ni Postfix ga ulash

`.env` da:

```
MAILER_SMTP_URL=smtp://postfix:587
MAILER_ADDRESS_FROM=noreply@hoppscotch.local
```

### 2. Yuboruvchi domen

```
ALLOWED_SENDER_DOMAINS=hoppscotch.local
```

Production uchun o'z domeningiz: `ALLOWED_SENDER_DOMAINS=yourdomain.com`

### 3. Relay (ixtiyoriy)

Postfix to'g'ridan-to'g'ri yuboradi. Agar ISP 25-bloklasa yoki spam bo'lsa — Gmail/SendGrid orqali relay:

```
RELAYHOST=smtp.gmail.com:587
RELAYHOST_USERNAME=your@gmail.com
RELAYHOST_PASSWORD=app-password
```

Gmail: [App password](https://myaccount.google.com/apppasswords) yarating.

## Variantlar

| Variant | MAILER_SMTP_URL | Xususiyat |
|---------|-----------------|-----------|
| Mailcatcher | `smtp://mailcatcher:1025` | xatlarni http://192.168.0.106:1080 da ko'rish |
| Postfix (o'z) | `smtp://postfix:587` | STARTTLS, to'g'ridan-to'g'ri yoki relay |
| Tashqi (Gmail) | `smtps://user:pass@smtp.gmail.com:465` | MAILER_USE_CUSTOM_CONFIGS=true |
