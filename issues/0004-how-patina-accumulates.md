---
id: 4
title: How does patina accumulate?
labels: [wayfinder:grilling]
status: closed
parent: 1
blocked_by: []
assignee: damiang
---

## Question

Is patina local or global, and how does it build over time?

## Resolution

- **Local everywhere.** Patina builds where each touch landed.
- Patina has **two channels**:
  - **Dirt** — grime added to surfaces (e.g. the button body). Linear, **faster**.
  - **Wear** — material removed (e.g. type wearing off). Linear, **slower**.
- A component should look dirty well before its type starts wearing off.
- Exact rates, and whether each channel caps at a visual maximum, are tuned by feel in [What dirt and wear rates feel right?](0010-dirt-and-wear-rates.md).

> **Amended** by [What dirt and wear rates feel right?](0010-dirt-and-wear-rates.md): dirt eases toward a ceiling instead of growing linearly; wear stays linear.
