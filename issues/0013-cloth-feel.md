---
id: 13
title: How should the cloth feel?
labels: [wayfinder:prototype]
status: closed
parent: 1
blocked_by: []
assignee: damiang@ocula.tech
---

## Question

When scrubbing with the cloth: how much dirt does one stroke lift (as a fraction of the current dirt, or a fixed amount), what size is the brush, does dirt smear (a small blur of the dirt channel under the brush) before it lifts, and what does the cloth cursor look like?

Prototype: add a cloth mode to the [rates harness](../prototypes/rates-harness.html), with sliders for lift amount, brush size and smear, and two or three cursor options. Constraints: cloth removes dirt only, never wear ([How are components cleaned?](0007-cleaning.md)). Dirt eases toward a ceiling of 0.85 ([What dirt and wear rates feel right?](0010-dirt-and-wear-rates.md)).

Build on the skeuomorphic panel in the [style comparison prototype](../prototypes/style-comparison.html) — skeuomorphic ships ([Which style should ship — skeuomorphic or flat?](0011-style-comparison.md)).

## Assets

- Cloth feel prototype: [prototypes/cloth-feel.html](../prototypes/cloth-feel.html) — the skeuomorphic panel with a cloth mode (button or `C`). Sliders for lift (as a % of the dirt there, or a fixed amount, per 10 px scrubbed), brush size and smear. Cursor: rag, ring, or both; the rag gets dirtier as it lifts grime. "Use +N" dirties the panel first.

## Resolution

The defaults in the [cloth feel prototype](../prototypes/cloth-feel.html) were confirmed after play-testing.

- **Cloth mode** is switched on and off; while it's on, dragging scrubs and the controls don't respond to presses. (The prototype uses a button and the `C` key; where the toggle sits on the final panel is a build detail.)
- **Lift is a percentage of the dirt there:** 8% per 10 px scrubbed at the centre of the brush (soft falloff `exp(−2·d²/r²)`). It's measured per distance, so scrubbing faster doesn't clean faster. Heavy grime comes off quickly and faint traces take a few more passes — about 4 back-and-forth passes take a pad from heavily used to lightly smudged.
- **Brush radius is 20 px**, and it works across surfaces: one stroke can clean several controls. On the knob, the stroke is turned back by the knob's angle so it lines up with the patina.
- **Smear is 0.4:** before lifting, the cloth drags dirt along the stroke (dirt is pulled from behind the brush), so a wipe leaves streaks before it comes clean.
- **Wear is never touched** — worn legends and shiny spots stay ([How are components cleaned?](0007-cleaning.md)).
- **Cursor: a rag** (a crumpled blue-grey cloth, about 2.6× the brush radius across). It squashes slightly when pressed and slowly darkens as it picks up grime; Reset cleans the rag too.
