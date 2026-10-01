---
id: 1
title: "Map: Worn UI — components that gather patina with use"
labels: [wayfinder:map]
status: open
---

## Destination

A single self-contained HTML page, published as a private claude.ai Artifact and hosted on Vercel: a skeuomorphic-style **device panel** of seven input components that gather **patina** the more they are touched. Patina is saved per visitor (localStorage). A **reset** wipes everything; a **cloth** scrubs off dirt by hand.

## Notes

- **Purely an art experiment.** Look and feel dominate; no product, reuse or accessibility constraints.
- **Execution is carried into this map.** Unlike the planning-only default, tickets here may build things — the map ends when the Artifact is live.
- Tracker: local markdown in `issues/` — see [README](README.md).
- Prototype tickets: use `/create-prototype`-style throwaway builds, linked as assets. Artifact pages: load `artifact-design` before writing.
- **Language** (use these terms consistently):
  - **Touch** — an interaction that adds patina, recorded with its position on the component.
  - **Dirt** — grime *added* to surfaces (bodies, pads, tracks). Accrues **fast**, easing toward a ceiling.
  - **Wear** — material *removed* (type, legends, ticks, finish). Accrues **slowly**, linear to a cap of 1 (a legend can vanish).
  - **Patina** — the visible sum of dirt and wear.
  - **Style** — the material skin a component is drawn in. Skeuomorphic is the only style that ships. Patina is a layer independent of style.
  - **Cloth** — hand-scrubbing mode; removes dirt locally, never wear.
  - **Reset** — factory reset; clears dirt and wear.

## Decisions so far

- [Which components are on the panel?](0002-which-components.md) — seven: push button, 3×3 sample pad, click toggle, slide toggle, click-stop slider, label + input (with tooltip), rotary dial.
- [What counts as a touch on each component?](0003-what-counts-as-a-touch.md) — clicks/presses at their position; slider wears by travel along the track; input by focus-click position; no hover or hold.
- [How does patina accumulate?](0004-how-patina-accumulates.md) — local everywhere; two channels, dirt faster than wear (dirt later made easing).
- [What visual language are the components drawn in?](0005-visual-language.md) — skeuomorphic lead, flat to compare via a dev style switcher (switcher later dropped).
- [How is patina rendered?](0006-rendering-technique.md) — WebGL shaders; plain HTML unless research says a build step is needed.
- [How are components cleaned?](0007-cleaning.md) — reset clears everything; cloth removes dirt only, where scrubbed.
- [How is the page framed?](0008-page-framing.md) — one cohesive device panel, synth/sampler-like.
- [How should shader patina render over the components in one Artifact page?](0009-shader-rendering-architecture.md) — one shared WebGL2 context, DOM components with per-surface 2D canvases, 64×64 dirt/wear maps in localStorage, shader-drawn print masks; plain HTML, no library.
- [What dirt and wear rates feel right?](0010-dirt-and-wear-rates.md) — dirt 0.025/touch easing to a 0.85 ceiling (90% at ~79 touches); wear = dirt ÷ 40, linear, cap 1 (legend gone at ~1,600); splat radius 0.22.
- [Which style should ship — skeuomorphic or flat?](0011-style-comparison.md) — skeuomorphic (dark panel, wood cheeks, rubber pads); flat and the switcher dropped; dirt anywhere touched, wear erodes print and polishes finish, colours per material.
- [How should the rotary dial wear?](0012-rotary-dial-wear.md) — a grab leaves grime at the grip point (rotates with the knob); turning rubs off the index mark; a panel ring around the knob smudges on grab and wears the tick where the dial is left. No pinch, no wear on the grip from turning.
- [How should the cloth feel?](0013-cloth-feel.md) — lifts 8% of the dirt there per 10 px scrubbed, 20 px brush, smears (0.4) before it cleans; rag cursor that darkens as it picks up grime; never touches wear.
- [Should the panel around the controls collect patina?](0014-panel-patina.md) — a halo just past each control's edge (11 px, mostly dirt); panel captions, brand and dial scale are shader print that wears; no whole-panel hand-resting grime.
- [Where do reset and cloth live, and what else is on the page?](0015-page-chrome.md) — a simulator bar at the top (+50/+500/+3000, Reset with no confirmation); a rag to the right of the panel you pick up as the cloth; title plus one line.
- [Assemble the shipping page](0016-assemble-page.md) — built as [index.html](../index.html), single dark look; works locally with no errors, persists, fits phone width.

## Not yet specified

_Nothing left in the fog — the remaining route is ticketed._

## Out of scope

- A flat style and a style switcher — ruled out in [Which style should ship — skeuomorphic or flat?](0011-style-comparison.md); one style ships.
- Shared, cross-visitor patina (everyone wearing the same panel) — destination is per-visitor.
- Product concerns: accessibility, reuse as a component library, design-system integration — this is an art piece.
- Hover and hold-duration as touches — ruled out in [What counts as a touch on each component?](0003-what-counts-as-a-touch.md).
