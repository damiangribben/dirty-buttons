# Shader rendering architecture for patina

Answers [0009](../issues/0009-shader-rendering-architecture.md). Researched 2026-09-30.

## Recommendation

Components stay **DOM** (HTML/CSS/SVG, drawn in whichever style is active). The patina is drawn by **one hidden WebGL2 context** that never appears in the page. For each surface, the page renders the patina into that context and then copies the result, with `drawImage`, into a small **2D `<canvas>` that sits inside the surface's own DOM element**. Each canvas is layered above the body and below any floating UI.

- **Dirt and wear live on the CPU.** Each surface holds a small `Float32Array` with two channels (dirt and wear). Touches and cloth strokes paint splats into this array in JS. After each change, the array is uploaded to the surface's texture with `texSubImage2D`, and only that surface is re-rendered and copied. Nothing renders every frame, and nothing is ever read back from the GPU.
- **Print is drawn by the shader, not the DOM.** The style supplies each surface's printed parts (legends, ticks, pad numbers) as an alpha mask image (SVG rasterised to an `ImageBitmap`), plus a few material parameters. The patina shader draws that print, erodes it by the wear map (wear plus noise, thresholded, so it pits and fades rather than dimming evenly), then shades lost finish and lays dirt on top. The DOM draws only the body and shape.
- **Style independence** comes from the shader and the maps being identical across styles. Switching style swaps the DOM body, the print mask images and the material parameters. The patina carries over unchanged.
- **Moving parts get alignment for free.** The dial's patina canvas sits inside the rotating knob, so it rotates with it. The slider thumb and the track are separate surfaces, so dirt stays on the thumb and wear stays on the track. Scrolling, resizing and stacking under the input tooltip are ordinary DOM layout.
- **Library:** none. The sanity check below needed about 25 lines of raw WebGL2. If the boilerplate grows, use twgl.js (see Library).
- **Build step:** none. Use one plain HTML file with shaders as template strings.

### Rejected alternatives

| Option | Why not |
|---|---|
| One WebGL context per component | There are about 17 surfaces. Browsers keep about 16 live contexts per page (Chrome and Firefox), and some environments as few as 8. When the limit is passed, the oldest context is silently lost. |
| One fixed full-page overlay canvas using scissor rectangles (the three.js / webglfundamentals "multiple views" technique) | The overlay lags behind the page when scrolling. It cannot slip under the tooltip or the cloth cursor unless z-index is juggled. The rotated dial needs manual transforms. The overlay cannot remove print that the DOM draws underneath it. |
| Drawing the whole components in WebGL | The label + input needs a real DOM `<input>`. Both styles would have to be rebuilt in shaders, and the style switch would lose its purpose. |
| three.js | About 195 KB gzipped (`three.module.min.js` plus `three.core.min.js`, r186) to draw textured quads. Overkill. |

## Key facts

