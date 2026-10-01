---
id: 11
title: Which style should ship — skeuomorphic or flat?
labels: [wayfinder:prototype]
status: closed
parent: 1
blocked_by: [9]
assignee: damiang@ocula.tech
---

## Question

Seeing the same patina on both, which style ships: skeuomorphic hardware or flat modern UI?

Prototype: the device panel with the seven components drawn in both styles, the style switcher control panel, and patina rendered over whichever style is active. The winning style also settles where dirt vs wear land on each component.

From the rates tuning: each style supplies a **dirt colour per material** (the harness used a placeholder brown, `#6b5a44`). Rates, ceiling and splat are fixed in [What dirt and wear rates feel right?](0010-dirt-and-wear-rates.md) — reuse the harness code.

## Assets

- Style comparison prototype: [prototypes/style-comparison.html](../prototypes/style-comparison.html) — all seven components on one device panel, skeuomorphic and flat, switched with the segmented control or `S`. Patina is shared across styles and uses the tuned rates. "Use +N" simulates weighted real use (pads and the play button most); Reset clears it.

## Resolution

Judged in the [style comparison prototype](../prototypes/style-comparison.html), with the same patina shown on both styles.

- **Skeuomorphic ships.** The device panel: a dark brushed-metal face with wooden side cheeks, rubber pads, an orange PLAY button, a knurled dial, an LCD-style name field, a cream slide-toggle thumb, a ridged slider cap and a black rocker. The prototype's CSS is the starting point for the build.
- **Flat and the style switcher are dropped.** The final page has one style, no switcher and no publish-time setting for it. This replaces the switcher part of [What should the visual language be?](0005-visual-language.md). The prototype stays as the record of the comparison.
- **Where dirt and wear land** (settled by the skeuomorphic materials in the prototype):
  - Dirt can land anywhere on a touched surface — bodies, pads, caps, the field.
  - Wear erodes the printed legends, ticks and index marks (drawn by the shader from per-surface print masks), and polishes the finish with a soft sheen (rubber and plastic go shiny).
  - Each material has its own legend colour, dirt colour and sheen: grease-grey grime on dark rubber, dark brown on the orange button, olive smudges on the LCD. See `STYLES.skeuo.mat` in the prototype.
- Panel print (the dial scale, captions, the brand) is not a surface yet. Whether the panel itself collects dirt is still in the map's fog.
