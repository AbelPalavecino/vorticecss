# Changelog — VorticeCSS

<!--
  Actualizá este archivo después de CADA cambio implementado — feature, mejora, fix o decisión.
  Es la fuente de verdad del estado evolutivo del proyecto para vos y para Claude.

  FORMATO DE ENTRADA:

  ## YYYY-MM-DD

  **Nombre del cambio** `tipo`
  Descripción breve en una o dos líneas. Qué cambió y por qué si no es obvio.

  TIPOS (usá solo estos):
  - `nuevo`    — funcionalidad, archivo o sección que no existía antes
  - `mejora`   — cambio sobre algo que ya existía
  - `fix`      — corrección de un error o comportamiento inesperado
  - `decisión` — decisión de producto, diseño o arquitectura sin cambio de código

  TIPS:
  - Una entrada por cambio significativo, no una por archivo editado
  - Las entradas más recientes van arriba
  - Describí el impacto si el cambio resuelve algo que estaba bloqueando
  - Si un cambio viene de una revisión con el cliente, agrupá bajo un título de revisión
  - No escribas qué archivos editaste — describí qué cambió funcionalmente
-->

---

## 2026-05-27

**Auto-commit en rama feat/ al finalizar sesión** `nuevo`
Hook `Stop` (`hook-commit.sh`): detecta cambios sin commitear, crea rama `feat/feature-name` derivando el nombre de las secciones nuevas en utils.css o tokens modificados, commitea todo, y vuelve a main limpio para la próxima sesión. Si hubo múltiples cambios en una sesión usa `feat/YYYY-MM-DD`. Permite revisar y mergear a main cuando se esté conforme.

**scripts/track-ecosystem.sh + docs/ecosystem-radar.md** `nuevo`
Rastreo semanal automático del ecosistema CSS: Tailwind (GitHub API), MDN Blog (RSS) y web.dev (RSS). Corre los lunes a las 8:15am junto al gap audit. El hook de SessionStart avisa si hay novedades recientes. Sección de fuentes manuales (CSSWG, Interop, Browserslist) documentada en el radar para consulta mensual.

**Objetivo del proyecto: igualar o superar a Tailwind** `decisión`
Meta formal establecida: construir un framework tan poderoso como Tailwind pero sin build step, sin dependencias y con theming real via CSS custom properties. Definidos 4 frentes de trabajo en orden de impacto: (1) cobertura completa de utilidades, (2) variantes de estado (hover:/focus:/disabled:), (3) responsive en 4 breakpoints, (4) modularización. Documentado en Sección 7b del brief.

