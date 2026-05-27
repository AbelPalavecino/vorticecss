#!/usr/bin/env bash
# Disparado por: SessionStart
# Propósito: inyectar solo los 3 gaps de mayor prioridad al iniciar sesión
#            (versión conservadora — evita inyectar el reporte completo)

REPORT="/Users/abelo/Documents/Webs/vorticecss/docs/gap-report.md"
RADAR="/Users/abelo/Documents/Webs/vorticecss/docs/ecosystem-radar.md"

if [ ! -f "$REPORT" ] || [ ! -s "$REPORT" ]; then
  exit 0
fi

if ! grep -q "## Prioridad alta" "$REPORT" 2>/dev/null; then
  exit 0
fi

# Extraer solo los primeros 3 títulos de gaps de prioridad alta
TOP3=$(awk '
  /^## Prioridad alta/ { in_section=1; count=0; next }
  /^## Prioridad / && !/alta/ { in_section=0 }
  in_section && /^### / {
    count++
    if (count <= 3) print $0
    if (count == 3) exit
  }
' "$REPORT")

if [ -z "$TOP3" ]; then
  exit 0
fi

# Contar total de gaps para dar contexto sin mandar todo el reporte
TOTAL_HIGH=$(grep -c "^### " <<< "$(awk '/^## Prioridad alta/{f=1} /^## Prioridad media/{f=0} f' "$REPORT")" 2>/dev/null || echo "?")
TOTAL_MED=$(grep -c "^### " <<< "$(awk '/^## Prioridad media/{f=1} /^## Prioridad baja/{f=0} f' "$REPORT")" 2>/dev/null || echo "?")

# Verificar si hay novedades en el radar (actualizado en los últimos 7 días)
RADAR_NOTICE=""
if [ -f "$RADAR" ] && [ -n "$(find "$RADAR" -mtime -7 2>/dev/null)" ]; then
  TW_VERSION=$(grep -oE 'Tailwind CSS — v[0-9]+\.[0-9]+\.[0-9]+' "$RADAR" | tail -1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')
  if [ -n "$TW_VERSION" ]; then
    RADAR_NOTICE="\n\nEcosystem radar actualizado — Tailwind $TW_VERSION. Revisá docs/ecosystem-radar.md para novedades."
  fi
fi

jq -n --arg top3 "$TOP3" --arg high "$TOTAL_HIGH" --arg med "$TOTAL_MED" --arg radar "$RADAR_NOTICE" '
  {
    "hookSpecificOutput": {
      "hookEventName": "SessionStart",
      "additionalContext": ("VorticeCSS — gaps pendientes: " + $high + " alta prioridad · " + $med + " media.\n\nTop 3 para implementar:\n" + $top3 + "\n\nReporte completo en docs/gap-report.md. Implementá cuando el usuario lo indique." + $radar)
    }
  }
'
