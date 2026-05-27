#!/usr/bin/env bash
# Disparado por: Stop (fin de turno de Claude)
# Propósito: sugerir la próxima feature de mayor impacto si hay cambios CSS pendientes

REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Solo disparar si hay archivos CSS modificados sin commitear en esta sesión
CHANGED_CSS=$(git -C "$REPO" diff --name-only HEAD 2>/dev/null | grep '\.css$' | wc -l | tr -d ' ')
STAGED_CSS=$(git -C "$REPO" diff --cached --name-only 2>/dev/null | grep '\.css$' | wc -l | tr -d ' ')
TOTAL=$(( ${CHANGED_CSS:-0} + ${STAGED_CSS:-0} ))

if [ "$TOTAL" -eq 0 ]; then
  exit 0
fi

# Recolectar estado actual del framework para dar contexto en el mensaje
UTILS_COUNT=$(grep -c '^\.' "$REPO/utils.css" 2>/dev/null | tr -d ' ')
GRID_COUNT=$(grep -c '^\.' "$REPO/grid.css" 2>/dev/null | tr -d ' ')
TOKENS_COUNT=$(grep -c '^\s*--' "$REPO/tokens.css" 2>/dev/null | tr -d ' ')
TOTAL_LINES=$(cat "$REPO"/*.css 2>/dev/null | wc -l | tr -d ' ')

jq -n \
  --arg utils "$UTILS_COUNT" \
  --arg grid "$GRID_COUNT" \
  --arg tokens "$TOKENS_COUNT" \
  --arg lines "$TOTAL_LINES" \
  --arg changed "$TOTAL" '
{
  "systemMessage": ("VorticeCSS — " + $changed + " archivo(s) CSS modificado(s).\nEstado: " + $utils + " clases utils · " + $grid + " grid · " + $tokens + " tokens · " + $lines + " líneas totales.\n\nPara análisis de crecimiento preguntá: ¿Qué construir a continuación para acercar VorticeCSS a Tailwind?")
}
'