**Decisión: prefijo feat/ en lugar de agent/** `decisión`
Las ramas del agente usan el prefijo estándar `feat/` en lugar de `agent/`. Razón: es la convención git flow estándar, no distingue entre trabajo manual y autónomo — el trabajo vale por lo que implementa, no por quién lo hizo.

**Tokens de estado (success / error / warning)** `nuevo`
Se agregaron 6 tokens semánticos en la Sección 2j de tokens.css: `--color-success`, `--color-success-bg`, `--color-error`, `--color-error-bg`, `--color-warning`, `--color-warning-bg`. Resuelve la falta de consistencia entre proyectos para formularios, alertas y badges de e-commerce.

**prefers-reduced-motion** `nuevo`
Agregado al final de base.css. Anula `animation-duration` y `transition-duration` a 0.01ms para usuarios que activaron "reducir movimiento" en su SO. Cumple WCAG 2.3.3.

**Aspect Ratio, Opacity, Line Clamp** `nuevo`
Tres grupos de utilidades nuevas en utils.css (secciones 16–18): `.aspect-square`, `.aspect-video`, `.aspect-4-3`; `.opacity-0/25/50/75/100`; `.line-clamp-1/2/3`. Eliminan la necesidad de CSS ad-hoc para los casos más frecuentes en grillas de producto.

**Background Color** `nuevo`
Sección 19 en utils.css: `.bg-default`, `.bg-subtle`, `.bg-raised`, `.bg-cta`. Las cuatro clases consumen tokens semánticos de superficie, garantizando coherencia con dark mode automáticamente.

**Object Fit + Border Width + Outline / Focus Ring** `nuevo`
Secciones 20–22 en utils.css. Object fit resuelve el recorte de imágenes en contenedores de aspect-ratio fijo. Border width permite agregar bordes usando `--color-border` sin CSS extra. Focus ring (`.ring`) provee foco visible accesible con `--color-cta-bg`, cerrando la deuda WCAG 2.1 AA pendiente.

**Fix: hooks de documentación no disparaban en .sh/.json** `fix`
`hook-changelog.sh` y `hook-brief.sh` solo verificaban archivos `.css`. Todo el trabajo de scripts y configuración de la sesión nunca disparó los recordatorios de documentación. Corregido: ahora cubren `.css`, `.sh` y `.json` (excluyendo `/docs/`).

**Decisión: conservación de tokens de Claude** `decisión`
Para limitar el consumo de contexto: (1) `hook-a11y.sh` removido del pipeline automático — enviaba el CSS completo en cada edición; queda disponible manualmente. (2) `hook-session-start.sh` limitado a top 3 gap titles en lugar del reporte completo (150 líneas → ~5 líneas). (3) Cron de gap audit cambiado de diario a semanal.

**docs/gap-report.md — primer análisis de gaps** `nuevo`
9 alta prioridad (aspect-ratio, opacity, line-clamp, colores de fondo, object-fit, border-width, outline/focus ring, tokens de estado, prefers-reduced-motion), 6 media, 2 baja. Cron semanal (lunes 8am) instalado para mantener el reporte actualizado automáticamente.

**Sistema de análisis de gaps (audit-gaps.sh + grow.sh)** `nuevo`
`audit-gaps.sh` analiza el framework contra 13 categorías de utilidades, completitud de tokens y cobertura responsive. Genera `docs/gap-report.md` con gaps priorizados. `grow.sh` orquesta el ciclo: crear rama `grow/YYYY-MM-DD` → correr audit → siguiente paso con Claude.

**Pipeline de hooks en Claude Code** `nuevo`
Se configuró `.claude/settings.json` con 3 eventos: `SessionStart` (inyecta top 3 gaps pendientes), `PostToolUse` (ejecuta 4 hooks en secuencia: lint → tokens → changelog → brief), `Stop` (muestra estadísticas del framework si hay cambios CSS).

**scripts/hook-lint.sh** `nuevo`
Detecta convenciones CSS rotas en cada edición: colores hardcodeados fuera de tokens.css, uso de `!important`, nomenclatura BEM en archivos que no corresponde, y valores px hardcodeados en propiedades de espaciado.

**scripts/hook-tokens.sh** `nuevo`
Detecta integridad del sistema de tokens rota: primitivos `var(--_*)` escapándose fuera de tokens.css, cadenas circulares entre semánticos, y valores rem/em hardcodeados donde se esperan tokens.

**scripts/hook-growth.sh + hook-session-start.sh** `nuevo`
Hook `Stop`: muestra estadísticas del framework (líneas de CSS, clases, tokens) si hubo cambios CSS en el turno — sin costo de tokens para Claude. Hook `SessionStart`: inyecta los 3 gaps de mayor prioridad al iniciar sesión para mantener foco en lo pendiente.

**scripts/hook-changelog.sh + hook-brief.sh** `nuevo`
Recordatorios automáticos post-edición: `hook-changelog.sh` recuerda actualizar el historial de cambios, `hook-brief.sh` recuerda registrar decisiones arquitecturales en el brief. Ambos se disparan después de editar `.css`, `.sh` o `.json`.

**Sistema de automatización (carpeta scripts/)** `nuevo`
Se creó `scripts/` como carpeta central de automatizaciones del framework. Pipeline de calidad que se ejecuta secuencialmente después de cada edición: lint → tokens → changelog → brief. Separa las automatizaciones del archivo de configuración para facilitar mantenimiento.

**Research inicial del framework** `decisión`
Primera sesión de análisis exhaustivo del proyecto. Se identificaron inconsistencias, deuda técnica y oportunidades de mejora. Toda la información relevante fue volcada al brief y al changelog. El análisis reveló que la arquitectura base es sólida; los problemas detectados son de detalle y no bloquean el uso actual.

**Breakpoints sm/xl declarados sin implementación de clases** `decisión`
`tokens.css` define 4 breakpoints (sm: 640px, md: 768px, lg: 1024px, xl: 1280px) pero solo md y lg tienen prefijos responsive en grid.css y utils.css. Se decide no usar `.sm-` ni `.xl-` hasta implementarlos. Registrado como deuda técnica en el brief.

**Dark mode incompleto en tokens de acción** `decisión`
El bloque `[data-theme="dark"]` cubre superficie y texto pero no los tokens `--color-cta-*`. Un botón con `--color-cta-bg` oscuro puede quedar ilegible en modo oscuro. Registrado como deuda técnica. Se resuelve cuando haya un proyecto que use dark mode real.

**Inconsistencia en nomenclatura de border-radius** `decisión`
La utilidad del nivel medio se llama `.rounded` en vez de `.rounded-md`, rompiendo el patrón del resto del framework donde el paso medio siempre lleva el sufijo `-md`. Registrado como deuda técnica pendiente de fix.

**Pasos de espaciado huérfanos** `decisión`
`--_space-16` (64px) y `--_space-32` (128px) existen como primitivos pero no tienen token semántico asignado. La escala semántica salta de `--space-xl` (48px) a `--space-section` (96px) sin pasos intermedios. Registrado como deuda técnica.

---

## 2026-05-25

**Initial release — VorticeCSS v1.0** `nuevo`
Primera versión estable del framework. Incluye reset moderno, sistema de tokens en dos capas (primitivos + semánticos), estilos base de HTML elements, sistema de layout (container, grid, auto-grid, flex, stack, gap) y utilidades de una responsabilidad. Sin dependencias, sin build step. Listo para usar como git submodule.

---
