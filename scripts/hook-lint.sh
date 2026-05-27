#!/usr/bin/env bash
# Disparado por: PostToolUse en Edit|Write
# Propósito: validar convenciones de código CSS (sin hardcoded values, sin !important, sin BEM)

FILE=$(jq -r '.tool_input.file_path // ""')

if ! echo "$FILE" | grep -qE '\.css$' || echo "$FILE" | grep -q '/docs/'; then
  exit 0
fi

ISSUES=""

# 1. Colores hardcodeados fuera de tokens.css
#    Solo la Sección 1 de tokens.css puede tener hex/rgb/hsl
if ! echo "$FILE" | grep -q 'tokens.css'; then
  FOUND=$(grep -nE '(#[0-9a-fA-F]{3,8}|rgba?\([^)]+\)|hsla?\([^)]+\))' "$FILE" 2>/dev/null | grep -v '^\s*//')
  if [ -n "$FOUND" ]; then
    ISSUES="$ISSUES
⚠ COLORES HARDCODEADOS — solo permitidos en tokens.css Sección 1. Usá var(--_color-*):
$FOUND
"
  fi
fi

# 2. !important — rompe la especificidad del sistema de capas
FOUND=$(grep -n '!important' "$FILE" 2>/dev/null | grep -v '^\s*//')
if [ -n "$FOUND" ]; then
  ISSUES="$ISSUES
⚠ USO DE !important — rompe la especificidad intencional del sistema de capas:
$FOUND
"
fi

# 3. Nomenclatura BEM en archivos de utilidades y grilla
#    Este framework usa clases planas. Los modificadores BEM (--) están prohibidos.
if echo "$FILE" | grep -qE '(utils|grid|base)\.css$'; then
  FOUND=$(grep -n '\.[a-zA-Z][a-zA-Z0-9-]*--[a-zA-Z]' "$FILE" 2>/dev/null | grep -v '^\s*//')
  if [ -n "$FOUND" ]; then
    ISSUES="$ISSUES
⚠ NOMENCLATURA BEM — este framework usa clases planas, sin modificadores '--':
$FOUND
"
  fi
fi

# 4. font-size, padding y margin en px hardcodeados
#    Deben referenciar tokens. Excluye border widths (1px-3px son válidos).
if ! echo "$FILE" | grep -q 'tokens.css'; then
  FOUND=$(grep -nE '(font-size|padding|margin|gap):\s*[0-9]+(px)' "$FILE" 2>/dev/null | grep -v '^\s*//' | grep -v 'var(')
  if [ -n "$FOUND" ]; then
    ISSUES="$ISSUES
⚠ VALORES PX HARDCODEADOS — usá tokens: var(--space-*) para spacing, var(--_size-*) para tipografía:
$FOUND
"
  fi
fi

if [ -n "$ISSUES" ]; then
  jq -n --arg ctx "LINT — VorticeCSS detectó problemas en $(basename "$FILE"):
$ISSUES
Corregí estos problemas para mantener la coherencia del sistema de diseño antes de continuar." \
    '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":$ctx}}'
fi
