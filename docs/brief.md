# Brief del proyecto — VorticeCSS

---

## 1. El cliente / Contexto

**Nombre:** Abel Palavecino  
**Rubro:** Desarrollo frontend / Herramientas para developers  
**Ubicación:** Argentina  
**Contacto:** dg.palavecino@gmail.com

Framework CSS utility-first de uso propio, diseñado para ser la base de proyectos de e-commerce (principalmente WooCommerce) y sitios estáticos. No es un producto para venta ni distribución masiva — es una base de trabajo interna que se reutiliza como git submodule en proyectos de clientes.

---

## 2. Modelo de negocio / Tipo de proyecto

- Tipo: framework / herramienta interna
- Alcance: solo developers (uso propio o equipo)

**Canales de contacto digital:**
- Git: repositorio local con distribución por submodule

**Presencia online:**
- Repo: `/Users/abelo/Documents/Webs/vorticecss`

---

## 3. Objetivo del proyecto

Tipo: **Framework CSS**

Construir un framework CSS tan poderoso como Tailwind — o más — pero con personalidad propia: sin build step, sin dependencias, con un sistema de tokens real y coherencia visual garantizada entre proyectos.

Tailwind es la referencia de cobertura y ergonomía. VorticeCSS apunta a igualar su utilidad práctica mientras resuelve lo que Tailwind no resuelve: theming real por proyecto via CSS custom properties, dark mode nativo sin configuración, y una escala de tokens semánticos que da coherencia sin hardcodear valores.

El éxito se mide por: **poder construir cualquier interfaz real sin salir del framework — igual que con Tailwind, pero sin Node, sin build, y con identidad visual propia.**

---

## 4. Funcionalidades / Features

| Feature | Descripción |
|---------|-------------|
| Reset | Base neutral entre browsers, moderna (text-wrap, font smoothing) |
| Design tokens | Dos capas: primitivos (`--_`) y semánticos. Solo la capa primitiva se personaliza por proyecto |
| Base | Estilos tipográficos y de formulario que consumen tokens semánticos |
| Sistema de grilla | Grid explícita, auto-grid responsive, flex, stack, container con variantes |
| Utilidades | Spacing, tipografía, display, posición, z-index, sombras, bordes, cursor, responsive |
| Dark mode | Se activa con `data-theme="dark"` en `<html>` o `<body>`, cubre superficie y texto |
| WooCommerce ready | `ul.products` usa auto-grid por defecto |
| Pipeline de calidad (scripts/) | Hook pipeline post-edición: lint → tokens → changelog → brief. Se ejecuta en Claude Code automáticamente |
| Sistema de gap analysis | `audit-gaps.sh` analiza 13 categorías de utilidades y genera `docs/gap-report.md` priorizado |
| Ciclo de crecimiento (grow.sh) | Orquesta rama `grow/YYYY-MM-DD`, corre audit y establece siguiente paso con Claude |

**Notas críticas:**
- El proyecto consumidor agrega sus propios `layout.css` y `components.css`
- Solo se modifica la Sección 1 de `tokens.css` por proyecto (primitivos)
- Las secciones 2 y 3 de `tokens.css` y todos los demás archivos son intocables

---

## 5. Usuarios objetivo

| Perfil | Comportamiento | Punto de entrada |
|--------|---------------|------------------|
| Developer frontend (propio) | Clona como submodule, personaliza tokens, extiende con layout.css y components.css | Proyecto nuevo |
| Developer colaborador eventual | Lee README, respeta el orden de carga y el contrato de extensión | README del repo |

Todos terminan en: **proyecto con base visual coherente sin escribir CSS base desde cero**

---

## 6. Fase y estado del proyecto

**Fase actual:** v1.0 + infraestructura de calidad  
**Próximo paso:** Implementar gaps de alta prioridad del gap-report.md  
**Deadline:** Sin fecha definida

