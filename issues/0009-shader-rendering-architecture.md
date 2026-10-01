---
id: 9
title: How should shader patina render over the components in one Artifact page?
labels: [wayfinder:research]
status: closed
parent: 1
blocked_by: []
assignee: claude-research
---

## Question

What rendering architecture draws local, two-channel (dirt + wear) WebGL patina over ~15 interactive surfaces (7 components, 9 of them pads) inside a single self-contained claude.ai Artifact page?

Surface the facts the decision waits on:

- WebGL context limits per page → one shared full-page canvas vs per-component canvases; keeping an overlay aligned with DOM components (scroll, resize, pointer events passing through).
- Or: rendering the components themselves in WebGL vs styling DOM components and shading only the patina.
- Representing touch history as shader input — e.g. per-component accumulation textures (dirt map, wear map) painted with splats, persisted to localStorage; storage size.
- Wear as a mask that erodes printed type/legends; cloth as a local subtract on the dirt map only.
- three.js vs raw WebGL vs a small helper (regl, ogl, twgl) — weight and CDN availability (Artifacts may load scripts only from cdnjs, jsdelivr, unpkg).
- Plain HTML vs a build step (Vite + single-file output) — does anything force a build?

## Resolution

Full findings: [research/shader-rendering-architecture.md](../research/shader-rendering-architecture.md).

- **One shared, hidden WebGL2 context**, no library, no build step — a single plain HTML file. (Optional helper: twgl.js 7.0.1 from cdnjs, ~15 KB gz.) three.js rejected as overkill.
- **Components stay DOM/CSS.** Each surface (button, 9 pads, dial knob, slider track/thumb, …) holds its own small 2D `<canvas>`; the shared context renders a surface on change and `drawImage`s it in. No overlay sync on scroll/resize; patina rotates with the dial; tooltip stays on top. Per-component contexts (~16 cap) and a full-page overlay both rejected.
- **Data model:** per surface, a small 2-channel accumulation map (dirt, wear; ~64×64) held in JS. Touches and slider travel splat; cloth subtracts dirt only; reset zeroes. Persisted as accumulated maps (16-bit), not a touch log — bounded: ~40K chars light use, ~320–370K heavy, vs 5 MiB localStorage.
- **Print is drawn by the shader:** each style supplies legend/tick mask images that wear erodes with noise. Switching style swaps look + masks; maps and shader are shared.
- Sanity check: 15 surfaces through a full update cycle in ~5 ms, no GL errors.
- **Risks for prototypes:** dial touch positions must be un-rotated by knob angle; legend masks crisp on high-DPI; handle context loss (rebuild from JS maps); 64×64 maps need shader grain; dirt may saturate early — decide caps; verify localStorage in the live Artifact.
