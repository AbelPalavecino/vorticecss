#!/usr/bin/env bash
# Disparado por: Stop
# Propósito: commitear cambios en rama agent/feature al finalizar sesión y volver a main

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DATE=$(date +%Y-%m-%d)

# Sin cambios → no hacer nada
if [ -z "$(git -C "$REPO" status --porcelain 2>/dev/null)" ]; then
  exit 0
fi

# Solo desde main — no tocar ramas manuales
CURRENT=$(git -C "$REPO" branch --show-current 2>/dev/null)
if [ "$CURRENT" != "main" ]; then
  exit 0
fi

# ─── DERIVAR NOMBRE DEL FEATURE ───────────────────────────────────────────────

FEATURE=""

# Caso 1: una sola sección nueva en utils.css → nombre específico
NEW_SECTIONS=$(git -C "$REPO" diff -- utils.css 2>/dev/null \
  | grep -E '^\+[[:space:]]+[0-9]+\.' | wc -l | tr -d ' ')

if [ "${NEW_SECTIONS:-0}" -eq 1 ]; then
  FEATURE=$(git -C "$REPO" diff -- utils.css 2>/dev/null \
    | grep -E '^\+[[:space:]]+[0-9]+\.' \
    | sed -E 's/^\+[[:space:]]+[0-9]+\.[[:space:]]*//' \
    | tr '[:upper:]' '[:lower:]' \
    | tr -s ' /()\·—' '-' \
    | tr -cd 'a-z0-9-' \
    | sed 's/-*$//')
elif [ "${NEW_SECTIONS:-0}" -gt 1 ]; then
  FEATURE="utils-$DATE"
fi

# Caso 2: tokens nuevos en tokens.css
if [ -z "$FEATURE" ]; then
  if git -C "$REPO" diff -- tokens.css 2>/dev/null | grep -qE '^\+[[:space:]]+--'; then
    FEATURE="tokens-$DATE"
  fi
fi

# Caso 3: solo docs / scripts
[ -z "$FEATURE" ] && FEATURE="$DATE"

# ─── NOMBRE DE RAMA ÚNICO ─────────────────────────────────────────────────────

BRANCH="feat/$FEATURE"

if git -C "$REPO" show-ref --verify --quiet "refs/heads/$BRANCH" 2>/dev/null; then
  N=2
  while git -C "$REPO" show-ref --verify --quiet "refs/heads/${BRANCH}-${N}" 2>/dev/null; do
    N=$((N + 1))
  done
  BRANCH="${BRANCH}-${N}"
fi

# ─── CREAR RAMA, COMMITEAR, VOLVER A MAIN ─────────────────────────────────────

git -C "$REPO" checkout -b "$BRANCH" 2>/dev/null
git -C "$REPO" add -A 2>/dev/null

# Mensaje de commit: feature + archivos CSS tocados
CHANGED_CSS=$(git -C "$REPO" diff --cached --name-only 2>/dev/null \
  | grep '\.css$' | xargs -I{} basename {} 2>/dev/null | tr '\n' ' ' | sed 's/ $//')
COMMIT_MSG="feat: $FEATURE"
[ -n "$CHANGED_CSS" ] && COMMIT_MSG="$COMMIT_MSG — $CHANGED_CSS"

git -C "$REPO" commit -m "$COMMIT_MSG" 2>/dev/null

# Volver a main limpio para la próxima sesión
git -C "$REPO" checkout main 2>/dev/null

echo "{\"systemMessage\": \"Commiteado en $BRANCH — main limpio para la próxima sesión.\"}"