### Implementado
- reset.css — reset moderno completo
- tokens.css — primitivos + semánticos + dark mode + referencia de breakpoints
- base.css — estilos de HTML elements con tokens
- grid.css — container, grid, auto-grid, flex, stack, gap, responsive (md-, lg-)
- utils.css — display, visibilidad, overflow, posición, z-index, spacing, tipografía, bordes, sombras, cursor, responsive
- docs/brief.md y docs/changelog.md — documentación del proyecto activa
- scripts/ — pipeline de calidad (lint, tokens, changelog, brief, growth, session-start)
- scripts/audit-gaps.sh + scripts/grow.sh — sistema de gap analysis y ciclo de crecimiento
- docs/gap-report.md — análisis de gaps generado (9 alta, 6 media, 2 baja prioridad)
- Cron semanal (lunes 8am) para actualizar gap report automáticamente
- docs/ecosystem-radar.md + scripts/track-ecosystem.sh — rastreo semanal de Tailwind, MDN y web.dev
- Gaps alta prioridad implementados: aspect-ratio, opacity, line-clamp, bg colors, object-fit, border-width, focus ring, tokens de estado, prefers-reduced-motion

### Pendiente (fase actual)
- Documentar contrato de extensión (qué convenciones aplicar en layout.css y components.css)
- Corregir inconsistencia: `.rounded` sin sufijo debería ser `.rounded-md`
- Implementar prefijos responsive `sm-` y `xl-` o eliminarlos de la definición de breakpoints
- Mapear tokens semánticos para `--_space-16` (64px) y `--_space-32` (128px)
- Implementar gaps de media prioridad: pointer-events, whitespace, object-position, select, breakpoints sm-/xl-, tokens --space-2xl/3xl

### Pendiente (fase siguiente)
- Dark mode para tokens de estado (success/error/warning) — actualmente solo tienen variante light
- Dark mode para tokens de CTA/acción
- Implementar breakpoints sm- (640px) y xl- (1280px) como clases responsive

### Deuda técnica
- **Breakpoints sm/xl sin implementar:** Los tokens definen 4 breakpoints (sm, md, lg, xl) pero solo md y lg generan clases responsive — genera expectativa falsa; resolver antes de primer uso colaborativo
- **Dark mode incompleto en CTAs:** `--color-cta-bg` y `--color-cta-hover` no tienen variante dark — puede generar contraste inaccesible; resolver al agregar el primer proyecto con dark mode real
- **Escala de spacing con pasos huérfanos:** `--_space-16` (64px) y `--_space-32` (128px) existen como primitivos sin token semántico asignado
- **Ausencia de tokens de estado de interacción:** disabled, focus-visible, error, success no están definidos — cada proyecto los define diferente

---

## 7. Decisiones tomadas

### Producto / Negocio
- **Sin build step ni dependencias:** Reduce fricción de adopción en proyectos legados, WordPress y ambientes sin Node. El trade-off (sin tree-shaking, sin variables dinámicas) es aceptable para el alcance del framework.
- **Distribución como git submodule:** Permite actualizaciones centralizadas sin duplicar código en cada proyecto consumidor.
- **Pipeline de automatización en Claude Code (no CI externo):** Los hooks de calidad viven en `.claude/settings.json` y se ejecutan dentro de la sesión de Claude Code. Decisión: reducir fricción de setup (no requiere GitHub Actions, no requiere Node). Trade-off: solo se ejecutan durante sesiones activas, no en cada push.
- **Conservación de tokens de Claude como restricción de diseño:** El sistema de hooks se diseña para minimizar el texto enviado al contexto de Claude. Se evita enviar contenido de archivos completos en hooks automáticos; se usa `systemMessage` (visible al usuario, sin costo de tokens) para información de estado.
- **Gap analysis como motor de crecimiento:** En lugar de roadmap manual, el framework se auto-audita y genera un reporte priorizado de lo que falta. El ciclo es: audit → implementar gap de mayor prioridad → audit. La referencia de cobertura es Tailwind — el objetivo es igualarlo o superarlo sin build step ni dependencias.
- **Auto-commit con `feat/` al finalizar sesión:** El hook `Stop` commitea automáticamente en una rama `feat/feature-name` y vuelve a main limpio. El prefijo es `feat/` (convención estándar) — no `agent/` — porque el trabajo vale por lo que implementa, no por quién lo hizo. Abel revisa la rama y mergea a main cuando está conforme.

