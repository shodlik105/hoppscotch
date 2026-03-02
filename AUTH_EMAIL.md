# EMAIL + Mailcatcher — Login sozlash

Mailcatcher `make services-up` bilan ishga tushadi (1080 — web, 1025 — SMTP).

---

## 1. Admin onboarding

**http://192.168.0.106:3300/admin** oching.

### Step 1 — Auth method

- **EMAIL** ni tanlang
- **Continue** bosing

### Step 2 — Add Configurations (SMTP)

Quyidagilarni kiriting:

| Maydon         | Qiymat                          |
|----------------|----------------------------------|
| **Address From** | `noreply@hoppscotch.local`       |
| **SMTP URL**     | `smtp://mailcatcher:1025`        |
| **Use Custom Configs** | Oʻchiring (unchecked) |

**Save Auth Config** bosing.

---

## 2. Login (magic link)

1. **http://192.168.0.106:3300** oching
2. **Login** → **Continue with Email**
3. Istalgan email kiriting (masalan: `test@example.com`)
4. **Send Magic Link** bosing

---

## 3. Magic link olish

Mailcatcher haqiqiy pochta yubormaydi. Link lokal qabul qilgichda chiqadi:

👉 **http://192.168.0.106:1080**

1. Shu sahifani oching
2. Yangi xatni ko‘ring (Magic link)
3. Linkni bosib yoki nusxalab brauzerga yoping
4. Kirish amalga oshadi

---

## 4. Keyingi loginlar

- Sessiya saqlanadi
- Chiqib kirsangiz — yana email + magic link (http://192.168.0.106:1080)
