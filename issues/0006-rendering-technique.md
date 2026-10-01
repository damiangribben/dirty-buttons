---
id: 6
title: How is patina rendered?
labels: [wayfinder:grilling]
status: closed
parent: 1
blocked_by: []
assignee: damiang
---

## Question

What technique draws dirt and wear?

## Resolution

**WebGL shaders.** Stay a plain self-contained HTML page unless the rendering research shows a build step (e.g. React/Vite) is needed — if so, that is acceptable. Architecture (context limits, overlay alignment, library choice) is investigated in [How should shader patina render over the components in one Artifact page?](0009-shader-rendering-architecture.md).
