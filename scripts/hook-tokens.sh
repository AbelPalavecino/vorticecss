#!/usr/bin/env bash
# Disparado por: PostToolUse en Edit|Write
# Propósito: validar la integridad del sistema de tokens en dos capas

FILE=$(jq -r '.tool_input.file_path // ""')

if ! echo "$FILE" | grep -qE '\.css$' || echo "$FILE" | grep -q '/docs/'; then
  exit 0
fi

ISSUES=""

# 1. Primitivos (--_*) solo deben aparecer en tokens.css
#    Si aparecen en base, grid o utils, se está rompiendo la arquitectura de capas.
if echo "$FILE" | grep -qE '(base|grid|utils|reset)\.css$'; then
  FOUND=$(grep -n 'var(--_' "$FILE" 2>/dev/null | grep -v '^\s*//')
  if [ -n "$FOUND" ]; then
    ISSUES="$ISSUES
⚠ PRIMITIVOS EXPUESTOS — los tokens --_* solo pueden usarse dentro de tokens.css.
  En $(basename "$FILE") deben usarse los tokens semánticos (sin prefijo _):
$FOUND
"
  fi
fi

# 2. En tokens.css: los semánticos no deben referenciar otros semánticos (sin cadenas)
#    Un semántico solo puede referenciar un primitivo directamente.
if echo "$FILE" | grep -q 'tokens.css'; then
  # Buscar semánticos que referencian semánticos (var(--nombre) donde nombre no tiene guión bajo)
  FOUND=$(grep -nE 'var\(--[^_][^)]+\)' "$FILE" 2>/dev/null | grep -v '^\s*//' | grep ':' | grep -v 'var(--_')
  if [ -n "$FOUND" ]; then
    ISSUES="$ISSUES
⚠ CADENA DE TOKENS — un token semántico referencia otro semántico (en vez de un primitivo).
  Esto puede causar loops o valores indefinidos en proyectos que customicen la Sección 1:
$FOUND
"
  fi
fi

# 3. En base.css, grid.css, utils.css: todos los valores CSS deben usar var()
#    No deben quedar valores literales que deberian ser tokens.
if echo "$FILE" | grep -qE '(base|grid|utils)\.css$'; then
  # Buscar valores numéricos que claramente deberían ser tokens (rem, em sin var)
  FOUND=$(grep -nE ':\s+[0-9]+(\.[0-9]+)?(rem|em)' "$FILE" 2>/dev/null | grep -v '^\s*//' | grep -v 'var(')
  if [ -n "$FOUND" ]; then
    ISSUES="$ISSUES
⚠ VALORES REM/EM HARDCODEADOS — usá tokens tipográficos: var(--size-*) o var(--leading-*):
$FOUND
"
  fi
fi

if [ -n "$ISSUES" ]; then
  jq -n --arg ctx "TOKENS — VorticeCSS detectó violaciones al sistema de tokens en $(basename "$FILE"):
$ISSUES
El sistema de dos capas (primitivos → semánticos) es la arquitectura central del framework. Corregí antes de continuar." \
    '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":$ctx}}'
fi
