# EMAIL + Mailcatcher — Login sozlash

Mailcatcher `make services-up` bilan ishga tushadi (1080 — web, 1025 — SMTP).

---

## 1. Admin onboarding

**`.env` dagi `PUBLIC_ORIGIN` + `/hoppscotch/admin`** oching (masalan gateway: `http://192.168.63.218:7000/hoppscotch/admin`).  
To‘g‘ridan-to‘g‘ri DC nginx: `http://SERVER:3300/hoppscotch/admin`.

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

1. Asosiy ilova URL (`PUBLIC_ORIGIN` + `/hoppscotch/`) ni oching
2. **Login** → **Continue with Email**
3. Istalgan email kiriting (masalan: `test@example.com`)
4. **Send Magic Link** bosing

---

## 3. Magic link olish

Mailcatcher haqiqiy pochta yubormaydi. Link lokal qabul qilgichda chiqadi:

👉 **Gateway orqali:** `PUBLIC_ORIGIN` + `/mailcatcher/` (masalan `http://192.168.63.218:7000/mailcatcher/`)  
👉 **Yoki** serverda to‘g‘ridan: `http://SERVER:1080`

1. Shu sahifani oching
2. Yangi xatni ko‘ring (Magic link)
3. Linkni bosib yoki nusxalab brauzerga yoping
4. Kirish amalga oshadi

---

## 4. Keyingi loginlar

- Sessiya saqlanadi
- Chiqib kirsangiz — yana email + magic link (`/mailcatcher/` yoki `:1080`)