### Arquitectura técnica
- **CSS custom properties en vez de preprocesadores:** Nativo en browser, no requiere compilación, permite dark mode real y override por scope sin capas adicionales.
- **Dos capas de tokens (primitivos + semánticos):** Los primitivos con prefijo `--_` son la fuente de verdad de los valores; los semánticos son el vocabulario de uso. Esto permite cambiar toda la identidad visual solo modificando la Sección 1 de tokens.css.
- **No BEM:** Las clases son planas, sin modificadores con `--`. La especificidad se controla por capas (reset → tokens → base → grid → utils → layout → components).
- **Mobile-first con prefijos md- y lg-:** El default es mobile, los breakpoints se activan explícitamente. Se priorizan md (768px) y lg (1024px) como los más usados en proyectos reales.
- **Auto-grid con `auto-fill + minmax()`:** Responsive sin media queries para grillas de productos. Evita definir columnas por breakpoint en el caso más común.
- **Stack pattern con `* + *`:** Evita margin collapsing y es más semántico que agregar clases en cada hijo de una columna vertical.

### Diseño
- **Escala de colores en 9 pasos (100–900):** Un solo tono parametrizable. Los proyectos mapean sus colores de marca a esta escala editando solo los primitivos.
- **Razón tipográfica 1.25 (Major Third):** Escala moderada, legible, sin saltos dramáticos entre pasos.
- **Grid de espaciado base 4px:** Compatible con la mayoría de sistemas de diseño actuales (Figma, Material, Tailwind).
- **`text-wrap: balance` en headings, `text-wrap: pretty` en párrafos:** Mejora tipográfica nativa sin JS, aprovechando soporte moderno de browsers (2023+).

---

## 7b. Roadmap hacia paridad con Tailwind

El objetivo es poder construir cualquier interfaz real sin salir del framework. Los cuatro frentes en orden de impacto:

### Frente 1 — Cobertura completa de utilidades
Terminar los gaps pendientes (media y baja prioridad del gap-report.md), luego hacer una comparación sistemática contra la lista de utilidades de Tailwind para cubrir lo que falte. El gap report es el motor: audit → implementar → audit.

**Estado:** en curso — gaps de alta prioridad completados, media prioridad pendiente.

### Frente 2 — Variantes de estado
El salto de potencia más grande. Sin build step las variantes se generan explícitamente en el CSS:
```
.hover\:bg-subtle:hover        { background-color: var(--color-bg-subtle); }
.focus\:ring:focus              { outline: 2px solid var(--color-cta-bg); }
.disabled\:opacity-50:disabled  { opacity: 0.5; }
```
No es necesario cubrir todo Tailwind — con las 10–15 combinaciones más frecuentes se resuelve el 80% de los casos reales (hover para bg/text/opacity, focus para ring/border, disabled para opacity/cursor).

**Estado:** pendiente.

### Frente 3 — Responsive completo (4 breakpoints)
Hoy solo md- y lg-. Extender sm- (640px) y xl- (1280px) a todas las utilidades que lo justifican: display, flex, grid, spacing, text-align.

**Estado:** pendiente — breakpoints declarados en tokens, sin clases.

### Frente 4 — Modularización
Sin JIT el CSS crece con cada utilidad. La respuesta es dividir en módulos opcionales que el consumidor carga según necesidad: `utils-states.css`, `utils-responsive.css`, etc.

**Estado:** pendiente — a encarar cuando el tamaño del archivo justifique la separación.

---

**Trade-off central:** Tailwind con JIT genera solo el CSS usado (~5–20kb). VorticeCSS sin build step es más pesado. Para WordPress y WooCommerce esto es aceptable si el archivo final se mantiene por debajo de 50–80kb minificado.

---

## 8. Fuera de scope — explícito

- Build step (webpack, vite, rollup, postcss)
- Preprocesadores (Sass, Less, Stylus)
- JavaScript / interactividad
- Librería de componentes visuales (cards, modals, buttons como componentes)
- Generador de temas con UI
- Documentación pública / sitio de docs
- Testing automatizado de CSS

---

## 9. Gotchas y restricciones técnicas

