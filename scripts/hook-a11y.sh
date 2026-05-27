#!/usr/bin/env bash
# Disparado por: PostToolUse en Edit|Write
# Propósito: inyectar contexto para evaluación de accesibilidad WCAG 2.1 AA

FILE=$(jq -r '.tool_input.file_path // ""')

if ! echo "$FILE" | grep -qE '\.css$' || echo "$FILE" | grep -q '/docs/'; then
  exit 0
fi

# Capturar el contenido del archivo para análisis contextual
CONTENT=$(cat "$FILE" 2>/dev/null)

jq -n --arg file "$(basename "$FILE")" --arg content "$CONTENT" '
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": ("ACCESIBILIDAD — VorticeCSS: Evaluá las implicaciones WCAG 2.1 AA del cambio en " + $file + ". Revisá:\n\n1. CONTRASTE: ¿Las combinaciones de color text/bg cumplen ratio mínimo 4.5:1 para texto normal, 3:1 para texto grande y UI?\n2. FOCO: ¿Todos los elementos interactivos (a, button, input) tienen :focus-visible con indicador visible? ¿Se está usando outline: none sin alternativa?\n3. MOVIMIENTO: ¿Las transiciones respetan @media (prefers-reduced-motion)?\n4. COLOR SOLO: ¿Se usa color como único medio para comunicar información?\n5. TAMAÑO MÍNIMO: ¿Los targets interactivos tienen mínimo 44x44px de área táctil?\n\nSi detectás un problema potencial, marcalo con [A11Y ⚠] y explicá el impacto. Si todo está bien, no es necesario mencionarlo.\n\nContenido actual del archivo:\n" + $content)
  }
}
'
