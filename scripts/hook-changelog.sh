#!/usr/bin/env bash
# Disparado por: PostToolUse en Edit|Write
# Propósito: recordar actualizar docs/changelog.md después de cualquier cambio al proyecto
# Cubre: .css, .sh, .json, .md (excepto los docs mismos)

FILE=$(jq -r '.tool_input.file_path // ""')

if echo "$FILE" | grep -qE '\.(css|sh|json)$' && ! echo "$FILE" | grep -q '/docs/'; then
  echo '{
    "hookSpecificOutput": {
      "hookEventName": "PostToolUse",
      "additionalContext": "RECORDATORIO — VorticeCSS: Acabás de modificar un archivo CSS. Antes de terminar el turno, actualizá docs/changelog.md. Formato obligatorio:\n\n## YYYY-MM-DD\n\n**Nombre del cambio** tipo\nDescripción funcional de qué cambió y por qué.\n\nTipos disponibles: nuevo / mejora / fix / decisión\nNo describas qué archivos editaste — describí qué cambió funcionalmente."
    }
  }'
fi
