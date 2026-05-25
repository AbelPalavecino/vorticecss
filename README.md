# Vortice CSS

Framework CSS utility-first. Sin build step, sin dependencias, sin configuración.

---

## Archivos

| Archivo | Rol | ¿Se toca por proyecto? |
|---------|-----|------------------------|
| `tokens.css` | Design tokens — primitivos + semánticos | ✅ Solo la Sección 1 |
| `reset.css` | Reset moderno — base predecible | ❌ Nunca |
| `base.css` | Tipografía base usando tokens | ❌ Nunca |
| `grid.css` | Sistema de grilla utility-first | ❌ Nunca |
| `utils.css` | Utilidades de spacing, display, tipografía | ❌ Nunca |

---

## Orden de carga

Este orden es obligatorio. Cambiarlo rompe el sistema.

```
1. reset.css
2. tokens.css         ← con los valores del proyecto
3. base.css
4. grid.css
5. utils.css
6. layout.css         ← específico del proyecto
7. components.css     ← específico del proyecto
```

---

## Cómo usar en un proyecto nuevo

### Opción A — Git submodule (recomendado)

```bash
# Dentro del proyecto
git submodule add https://github.com/abelo/vorticecss assets/css/vorticecss

# Para actualizar el framework en el futuro
git submodule update --remote
```

### Opción B — Copia directa

Copiar los archivos a `assets/css/vorticecss/` y cargarlos en el orden indicado.

---

## Personalizar para un proyecto

Solo se personaliza `tokens.css`. El resto es invariante.

**Sección 1 — Primitivos** (los únicos que cambian):
- Escala de color de 9 pasos
- Color de acento
- Familias tipográficas
- Las escalas de tamaño y espaciado raramente se tocan

```css
/* Ejemplo — proyecto con paleta azul */
:root {
  --_color-100: #eff6ff;
  --_color-500: #3b82f6;
  --_color-900: #1e3a8a;
  --_color-accent: #f59e0b;
  --_font-sans: 'Inter', system-ui, sans-serif;
}
```

**Sección 2 — Semánticos**: no modificar salvo decisión de diseño explícita.

---

## Sistema de grilla

```html
<!-- Grid básico -->
<div class="grid cols-3 gap-md">
  <div>...</div>
  <div>...</div>
  <div>...</div>
</div>

<!-- Responsive — mobile 1 col, tablet 2, desktop 3 -->
<div class="grid cols-1 md-cols-2 lg-cols-3 gap-md">
  ...
</div>

<!-- Auto-grid — ideal para productos -->
<div class="auto-grid gap-md">
  ...
</div>

<!-- Container -->
<div class="container">
  <!-- padding responsive incorporado, no requiere clases adicionales -->
</div>
```

## Utilidades frecuentes

```html
<!-- Spacing -->
<section class="py-section">
<div class="px-md py-lg">
<p class="mt-md mb-sm">

<!-- Flex -->
<div class="flex items-center justify-between gap-sm">

<!-- Stack vertical -->
<div class="stack">
  <p>Item 1</p>
  <p>Item 2</p>  <!-- margin-top automático -->
</div>

<!-- Tipografía -->
<h2 class="text-2xl font-bold text-center">
<p class="text-muted text-sm">

<!-- Display responsive -->
<nav class="none md-flex">  <!-- oculto en mobile, visible en tablet -->
```

---

## Breakpoints

| Prefijo | Breakpoint | Uso |
|---------|-----------|-----|
| *(sin prefijo)* | mobile first | base — siempre |
| `md-` | 768px | tablet portrait |
| `lg-` | 1024px | desktop |

```css
/* En archivos CSS propios del proyecto */
@media (min-width: 768px) { ... }
@media (min-width: 1024px) { ... }
```

---

## Convención de naming

- `--_nombre` — primitivo (prefijo `_` = uso interno, nunca en componentes)
- `--nombre` — semántico (uso libre)
- Clases utility: planas, sin BEM, sin modificadores con `--`
- Responsive: prefijo `md-` y `lg-`
