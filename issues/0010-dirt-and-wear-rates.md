---
id: 10
title: What dirt and wear rates feel right?
labels: [wayfinder:prototype]
status: closed
parent: 1
blocked_by: [9]
assignee: damiang@ocula.tech
---

## Question

At what linear rates should dirt and wear accrue, and should each channel stop at a visual maximum?

Prototype: a tuning harness on one or two components with sliders for dirt rate, wear rate and caps, plus "simulate N touches" buttons, so rates are picked by feel. Constraint from [How does patina accumulate?](0004-how-patina-accumulates.md): dirt shows well before wear.

From the rendering research: dirt may saturate early under heavy use — settle the dirt cap here.

## Assets

- Tuning harness prototype: [prototypes/rates-harness.html](../prototypes/rates-harness.html) — button + pad on the shared-WebGL2 architecture, sliders for dirt rate, wear ratio, caps, splat radius, finger scatter, dirt colour; simulate/auto-tap; copy settings.

## Resolution

Tuned by feel in the [harness](../prototypes/rates-harness.html); defaults confirmed after play-testing. Values are per touch, at the centre of the splat, on a 0–1 map.

- **Dirt eases toward a ceiling — it isn't linear.** Each touch adds `dirtRate × falloff × (1 − dirt / ceiling)`, so dirt builds fast and then slows. A hard cap was rejected: it flattened heavy use into a dead, uniform disc. With easing, the edges keep feathering out and heavy use stays alive. *This amends the "linear" dirt in [How does patina accumulate?](0004-how-patina-accumulates.md).*
  - `dirtRate = 0.025`, `dirtCeiling = 0.85` → half the ceiling after ~24 touches, 90% after ~79.
- **Wear is linear with a cap of 1.0** — heavy use can erase a legend completely.
  - `wearRate = dirtRate / 40 = 0.000625` → pitting shows at ~190 touches; legend fully gone at ~1,600.
- **Splat:** soft Gaussian, `radius = 0.22 × the surface's short side` (CSS px), falloff `exp(−1.6·d²/r²)`, cut off at 2r.
- **Dirt colour** `#6b5a44` is a placeholder. The shipping style supplies dirt colour per material — see [Which style should ship — skeuomorphic or flat?](0011-style-comparison.md).
- The harness also confirmed that the shared-WebGL2 + per-surface-canvas pipeline from [How should shader patina render over the components in one Artifact page?](0009-shader-rendering-architecture.md) works, with 16-bit persistence across reloads. Its splat, shader and persistence code can be lifted straight into the build.
