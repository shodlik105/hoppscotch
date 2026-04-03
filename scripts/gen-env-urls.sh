#!/usr/bin/env bash
# .env dan PUBLIC_ORIGIN va PUBLIC_PATH o'qib Hoppscotch uchun .env.urls yaratadi.
# To'liq .env ni source qilmaymiz (paroldagi maxsus belgilar buzilmasin).

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo "gen-env-urls: .env topilmadi. cp .env.example .env va PUBLIC_ORIGIN / PUBLIC_PATH ni to'ldiring." >&2
  exit 1
fi

read_env_val() {
  local key="$1"
  local line
  line="$(grep -E "^${key}=" .env | tail -n1 || true)"
  [[ -n "$line" ]] || return 1
  printf '%s' "${line#*=}"
}

ORIGIN="$(read_env_val PUBLIC_ORIGIN)" || ORIGIN=""
PATH_SEG="$(read_env_val PUBLIC_PATH)" || PATH_SEG=""

if [[ -z "$ORIGIN" || -z "$PATH_SEG" ]]; then
  echo "gen-env-urls: .env da PUBLIC_ORIGIN va PUBLIC_PATH (masalan hoppscotch) bo'sh bo'lmasligi kerak." >&2
  exit 1
fi

ORIGIN="${ORIGIN%/}"
PATH_SEG="${PATH_SEG#/}"
PATH_SEG="${PATH_SEG%/}"
BASE="${ORIGIN}/${PATH_SEG}"

WS_ORIGIN="$(printf '%s' "$ORIGIN" | sed -e 's|^http://|ws://|' -e 's|^https://|wss://|')"

umask 077
cat > .env.urls <<EOF
# Avtomatik: scripts/gen-env-urls.sh — qo'lda tahrirlamang
PUBLIC_URL=${BASE}
ORIGIN=${ORIGIN}
REDIRECT_URL=${BASE}/
NUXT_APP_BASE_URL=/${PATH_SEG}/
VITE_BASE_URL=${BASE}
VITE_SHORTCODE_BASE_URL=${BASE}
VITE_ADMIN_URL=${BASE}/admin
VITE_BACKEND_GQL_URL=${BASE}/backend/graphql
VITE_BACKEND_WS_URL=${WS_ORIGIN}/${PATH_SEG}/backend/graphql
VITE_BACKEND_API_URL=${BASE}/backend/v1
EOF

echo "gen-env-urls: .env.urls yangilandi (PUBLIC_URL=${BASE})"
