# Gap Report — VorticeCSS

> Generado: 2026-05-27 | Comparación contra target de cobertura utility-first

## Estado actual

| Archivo | Clases/Tokens |
|---------|--------------|
| utils.css | 113 clases |
| grid.css  | 56 clases |
| tokens.css | 56 tokens semánticos |

---

## Prioridad alta


### Aspect Ratio
Esencial para product cards. Sin esto cada proyecto define sus propias clases de proporción.
```css
.aspect-auto   { aspect-ratio: auto; }
.aspect-square { aspect-ratio: 1 / 1; }
.aspect-video  { aspect-ratio: 16 / 9; }
.aspect-4-3    { aspect-ratio: 4 / 3; }
```

### Opacity
Ausencia obliga a hardcodear opacity en cada componente. Crítico para estados hover/disabled.
```css
.opacity-0   { opacity: 0; }
.opacity-25  { opacity: 0.25; }
.opacity-50  { opacity: 0.5; }
.opacity-75  { opacity: 0.75; }
.opacity-100 { opacity: 1; }
```

### Line Clamp
Sin esto los títulos de producto desbordan. Es la segunda utilidad más pedida en e-commerce.
```css
.line-clamp-1 { overflow: hidden; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; }
.line-clamp-2 { overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
.line-clamp-3 { overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; }
```

### Background Colors
No hay clases .bg-* que consuman los tokens semánticos. Cada proyecto los define diferente.
```css
.bg-default  { background-color: var(--color-bg); }
.bg-subtle   { background-color: var(--color-bg-subtle); }
.bg-raised   { background-color: var(--color-bg-raised); }
.bg-cta      { background-color: var(--color-cta-bg); }
```

### Object Fit
Sin esto las imágenes de producto no se recortan bien en contenedores de aspect-ratio fijo.
```css
.object-contain      { object-fit: contain; }
.object-cover        { object-fit: cover; }
.object-fill         { object-fit: fill; }
.object-none         { object-fit: none; }
.object-scale-down   { object-fit: scale-down; }
```

### Border Width
Sin clases .border no hay forma de agregar bordes con el sistema de tokens.
```css
.border-0  { border-width: 0; }
.border    { border: 1px solid var(--color-border); }
.border-2  { border: 2px solid var(--color-border); }
.border-t  { border-top: 1px solid var(--color-border); }
.border-r  { border-right: 1px solid var(--color-border); }
.border-b  { border-bottom: 1px solid var(--color-border); }
.border-l  { border-left: 1px solid var(--color-border); }
```

### Outline / Focus Ring
Sin sistema de foco visible el framework no cumple WCAG 2.1 AA. Crítico para accesibilidad.
```css
.outline-none   { outline: none; }
.ring           { outline: 2px solid var(--color-cta-bg); outline-offset: 2px; }
.ring-offset-2  { outline-offset: 2px; }
```

### Tokens de Estado (success / error / warning)
Sin tokens de estado cada proyecto define sus propios colores para formularios, alertas y badges. Rompe la consistencia entre proyectos.
```css
/* En tokens.css — Sección 2 */
--color-success:      #16a34a;
--color-success-bg:   #f0fdf4;
--color-error:        #dc2626;
--color-error-bg:     #fef2f2;
--color-warning:      #d97706;
--color-warning-bg:   #fffbeb;
```

### prefers-reduced-motion
Las transiciones definidas en tokens.css no tienen fallback para usuarios que prefieren reducir movimiento. Requerido por WCAG 2.3.3.
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Prioridad media


### Pointer Events
Necesario para overlays, loaders y elementos decorativos no interactivos.
```css
.pointer-events-none { pointer-events: none; }
.pointer-events-auto { pointer-events: auto; }
```

### Whitespace
Complemento necesario para .truncate. Sin .whitespace-nowrap no se puede forzar texto en una línea sin truncar.
```css
.whitespace-normal   { white-space: normal; }
.whitespace-nowrap   { white-space: nowrap; }
.whitespace-pre      { white-space: pre; }
.whitespace-pre-wrap { white-space: pre-wrap; }
.whitespace-pre-line { white-space: pre-line; }
```

### Object Position
Complemento de Object Fit. Sin esto las imágenes siempre se recortan desde el centro.
```css
.object-center { object-position: center; }
.object-top    { object-position: top; }
.object-bottom { object-position: bottom; }
.object-left   { object-position: left; }
.object-right  { object-position: right; }
```

### Select / User Select
Necesario para elementos no interactivos y tooltips que no deben seleccionarse.
```css
.select-none { user-select: none; }
.select-text { user-select: text; }
.select-all  { user-select: all; }
```

### Tokens de Spacing — pasos 2xl y 3xl
--_space-16 (64px) y --_space-32 (128px) existen como primitivos pero no tienen tokens semánticos. Se pierden dos pasos de la escala.
```css
/* En tokens.css — Sección 2 */
--space-2xl:     var(--_space-16);  /* 64px */
--space-3xl:     var(--_space-32);  /* 128px */
```

### Breakpoint sm- (640px)
Declarado en tokens.css como referencia pero sin clases responsive. Genera expectativa falsa en quien lee los tokens.
```css
@media (min-width: 640px) {
  .sm-block  { display: block; }
  .sm-hidden { display: none; }
  .sm-flex   { display: flex; }
  /* ... etc */
}
```

### Breakpoint xl- (1280px)
Declarado en tokens como referencia pero sin clases. Proyectos wide (dashboards, landings) no pueden controlar layout en pantallas grandes.
```css
@media (min-width: 1280px) {
  .xl-cols-2 { grid-template-columns: repeat(2, 1fr); }
  /* ... etc */
}
```

---

## Prioridad baja


### Will Change
Optimización de performance para elementos con animaciones o transforms frecuentes.
```css
.will-change-auto      { will-change: auto; }
.will-change-scroll    { will-change: scroll-position; }
.will-change-transform { will-change: transform; }
```

### Resize
Para textareas y paneles redimensionables.
```css
.resize-none { resize: none; }
.resize      { resize: both; }
.resize-x    { resize: horizontal; }
.resize-y    { resize: vertical; }
```