- **Context limits.** Chrome logs "Too many active WebGL contexts. Oldest context will be lost" after about 16 contexts. Firefox logs "Exceeded 16 live WebGL contexts for this principal". Chrome on Android reportedly keeps only about 8. The three.js manual says "typically that limit is around 8". ([three.js manual: multiple scenes](https://github.com/mrdoob/three.js/blob/r160/manual/en/multiple-scenes.html), [webglfundamentals: multiple views](https://webglfundamentals.org/webgl/lessons/webgl-multiple-views.html), [holoviz/panel#4599](https://github.com/holoviz/panel/issues/4599))
- **The offscreen-render-then-copy pattern is documented.** The three.js manual describes it this way: "render to an off screen canvas and copy the result to a 2D canvas at each element… no limit on how you can composite each separate area… With this solution we have normal HTML elements." Its stated cost is one copy per area, which is negligible here because only the touched surface is copied, and only on a touch. The same manual documents the scroll lag of the fixed-overlay approach. ([three.js manual](https://github.com/mrdoob/three.js/blob/r160/manual/en/multiple-scenes.html))
- **Sanity check** (run in Playwright WebKit, "WebKit WebGL"). One WebGL2 context held 15 surfaces as `RG16F` textures of 64×64. Each surface got a CPU splat into a `Float32Array`, then `texSubImage2D`, a draw, and `drawImage` into its own 2D canvas. There were no GL errors, the pixels came through correctly, and **all 15 surfaces took about 5 ms combined**, so one surface takes about 0.3 ms. `RG16F` accepts a `FLOAT` upload and supports linear filtering in core WebGL2, so no extensions are needed.
- **localStorage** allows about 5 MiB per origin and throws `QuotaExceededError` past that ([MDN: storage quotas](https://developer.mozilla.org/en-US/docs/Web/API/Storage_API/Storage_quotas_and_eviction_criteria)). Each Artifact has its own origin, and storage can be missing or throw (private windows, previews), so every read and write goes in `try/catch` and the page must render with empty patina when storage is unavailable.
- **CDN availability** (checked live):
  - twgl.js 7.0.1 is on cdnjs (15 KB gzipped for the base build).
  - regl 2.1.1 is on jsdelivr (29 KB gzipped).
  - ogl 1.0.11 is on jsdelivr as ES-module source split across many files.
  - three r186 is on jsdelivr (about 195 KB gzipped).
  - All four are allowed hosts for Artifacts.

## Data model

```
surface = {
  id: "pad-5" | "button" | "dial-knob" | "slider-track" | "slider-thumb" | ...,
  el: HTMLElement,              // patina <canvas> lives inside it; local coords come from here
  res: [w, h],                  // e.g. 64×64 (pads, button); 128×24 (slider track)
  map: Float32Array(w*h*2),     // interleaved [dirt, wear], range 0..1, clamped
  tex: WebGLTexture,            // RG16F mirror of map
  print: ImageBitmap,           // alpha mask supplied by the current style
}
```

- **Touch:** convert the pointer position to surface UV, then call `splat(map, uv, radius, dirtRate, wearRate)` with a soft radial falloff. Linear rates: dirt fast, wear about 1/20 to 1/100 as fast. Clamp to 1.
- **Slider:** travel is spread as a line of splats along the track between the old and new stop.
- **Cloth:** on `pointermove`, throttled to animation frames, subtract dirt within the brush radius. Wear is never touched.
- **Reset:** zero every map, clear storage, re-render.
- **Store accumulated maps, not raw touch events.** Maps have a fixed size, however heavy the use. Raw events grow without bound, and replaying them costs time.
- **Persistence:** quantise to `Uint16Array` so slow wear increments are not lost to 8-bit steps. Store under one key, as base64 (optionally deflated with `CompressionStream`). Save debounced (about 500 ms after the last touch) and on `pagehide`.
- **Size estimate** (17 surfaces × 64×64 × 2 channels × 2 bytes ≈ 280 KB raw):

  | State | Deflated + base64 |
  |---|---|
  | Heavy, noisy use (measured on 15 surfaces) | about 320 K characters |
  | Heavy, noisy use (17 surfaces) | about 370 K characters |
  | Light use | about 40 K characters |
  | Fresh | under 1 K characters |

  This is well under 5 MiB, so compression is optional. If the panel surface itself later becomes a surface (for example 256×128), add about 175 K characters.

## Library and build

- **Recommended:** raw WebGL2 and no script tag. There is one program (or one per material variant), one full-canvas quad, and N small textures.
- **If helpers are wanted:** twgl.js base build (UMD, global `twgl`):
  `https://cdnjs.cloudflare.com/ajax/libs/twgl.js/7.0.1/twgl.min.js`
  - ES-module form: `https://cdnjs.cloudflare.com/ajax/libs/twgl.js/7.0.1/twgl-full.module.min.js`
  - Note: jsdelivr's npm package is still at 7.0.0, at `https://cdn.jsdelivr.net/npm/twgl.js@7.0.0/dist/7.x/twgl.min.js`.
- **No build step.** Nothing requires one: there are no npm dependencies and no GLSL imports or bundling. The page is one `.html` file with inline CSS, JS and shader strings, far under the 16 MB Artifact limit.

## Open risks for the prototypes

1. **Local coordinates on transformed elements.** `getBoundingClientRect()` on the rotated dial returns its axis-aligned box. Compute knob-local UV from the known angle rather than from the rect. The same applies to anything scaled on press.
2. **Print moves into the shader.** Each style must deliver its legends as mask images, and text rasterised from SVG must be crisp at `devicePixelRatio`. If this is awkward for the flat style, the fallback is a DOM print layer with a CSS `mask-image` generated from the wear map. That fallback is not a shader, but it is style-agnostic.
3. **Device pixel ratio.** Size each patina canvas at CSS size × `devicePixelRatio`, and size the hidden GL canvas to the largest surface. Re-render when the ratio changes, for example on zoom.
4. **Context loss.** Listen for `webglcontextlost` and `webglcontextrestored`. Because the maps live on the CPU, recovery means re-creating the textures and re-rendering.
5. **Look at low resolution.** A 64×64 map is blurry by design. Detail must come from procedural noise in the shader (grain, pitting, smudge edges). Check that pads about 60 px across still read as tactile rather than as soft blobs.
6. **Rate tuning.** A linear dirt rate that is fast enough to be satisfying saturates quickly under heavy use. Decide the clamp and the look of "maximum grime" early.
7. **Cloth feel and grime spread** are still unspecified in the map. Smearing can be done as a small JS blur of the dirt channel under the brush, and neighbour spread as a panel-level surface. Both fit this model without architectural change.
8. **Storage availability inside the Artifact iframe.** Verify on the real published URL that localStorage survives reloads.
