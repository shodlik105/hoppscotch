# Proxy (Interceptor) — Proxyscotch

Hoppscotch da **Interceptor** uchta rejimga ega: **Browser**, **Proxy**, **Agent**.

## "Proxy server may be unresponsive" xatosi

Interceptor **Proxy** rejimida bo'lsa, so'rovlar Hoppscotch cloud proxy (`proxy.hoppscotch.io`) orqali yuboriladi. Self-host da bu proxy tarmoqdan erishilmasligi yoki bloklangan bo'lishi mumkin — shunda "Proxy server may be unresponsive" xatosi chiqadi.

---

## Yechimlar

### 1. Browser yoki Agent rejimini ishlatish (eng oson)

**Browser** — brauzer to'g'ridan-to'g'ri API ga so'rov yuboradi. CORS ruxsat bersa ishlaydi.

**Agent** — [Hoppscotch Agent](https://hoppscotch.com/download) desktop ilovasini o'rnating. Agent mahalliy proxy sifatida ishlaydi va CORS cheklovsiz ishlaydi.

Sozlash: Interceptor bo'limida **Browser** yoki **Agent** ni tanlang.

---

### 2. O'z Proxyscotch (stack da mavjud)

`make services-up` bilan **proxyscotch** servisi ham ishga tushadi. Nginx `/proxy/` orqali eksponatsiya qiladi.

**Muhim:** `hoppscotch/hoppscotch` rasmiy image proxy URL ni build vaqtida `proxy.hoppscotch.io` ga o'rnatadi. Runtime da o'zgartirish imkoni yo'q.

Agar source'dan o'zingiz build qilsangiz, `.env` da:
```
VITE_PROXY_URL=http://192.168.0.106:3300/proxy
```
(o'z IP ingizni yozing)

---

### 3. Proxyscotch sozlamalari

`services/config.yaml` da:
- **Image:** `hoppscotch/proxyscotch:v0.1.4`
- **Port:** 9159 (Docker ichida)
- **Nginx:** `http://192.168.0.106:3300/proxy/`

`.env` da ixtiyoriy:
```
PROXYSCOTCH_ALLOWED_ORIGINS=http://192.168.0.106:3300,http://127.0.0.1:3300
```
(bo'sh qoldirilsa `*` — barcha originlarga ruxsat)

---

## Xulosa

**Hozirgi stack:** Proxyscotch qo'shilgan, `/proxy/` route mavjud. Lekin rasmiy Docker image o'z proxy URL dan foydalanadi.

**Tavsiya:** Interceptor ni **Browser** yoki **Agent** ga o'zgartiring — tez va ishonchli ishlaydi.
