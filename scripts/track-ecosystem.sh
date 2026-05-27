#!/usr/bin/env bash
# Disparado por: cron semanal (lunes junto a grow.sh)
# Propósito: rastrear novedades de Tailwind, MDN y web.dev
#            y volcarlas a docs/ecosystem-radar.md

REPO="$(cd "$(dirname "$0")/.." && pwd)"
RADAR="$REPO/docs/ecosystem-radar.md"
DATE=$(date +%Y-%m-%d)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  VorticeCSS — Ecosystem Radar"
echo "  $DATE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ─── TAILWIND — ÚLTIMA VERSIÓN ────────────────────────────────────────────────
echo "Consultando Tailwind..."
TW_DATA=$(curl -s --max-time 10 "https://api.github.com/repos/tailwindlabs/tailwindcss/releases/latest" 2>/dev/null)
TW_VERSION=$(echo "$TW_DATA" | jq -r '.tag_name // "N/A"' 2>/dev/null)
TW_DATE=$(echo "$TW_DATA"    | jq -r '.published_at // ""' 2>/dev/null | cut -c1-10)
TW_BODY=$(echo "$TW_DATA"    | jq -r '.body // ""' 2>/dev/null | head -40)

# ─── MDN BLOG — ÚLTIMAS NOTAS ─────────────────────────────────────────────────
echo "Consultando MDN..."
MDN_TITLES=$(curl -s --max-time 10 "https://developer.mozilla.org/en-US/blog/rss.xml" 2>/dev/null \
  | grep -oE '<title>[^<]+</title>' \
  | sed 's/<title>//;s/<\/title>//' \
  | sed "s/&apos;/'/g;s/&amp;/\&/g;s/&quot;/\"/g" \
  | grep -v '^MDN Blog$' | head -5)

# ─── WEB.DEV — ÚLTIMAS PUBLICACIONES ─────────────────────────────────────────
echo "Consultando web.dev..."
WEBDEV_TITLES=$(curl -sL --max-time 10 "https://web.dev/static/blog/feed.xml" 2>/dev/null \
  | sed -n 's/.*<title><!\[CDATA\[\(.*\)\]\]><\/title>.*/\1/p' | head -5)

# ─── ESCRIBIR ENTRADA EN EL RADAR ─────────────────────────────────────────────

# Inicializar archivo si no existe
if [ ! -f "$RADAR" ]; then
  cat > "$RADAR" << 'EOF'
# Ecosystem Radar — VorticeCSS

Rastreo semanal automático de Tailwind, MDN y web.dev.
Actualizado cada lunes. Fuentes manuales listadas al final.

---

EOF
fi

{
  echo "## $DATE"
  echo ""

  echo "### Tailwind CSS — $TW_VERSION (publicado: $TW_DATE)"
  echo ""
  if [ -n "$TW_BODY" ] && [ "$TW_BODY" != "null" ]; then
    echo "$TW_BODY"
  else
    echo "_Sin notas de release disponibles._"
  fi
  echo ""

  echo "### MDN — últimas publicaciones"
  echo ""
  if [ -n "$MDN_TITLES" ]; then
    echo "$MDN_TITLES" | while IFS= read -r line; do echo "- $line"; done
  else
    echo "_No se pudo obtener el feed._"
  fi
  echo ""

  echo "### web.dev — últimas publicaciones"
  echo ""
  if [ -n "$WEBDEV_TITLES" ]; then
    echo "$WEBDEV_TITLES" | while IFS= read -r line; do echo "- $line"; done
  else
    echo "_No se pudo obtener el feed._"
  fi
  echo ""
  echo "---"
  echo ""
} >> "$RADAR"

echo ""
echo "Radar actualizado → docs/ecosystem-radar.md"
echo "Tailwind: $TW_VERSION ($TW_DATE)"
