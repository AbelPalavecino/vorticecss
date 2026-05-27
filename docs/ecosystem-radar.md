# Ecosystem Radar — VorticeCSS

Rastreo semanal automático de Tailwind, MDN y web.dev.
Actualizado cada lunes por `scripts/track-ecosystem.sh`.

---

## Fuentes manuales a consultar

Estas no son automatizables pero son las más importantes para estar al día con el estándar CSS:

| Fuente | URL | Frecuencia sugerida |
|--------|-----|-------------------|
| CSSWG — especificaciones en borrador | https://github.com/w3c/csswg-drafts | Mensual |
| Interop (compat anual Chrome/Firefox/Safari) | https://wpt.fyi/interop-2025 | Al inicio de año |
| MDN — nuevas propiedades CSS | https://developer.mozilla.org/en-US/docs/Web/CSS | Mensual |
| web.dev — artículos de CSS | https://web.dev/blog | Semanal (automatizado) |
| Tailwind blog | https://tailwindcss.com/blog | Semanal (automatizado) |
| Tailwind releases | https://github.com/tailwindlabs/tailwindcss/releases | Semanal (automatizado) |
| Browserslist | https://browsersl.ist | Al cambiar target de soporte |

## Cómo usar este archivo en sesiones de Claude

Al inicio de una sesión podés pedir:
> "Revisá el ecosystem-radar y decime qué técnicas de Tailwind o CSS estándar deberíamos incorporar al framework."

Claude va a leer el radar, cruzarlo con el gap-report.md y sugerir qué implementar.

---

## 2026-05-27

### Tailwind CSS — v4.3.0 (publicado: 2026-05-08)

### Added

- Add `@container-size` utility ([#18901](https://github.com/tailwindlabs/tailwindcss/pull/18901))
- Add `scrollbar-{auto,thin,none}` utilities for `scrollbar-width`, and `scrollbar-thumb-*` / `scrollbar-track-*` color utilities for `scrollbar-color` ([#19981](https://github.com/tailwindlabs/tailwindcss/pull/19981), [#20019](https://github.com/tailwindlabs/tailwindcss/pull/20019))
- Add `scrollbar-gutter-*` utilities ([#20018](https://github.com/tailwindlabs/tailwindcss/pull/20018))
- Add `zoom-*` utilities ([#20020](https://github.com/tailwindlabs/tailwindcss/pull/20020))
- Add `tab-*` utilities ([#20022](https://github.com/tailwindlabs/tailwindcss/pull/20022))
- Allow using `@variant` with stacked variants (e.g. `@variant hover:focus { … }`) ([#19996](https://github.com/tailwindlabs/tailwindcss/pull/19996))
- Allow using `@variant` with compound variants (e.g. `@variant hover, focus { … }`) ([#19996](https://github.com/tailwindlabs/tailwindcss/pull/19996))
- Support `--default(…)` in `--value(…)` and `--modifier(…)` for functional `@utility` definitions ([#19989](https://github.com/tailwindlabs/tailwindcss/pull/19989))

### Fixed

- Ensure `@plugin` resolves package JavaScript entries instead of browser CSS entries when using `@tailwindcss/vite` ([#19949](https://github.com/tailwindlabs/tailwindcss/pull/19949))
- Fix relative `@import` and `@plugin` paths resolving from the wrong directory when using `@tailwindcss/vite` ([#19965](https://github.com/tailwindlabs/tailwindcss/pull/19965))
- Ensure CSS files containing `@variant` are processed by `@tailwindcss/vite` ([#19966](https://github.com/tailwindlabs/tailwindcss/pull/19966))
- Resolve imports relative to `base` when `result.opts.from` is not provided when using `@tailwindcss/postcss` ([#19980](https://github.com/tailwindlabs/tailwindcss/pull/19980))
- Canonicalization: preserve significant `_` whitespace in arbitrary values ([#19986](https://github.com/tailwindlabs/tailwindcss/pull/19986))
- Canonicalization: add parentheses when removing whitespace from arbitrary values would hurt readability (e.g. `w-[calc(100%---spacing(60))]` → `w-[calc(100%-(--spacing(60)))]`) ([#19986](https://github.com/tailwindlabs/tailwindcss/pull/19986))
- Canonicalization: preserve the original unit in arbitrary values instead of normalizing to base units (e.g. `-mt-[20in]` → `mt-[-20in]`, not `mt-[-1920px]`) ([#19988](https://github.com/tailwindlabs/tailwindcss/pull/19988))
- Canonicalization: migrate arbitrary `:has()` variants from `[&:has(…)]` to `has-[…]` ([#19991](https://github.com/tailwindlabs/tailwindcss/pull/19991))
- Upgrade: don’t migrate inline `style` attributes (e.g. `style="flex-grow: 1"` → `style="flex-grow: 1"`, not `style="grow: 1"`) ([#19918](https://github.com/tailwindlabs/tailwindcss/pull/19918))
- Allow multiple `@utility` definitions with the same name but different value types ([#19777](https://github.com/tailwindlabs/tailwindcss/pull/19777))
- Export missing `PluginWithConfig` type from `tailwindcss/plugin` to fix errors when inferring plugin config types ([#19707](https://github.com/tailwindlabs/tailwindcss/pull/19707))
- Ensure `start` and `end` legacy utilities without values do not generate CSS ([#20003](https://github.com/tailwindlabs/tailwindcss/pull/20003))
- Ensure `--value(…)` is required in functional `@utility` definitions ([#20005](https://github.com/tailwindlabs/tailwindcss/pull/20005))
- Canonicalization: preserve required whitespace around operators in negated arbitrary values (e.g. `-left-[(var(--a)+var(--b))]`) ([#20011](https://github.com/tailwindlabs/tailwindcss/pull/20011))

### MDN — últimas publicaciones

- MDN Blog
- Under the hood of MDN&apos;s new frontend
- Image formats: Codecs and compression tools
- A beginner-friendly guide to view transitions in CSS
- Launching MDN&apos;s new front end

### web.dev — últimas publicaciones

- New to the web platform in April
- March 2026 Baseline monthly digest
- February 2026 Baseline monthly digest
- New to the web platform in March
- January 2026 Baseline monthly digest

---

