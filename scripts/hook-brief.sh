#!/usr/bin/env bash
# Disparado por: PostToolUse en Edit|Write
# Propósito: recordar actualizar docs/brief.md si el cambio implica una decisión arquitectural
# Cubre: .css, .sh, .json (excepto los docs mismos)

FILE=$(jq -r '.tool_input.file_path // ""')

if echo "$FILE" | grep -qE '\.(css|sh|json)$' && ! echo "$FILE" | grep -q '/docs/'; then
  echo '{
    "hookSpecificOutput": {
      "hookEventName": "PostToolUse",
      "additionalContext": "RECORDATORIO — VorticeCSS: Si el cambio que acabás de hacer implica una decisión de arquitectura, un nuevo patrón, un cambio en convenciones o en el contexto global del proyecto, actualizá docs/brief.md en la sección correspondiente:\n- Sección 7: decisiones de producto, arquitectura o diseño\n- Sección 6: cambios de estado del proyecto o nueva deuda técnica\n- Sección 9: gotchas o restricciones nuevas detectadas"
    }
  }'
fi
