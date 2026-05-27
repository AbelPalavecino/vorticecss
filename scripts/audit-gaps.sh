#!/usr/bin/env bash
# Analiza el estado del framework y produce docs/gap-report.md
# Compara cobertura actual vs target de utilidades, tokens y responsive

REPO="/Users/abelo/Documents/Webs/vorticecss"
REPORT="$REPO/docs/gap-report.md"
UTILS="$REPO/utils.css"
GRID="$REPO/grid.css"
TOKENS="$REPO/tokens.css"

DATE=$(date +%Y-%m-%d)

GAPS_HIGH=""
GAPS_MED=""
GAPS_LOW=""

# ─── FUNCIÓN DE CHEQUEO ───────────────────────────────────────────────────────
# check <archivo> <patron> <categoria> <prioridad> <descripcion> <ejemplo>
check() {
  local FILE="$1" PATTERN="$2" CAT="$3" PRI="$4" DESC="$5" EXAMPLE="$6"
  if ! grep -q "$PATTERN" "$FILE" 2>/dev/null; then
    local ENTRY="### $CAT\n$DESC\n\`\`\`css\n$EXAMPLE\n\`\`\`\n"
    case "$PRI" in
      alta)   GAPS_HIGH="$GAPS_HIGH\n$ENTRY" ;;
      media)  GAPS_MED="$GAPS_MED\n$ENTRY" ;;
      baja)   GAPS_LOW="$GAPS_LOW\n$ENTRY" ;;
    esac
  fi
}

# ─── UTILIDADES FALTANTES ─────────────────────────────────────────────────────

# Aspect ratio — crítico para imágenes en e-commerce
check "$UTILS" "aspect-square" \
  "Aspect Ratio" "alta" \
  "Esencial para product cards. Sin esto cada proyecto define sus propias clases de proporción." \
  ".aspect-auto   { aspect-ratio: auto; }
.aspect-square { aspect-ratio: 1 / 1; }
.aspect-video  { aspect-ratio: 16 / 9; }
.aspect-4-3    { aspect-ratio: 4 / 3; }"

# Opacity — una de las utilidades más usadas en UI
check "$UTILS" "opacity-" \
  "Opacity" "alta" \
  "Ausencia obliga a hardcodear opacity en cada componente. Crítico para estados hover/disabled." \
  ".opacity-0   { opacity: 0; }
.opacity-25  { opacity: 0.25; }
.opacity-50  { opacity: 0.5; }
.opacity-75  { opacity: 0.75; }
.opacity-100 { opacity: 1; }"

# Line clamp — esencial para grillas de producto con nombres largos
check "$UTILS" "line-clamp" \
  "Line Clamp" "alta" \
  "Sin esto los títulos de producto desbordan. Es la segunda utilidad más pedida en e-commerce." \
  ".line-clamp-1 { overflow: hidden; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; }