- **Breakpoints sm/xl declarados pero sin clases:** `tokens.css` lista `sm: 640px` y `xl: 1280px` como referencia, pero no existen prefijos `.sm-` ni `.xl-` en utils.css o grid.css. No usar esos prefijos hasta implementarlos.
- **Dark mode no cubre CTAs:** El bloque `[data-theme="dark"]` invierte superficie y texto pero no los tokens `--color-cta-*`. Un botón con fondo `--color-cta-bg` puede quedar ilegible en modo oscuro si el color de acento es muy oscuro.
- **`.rounded` sin sufijo rompe el patrón:** El nivel medio del sistema se llama `.rounded` en vez de `.rounded-md`, inconsistente con el resto del framework donde el paso medio siempre lleva `-md`.
- **Orden de carga obligatorio:** reset → tokens → base → grid → utils → layout → components. Romper el orden produce comportamiento inesperado (tokens sin definir, especificidad incorrecta).
- **`tokens.css` Sección 1 es el único punto de personalización:** Modificar los semánticos directamente rompe el sistema de dark mode y la coherencia entre proyectos.
- **Hooks de documentación cubren .css/.sh/.json (no solo .css):** `hook-changelog.sh` y `hook-brief.sh` deben cubrir los tres tipos de archivo — los cambios de arquitectura suelen ocurrir en scripts y configuración, no en CSS. Si se agrega un nuevo tipo de archivo relevante, expandir la condición del hook.
- **hook-a11y.sh existe pero NO está en el pipeline automático:** Envía el contenido CSS completo como contexto, lo que consume demasiados tokens por edición. Ejecutar manualmente cuando se quiera validar accesibilidad de un archivo específico.

---

## 10. Referencias visuales y de negocio

| Referencia | Qué se tomó de ahí |
|------------|-------------------|
| Tailwind CSS | Filosofía utility-first, nomenclatura de clases (gap-md, flex, items-center) |
| Open Props | Modelo de tokens en capas (primitivos → semánticos) |
| Every Layout | Patrón Stack (`* + *` selector), filosofía de layout sin clases por hijo |
| Material Design | Grid de espaciado base 4px |

---

## 11. Integraciones externas

| Servicio | Ubicación en el código | Qué hace |
|----------|----------------------|----------|
| WooCommerce | `grid.css` — selector `ul.products` | Auto-grid aplicado automáticamente a la lista de productos de WooCommerce |

---

## 12. Identidad visual

**Paleta:** Escala de 9 grises (100–900) por defecto. Cada proyecto define su paleta en `tokens.css` Sección 1, mapeando sus colores de marca a la escala.  
**Tipografía:** `system-ui, sans-serif` por defecto. Configurable por proyecto en `--_font-sans`, `--_font-serif`, `--_font-mono`. Escala Major Third (1.25).  
**Estilo general:** Neutral, sin opinión de diseño fuera de los tokens base. El framework no impone estética, solo estructura.  
**Responsive:** sm 640px (referencia) / md 768px (clases activas) / lg 1024px (clases activas) / xl 1280px (referencia, container max-width)

---

## 13. Infraestructura y deploy

| Item | Detalle |
|------|---------|
| Hosting | No aplica — framework local |
| URL producción | No aplica |
| URL desarrollo | No aplica |
| Deploy | Distribución como git submodule en proyectos consumidores |
| CI checks | Ninguno definido |
| Desarrollo local | Editar archivos CSS directamente, sin servidor de desarrollo |

---

## 14. Scope técnico y arquitectura

Framework de **1,019 líneas de CSS puro** en 5 archivos. Sin dependencias, sin build. El proyecto consumidor lo incluye como submodule y agrega sus propios archivos de layout y componentes.

### Archivos principales
| Archivo | Descripción |
|---------|-------------|
| [`reset.css`](../reset.css) | Reset moderno. Nunca modificar. |
| [`tokens.css`](../tokens.css) | Design tokens. Solo modificar Sección 1 (primitivos) por proyecto. |
| [`base.css`](../base.css) | Estilos de HTML elements. Nunca modificar. |
| [`grid.css`](../grid.css) | Sistema de layout (container, grid, flex, stack, gap). Nunca modificar. |
| [`utils.css`](../utils.css) | Utilidades de una responsabilidad. Nunca modificar. |

### Stack / Dependencias
| Capa | Responsabilidad |
|------|----------------|
| CSS custom properties | Sistema de tokens, theming, dark mode |
| CSS Grid + Flexbox | Sistema de layout |
| Media queries nativas | Responsive (md 768px, lg 1024px) |
| Sin dependencias externas | — |

---

## 15. Documentos del proyecto

| Doc | Contenido |
|-----|-----------|
| `docs/brief.md` | Este archivo — contexto general, decisiones, gotchas |
| `docs/changelog.md` | Historial de cambios — actualizar después de cada cambio |
