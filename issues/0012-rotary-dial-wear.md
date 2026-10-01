---
id: 12
title: How should the rotary dial wear?
labels: [wayfinder:prototype]
status: closed
parent: 1
blocked_by: [9]
assignee: damiang@ocula.tech
---

## Question

What is a touch on the rotary dial, and where does its dirt and wear land? Candidates: wear by amount turned, grime on the grip edge where fingers hold it, the pointer/index mark rubbing off, the scale ticks wearing where the dial rests most.

Prototype: a rough dial with two or three of these behaviours switchable, so it can be judged by playing with it.

From the rendering research: touch positions on the knob must be un-rotated by the knob's angle so patina sticks to the knob, not the screen.

Build on the skeuomorphic panel in the [style comparison prototype](../prototypes/style-comparison.html) — skeuomorphic ships ([Which style should ship — skeuomorphic or flat?](0011-style-comparison.md)).

## Assets

- Dial wear prototype: [prototypes/dial-wear.html](../prototypes/dial-wear.html) — skeuomorphic knob at close-up and actual size sharing one patina; switchable behaviours (grip grime, pinch grip, wear by amount turned, index mark rubs off, panel around the knob); simulated hand.

## Resolution

Chosen by playing with the [dial wear prototype](../prototypes/dial-wear.html). Uses the rates from [What dirt and wear rates feel right?](0010-dirt-and-wear-rates.md).

- **A touch on the dial is a grab** (pointerdown on the knob). Turning on its own is not a touch for the grip.
- **Grip grime — yes.** Each grab adds one normal touch (dirt and wear) at the single grab point on the rim. It's stored relative to the knob: the pointer position is turned back by the knob's current angle, so the patina rotates with the knob. In the prototype the splat radius is 0.16 of the knob's map.
- **Pinch grip — no.** One contact point per grab, nothing added on the opposite side.
- **Wear by amount turned on the grip — no.** Turning doesn't add grime or shine at the gripped spots.
- **Index mark rubs off — yes, driven by turning.** For every 30° turned, the pointer line gets 2 touch-equivalents of wear and 0.2 of dirt, spread along its length. Heavy turning eventually wipes the pointer off.
- **Panel around the knob — yes.** This is a new, non-rotating ring surface around the knob (twice the knob's diameter), and the dial scale's ticks and numbers become its printed legends, drawn by the shader.
  - Each grab smudges the ring just outside the rim, toward the grab point: 0.6 of a touch of dirt, no wear.
  - Each release wears the scale tick nearest to where the dial is left: 1 touch of wear and 0.2 of dirt. Favourite settings slowly lose their ticks.
- This replaces "undecided" in the dial row of [What counts as a touch on each component?](0003-what-counts-as-a-touch.md).