.line-clamp-2 { overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
.line-clamp-3 { overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; }"

# Background color utilities
check "$UTILS" "bg-default\|\.bg-" \
  "Background Colors" "alta" \
  "No hay clases .bg-* que consuman los tokens semánticos. Cada proyecto los define diferente." \
  ".bg-default  { background-color: var(--color-bg); }
.bg-subtle   { background-color: var(--color-bg-subtle); }
.bg-raised   { background-color: var(--color-bg-raised); }
.bg-cta      { background-color: var(--color-cta-bg); }"

# Object fit — para imágenes de producto
check "$UTILS" "object-cover" \
  "Object Fit" "alta" \
  "Sin esto las imágenes de producto no se recortan bien en contenedores de aspect-ratio fijo." \
  ".object-contain      { object-fit: contain; }
.object-cover        { object-fit: cover; }
.object-fill         { object-fit: fill; }
.object-none         { object-fit: none; }
.object-scale-down   { object-fit: scale-down; }"

# Border width — base para cards, inputs, tablas
check "$UTILS" "\.border\b\|border-0" \
  "Border Width" "alta" \
  "Sin clases .border no hay forma de agregar bordes con el sistema de tokens." \
  ".border-0  { border-width: 0; }
.border    { border: 1px solid var(--color-border); }
.border-2  { border: 2px solid var(--color-border); }
.border-t  { border-top: 1px solid var(--color-border); }
.border-r  { border-right: 1px solid var(--color-border); }
.border-b  { border-bottom: 1px solid var(--color-border); }
.border-l  { border-left: 1px solid var(--color-border); }"

# Outline / focus ring — accesibilidad de foco
check "$UTILS" "outline-none\|ring-" \
  "Outline / Focus Ring" "alta" \
  "Sin sistema de foco visible el framework no cumple WCAG 2.1 AA. Crítico para accesibilidad." \
  ".outline-none   { outline: none; }
.ring           { outline: 2px solid var(--color-cta-bg); outline-offset: 2px; }
.ring-offset-2  { outline-offset: 2px; }"

# Pointer events
check "$UTILS" "pointer-events" \
  "Pointer Events" "media" \
  "Necesario para overlays, loaders y elementos decorativos no interactivos." \
  ".pointer-events-none { pointer-events: none; }
.pointer-events-auto { pointer-events: auto; }"

# Whitespace
check "$UTILS" "whitespace-nowrap\|whitespace-" \
  "Whitespace" "media" \
  "Complemento necesario para .truncate. Sin .whitespace-nowrap no se puede forzar texto en una línea sin truncar." \
  ".whitespace-normal   { white-space: normal; }
.whitespace-nowrap   { white-space: nowrap; }
.whitespace-pre      { white-space: pre; }
.whitespace-pre-wrap { white-space: pre-wrap; }
.whitespace-pre-line { white-space: pre-line; }"

# Object position
check "$UTILS" "object-center\|object-position" \
  "Object Position" "media" \
  "Complemento de Object Fit. Sin esto las imágenes siempre se recortan desde el centro." \
  ".object-center { object-position: center; }
.object-top    { object-position: top; }
.object-bottom { object-position: bottom; }
.object-left   { object-position: left; }
.object-right  { object-position: right; }"

# Select
check "$UTILS" "select-none\|user-select" \
  "Select / User Select" "media" \
  "Necesario para elementos no interactivos y tooltips que no deben seleccionarse." \
  ".select-none { user-select: none; }
.select-text { user-select: text; }
.select-all  { user-select: all; }"

# Will change
check "$UTILS" "will-change" \
  "Will Change" "baja" \
  "Optimización de performance para elementos con animaciones o transforms frecuentes." \
  ".will-change-auto      { will-change: auto; }
.will-change-scroll    { will-change: scroll-position; }
.will-change-transform { will-change: transform; }"

# Resize
check "$UTILS" "\.resize" \
  "Resize" "baja" \
  "Para textareas y paneles redimensionables." \
  ".resize-none { resize: none; }
.resize      { resize: both; }
.resize-x    { resize: horizontal; }
.resize-y    { resize: vertical; }"

# ─── TOKENS FALTANTES ─────────────────────────────────────────────────────────

# Colores de estado — crítico para e-commerce
if ! grep -q 'color-success\|color-error\|color-warning' "$TOKENS" 2>/dev/null; then
  ENTRY="### Tokens de Estado (success / error / warning)\nSin tokens de estado cada proyecto define sus propios colores para formularios, alertas y badges. Rompe la consistencia entre proyectos.\n\`\`\`css\n/* En tokens.css — Sección 2 */\n--color-success:      #16a34a;\n--color-success-bg:   #f0fdf4;\n--color-error:        #dc2626;\n--color-error-bg:     #fef2f2;\n--color-warning:      #d97706;\n--color-warning-bg:   #fffbeb;\n\`\`\`\n"
  GAPS_HIGH="$GAPS_HIGH\n$ENTRY"
fi

# Spacing faltante — --_space-16 y --_space-32 sin mapear
if ! grep -q 'space-2xl\|space-3xl' "$TOKENS" 2>/dev/null; then
  ENTRY="### Tokens de Spacing — pasos 2xl y 3xl\n--_space-16 (64px) y --_space-32 (128px) existen como primitivos pero no tienen tokens semánticos. Se pierden dos pasos de la escala.\n\`\`\`css\n/* En tokens.css — Sección 2 */\n--space-2xl:     var(--_space-16);  /* 64px */\n--space-3xl:     var(--_space-32);  /* 128px */\n\`\`\`\n"
  GAPS_MED="$GAPS_MED\n$ENTRY"
fi

# ─── RESPONSIVE FALTANTE ──────────────────────────────────────────────────────

# sm- prefix (640px) — declarado en tokens pero sin clases
if ! grep -q '@media.*640px\|sm-' "$UTILS" "$GRID" 2>/dev/null; then
  ENTRY="### Breakpoint sm- (640px)\nDeclarado en tokens.css como referencia pero sin clases responsive. Genera expectativa falsa en quien lee los tokens.\n\`\`\`css\n@media (min-width: 640px) {\n  .sm-block  { display: block; }\n  .sm-hidden { display: none; }\n  .sm-flex   { display: flex; }\n  /* ... etc */\n}\n\`\`\`\n"
  GAPS_MED="$GAPS_MED\n$ENTRY"
fi

# xl- prefix (1280px) — mismo caso
if ! grep -q '@media.*1280px\|xl-' "$UTILS" "$GRID" 2>/dev/null; then
  ENTRY="### Breakpoint xl- (1280px)\nDeclarado en tokens como referencia pero sin clases. Proyectos wide (dashboards, landings) no pueden controlar layout en pantallas grandes.\n\`\`\`css\n@media (min-width: 1280px) {\n  .xl-cols-2 { grid-template-columns: repeat(2, 1fr); }\n  /* ... etc */\n}\n\`\`\`\n"
  GAPS_MED="$GAPS_MED\n$ENTRY"
fi

# ─── ACCESIBILIDAD FALTANTE ───────────────────────────────────────────────────

# prefers-reduced-motion
if ! grep -q 'prefers-reduced-motion' "$UTILS" "$REPO/base.css" 2>/dev/null; then
  ENTRY="### prefers-reduced-motion\nLas transiciones definidas en tokens.css no tienen fallback para usuarios que prefieren reducir movimiento. Requerido por WCAG 2.3.3.\n\`\`\`css\n@media (prefers-reduced-motion: reduce) {\n  *, *::before, *::after {\n    animation-duration: 0.01ms !important;\n    transition-duration: 0.01ms !important;\n  }\n}\n\`\`\`\n"
  GAPS_HIGH="$GAPS_HIGH\n$ENTRY"
fi

# ─── GENERAR REPORTE ──────────────────────────────────────────────────────────

{
  echo "# Gap Report — VorticeCSS"
  echo ""
  echo "> Generado: $DATE | Comparación contra target de cobertura utility-first"
  echo ""

  # Estadísticas actuales
  UTILS_COUNT=$(grep -c '^\.' "$UTILS" 2>/dev/null || echo 0)
  GRID_COUNT=$(grep -c '^\.' "$GRID" 2>/dev/null || echo 0)
  TOKENS_COUNT=$(grep -c '^\s*--[^_]' "$TOKENS" 2>/dev/null || echo 0)
  echo "## Estado actual"
  echo ""
  echo "| Archivo | Clases/Tokens |"
  echo "|---------|--------------|"
  echo "| utils.css | $UTILS_COUNT clases |"
  echo "| grid.css  | $GRID_COUNT clases |"
  echo "| tokens.css | $TOKENS_COUNT tokens semánticos |"
  echo ""

  if [ -n "$GAPS_HIGH" ]; then
    echo "---"
    echo ""
    echo "## Prioridad alta"
    echo ""
    printf "%b\n" "$GAPS_HIGH"
  fi

  if [ -n "$GAPS_MED" ]; then
    echo "---"
    echo ""
    echo "## Prioridad media"
    echo ""
    printf "%b\n" "$GAPS_MED"
  fi

  if [ -n "$GAPS_LOW" ]; then
    echo "---"
    echo ""
    echo "## Prioridad baja"
    echo ""
    printf "%b\n" "$GAPS_LOW"
  fi

  if [ -z "$GAPS_HIGH" ] && [ -z "$GAPS_MED" ] && [ -z "$GAPS_LOW" ]; then
    echo "## Sin gaps detectados"
    echo ""
    echo "El framework cubre todas las categorías del target. Revisá el target en scripts/audit-gaps.sh para expandirlo."
  fi

} > "$REPORT"

echo "Gap report generado en $REPORT"
cat "$REPORT"
