#!/usr/bin/env bash
# Orquesta un ciclo completo de crecimiento del framework.
#
# Uso:
#   scripts/grow.sh              → actualiza el gap report en la rama actual
#   scripts/grow.sh --branch     → crea rama grow/YYYY-MM-DD y actualiza el gap report
#   scripts/grow.sh --help       → muestra esta ayuda

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DATE=$(date +%Y-%m-%d)
BRANCH="grow/$DATE"

# ─── AYUDA ────────────────────────────────────────────────────────────────────
if [ "$1" = "--help" ]; then
  echo ""
  echo "grow.sh — Ciclo de crecimiento de VorticeCSS"
  echo ""
  echo "  sin flags    Actualiza gap report en rama actual"
  echo "  --branch     Crea rama grow/YYYY-MM-DD y actualiza gap report"
  echo ""
  echo "El gap report se guarda en docs/gap-report.md"
  echo "Una vez generado, pedile a Claude que implemente el gap de mayor prioridad."
  echo ""
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  VorticeCSS — Ciclo de crecimiento"
echo "  $DATE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ─── CREAR RAMA (opcional) ────────────────────────────────────────────────────
if [ "$1" = "--branch" ]; then
  CURRENT=$(git -C "$REPO" branch --show-current 2>/dev/null)
  if [ "$CURRENT" = "$BRANCH" ]; then
    echo "Ya estás en la rama $BRANCH"
  else
    echo "Creando rama $BRANCH..."
    git -C "$REPO" checkout -b "$BRANCH" 2>/dev/null || {
      echo "La rama $BRANCH ya existe. Cambiando a ella..."
      git -C "$REPO" checkout "$BRANCH"
    }
  fi
  echo ""
fi

# ─── EJECUTAR AUDIT ───────────────────────────────────────────────────────────
echo "Analizando gaps..."
echo ""
bash "$REPO/scripts/audit-gaps.sh"

# ─── RESULTADO ────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
BRANCH_CURRENT=$(git -C "$REPO" branch --show-current 2>/dev/null)
echo "  Rama: $BRANCH_CURRENT"
echo "  Reporte: docs/gap-report.md"
echo ""
echo "  Siguiente paso:"
echo "  Pedile a Claude que implemente el gap"
echo "  de mayor prioridad del reporte."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
