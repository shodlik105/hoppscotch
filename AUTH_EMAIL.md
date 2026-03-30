# EMAIL + Mailcatcher — Login sozlash (Gateway orqali)

Hoppscotch gateway orqali ishlaydi:

- Hoppscotch: **http://172.16.80.8:7000/hoppscotch/**
- Admin panel: **http://172.16.80.8:7000/hoppscotch/admin**
- Mailcatcher (Web UI): **http://172.16.80.8:7000/mailcatcher/**

Mailcatcher container ichida:
- Web UI: 1080 (ichki)
- SMTP: 1025 (ichki)

Tashqaridan faqat gateway (7000) ishlatiladi.

---

## 1. Admin onboarding

**http://172.16.80.8:7000/hoppscotch/admin** oching.

### Step 1 — Auth method
- **EMAIL** ni tanlang
- **Continue** bosing

### Step 2 — Add Configurations (SMTP)

Quyidagilarni kiriting:

| Maydon | Qiymat |
|--------|--------|
| **Address From** | `noreply@hoppscotch.local` |
| **SMTP URL** | `smtp://mailcatcher:1025` |
| **Use Custom Configs** | Oʻchiring (unchecked) |

**Save Auth Config** bosing.

---

## 2. Login (magic link)

1. **http://172.16.80.8:7000/hoppscotch/** oching
2. **Login** → **Continue with Email**
3. Istalgan email kiriting (masalan: `test@example.com`)
4. **Send Magic Link** bosing

---

## 3. Magic link olish

Mailcatcher haqiqiy pochta yubormaydi. Link gateway orqali chiqadi:

👉 **http://172.16.80.8:7000/mailcatcher/**

1. Shu sahifani oching
2. Yangi xatni ko‘ring (Magic link)
3. Linkni bosib yoki nusxalab brauzerga yoping
4. Kirish amalga oshadi

---

## 4. Keyingi loginlar

- Sessiya saqlanadi
- Chiqib kirsangiz — yana email + magic link  
  (**http://172.16.80.8:7000/mailcatcher/**)
