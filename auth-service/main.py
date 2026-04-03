"""
Hoppscotch uchun email+parol autentifikatsiya mikroservisi.
Full path routing — nginx prefix stripping yo'q.
"""

import os
import time
import uuid

import bcrypt
import jwt
import asyncpg
from fastapi import FastAPI, APIRouter, Form, Request, Response
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates

app = FastAPI(title="Hoppscotch Password Auth")
templates = Jinja2Templates(directory="/app/templates")

# ── Config ────────────────────────────────────────────────────────────────────
DATABASE_URL   = os.environ["DATABASE_URL"]
JWT_SECRET     = os.environ["JWT_SECRET"]
VITE_BASE_URL  = os.environ.get("VITE_BASE_URL", "")
SECURE_COOKIES = os.environ.get("ALLOW_SECURE_COOKIES", "false").lower() == "true"
APP_PREFIX     = os.environ.get("PUBLIC_PATH", "hoppscotch")
ACCESS_EXPIRY  = int(os.environ.get("ACCESS_TOKEN_EXPIRY_HOURS", "24"))
REFRESH_EXPIRY = int(os.environ.get("REFRESH_TOKEN_EXPIRY_DAYS", "7"))

BASE_PATH = f"/{APP_PREFIX}/password-auth"

# ── DB ────────────────────────────────────────────────────────────────────────
pool: asyncpg.Pool = None

@app.on_event("startup")
async def startup():
    global pool
    pool = await asyncpg.create_pool(DATABASE_URL, min_size=2, max_size=10)

@app.on_event("shutdown")
async def shutdown():
    await pool.close()

# ── JWT helpers ───────────────────────────────────────────────────────────────
def make_token(uid: str, expiry_hours: int) -> str:
    now = int(time.time())
    payload = {
        "iss": VITE_BASE_URL,
        "sub": uid,
        "aud": [VITE_BASE_URL],
        "iat": now,
        "exp": now + expiry_hours * 3600,
    }
    return jwt.encode(payload, JWT_SECRET, algorithm="HS256")

def set_auth_cookies(response: Response, uid: str):
    access  = make_token(uid, ACCESS_EXPIRY)
    refresh = make_token(uid, REFRESH_EXPIRY * 24)
    opts = dict(httponly=True, samesite="lax", secure=SECURE_COOKIES, path="/")
    response.set_cookie("access_token",  access,  **opts)
    response.set_cookie("refresh_token", refresh, **opts)

# ── Router (full paths) ───────────────────────────────────────────────────────
router = APIRouter(prefix=BASE_PATH)

@router.get("", include_in_schema=False)
@router.get("/", include_in_schema=False)
async def root_redirect():
    return RedirectResponse(f"{BASE_PATH}/login", status_code=302)

@router.get("/login", response_class=HTMLResponse)
async def login_page(request: Request, error: str = ""):
    return templates.TemplateResponse("login.html", {
        "request": request,
        "error": error,
        "prefix": APP_PREFIX,
        "mode": "signin",
    })

@router.get("/signup", response_class=HTMLResponse)
async def signup_page(request: Request, error: str = ""):
    return templates.TemplateResponse("login.html", {
        "request": request,
        "error": error,
        "prefix": APP_PREFIX,
        "mode": "signup",
    })

@router.post("/login")
async def login(
    request: Request,
    email: str = Form(...),
    password: str = Form(...),
):
    async with pool.acquire() as conn:
        row = await conn.fetchrow(
            'SELECT uid, "passwordHash" FROM "User" WHERE email = $1',
            email,
        )

    if not row or not row["passwordHash"]:
        return RedirectResponse(
            f"{BASE_PATH}/login?error=Email+yoki+parol+noto%27g%27ri",
            status_code=303,
        )

    if not bcrypt.checkpw(password.encode(), row["passwordHash"].encode()):
        return RedirectResponse(
            f"{BASE_PATH}/login?error=Email+yoki+parol+noto%27g%27ri",
            status_code=303,
        )

    response = RedirectResponse(f"/{APP_PREFIX}/", status_code=303)
    set_auth_cookies(response, row["uid"])
    return response

@router.post("/signup")
async def signup(
    request: Request,
    email: str = Form(...),
    password: str = Form(...),
    confirm_password: str = Form(...),
):
    if password != confirm_password:
        return RedirectResponse(
            f"{BASE_PATH}/signup?error=Parollar+mos+kelmadi",
            status_code=303,
        )

    if len(password) < 8:
        return RedirectResponse(
            f"{BASE_PATH}/signup?error=Parol+kamida+8+ta+belgi",
            status_code=303,
        )

    password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

    async with pool.acquire() as conn:
        existing = await conn.fetchrow(
            'SELECT uid, "passwordHash" FROM "User" WHERE email = $1',
            email,
        )

        if existing:
            if existing["passwordHash"]:
                return RedirectResponse(
                    f"{BASE_PATH}/signup?error=Bu+email+allaqachon+ro%27yxatdan+o%27tgan",
                    status_code=303,
                )
            uid = existing["uid"]
            await conn.execute(
                'UPDATE "User" SET "passwordHash" = $1 WHERE uid = $2',
                password_hash, uid,
            )
        else:
            uid = str(uuid.uuid4()).replace("-", "")
            await conn.execute(
                'INSERT INTO "User"(uid, email, "passwordHash", "createdOn") '
                'VALUES($1, $2, $3, now())',
                uid, email, password_hash,
            )

    response = RedirectResponse(f"/{APP_PREFIX}/", status_code=303)
    set_auth_cookies(response, uid)
    return response

@router.get("/health")
async def health():
    return {"status": "ok"}

app.include_router(router)
