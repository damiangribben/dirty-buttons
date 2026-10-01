---
id: 14
title: Should the panel around the controls collect patina?
labels: [wayfinder:prototype]
status: closed
parent: 1
blocked_by: []
assignee: damiang@ocula.tech
---

## Question

The dial now has a panel ring that picks up fingertip smudges ([How should the rotary dial wear?](0012-rotary-dial-wear.md)). Should the rest of the panel collect patina too? Options: nothing beyond the dial ring; a smudge ring or halo around every control (fingertips overshooting buttons, pads, the slider and switches); or the whole panel as one large surface that collects dirt where hands reach across it, possibly with grime spreading from busy controls to their neighbours. Should panel print (captions, the brand, slider ticks) wear?

Prototype: add switchable panel patina to the skeuomorphic panel in the [style comparison prototype](../prototypes/style-comparison.html), judged after simulated use. Storage budget: a 256×128 panel surface adds about 175K characters ([How should shader patina render over the components in one Artifact page?](0009-shader-rendering-architecture.md)).

If the panel collects dirt, the cloth should scrub it with the same settings as the controls ([How should the cloth feel?](0013-cloth-feel.md)). The [cloth feel prototype](../prototypes/cloth-feel.html) is the most up-to-date base to build on.

## Assets

- Panel patina prototype: [prototypes/panel-patina.html](../prototypes/panel-patina.html) — the cloth-feel panel plus a panel-wide surface (256×96 map). Modes: dial ring only / halo round every control / whole panel (halo + the heel of the hand resting below each control). Spread slider; "Panel print wears" puts captions and the brand into the shader so they can wear. Cloth scrubs the panel too.

## Resolution

The defaults in the [panel patina prototype](../prototypes/panel-patina.html) were confirmed after play-testing.

- **Halo round every control.** The panel is one surface (a 256×96 map behind the controls). Each touch on a control also smudges the panel just past that control's edge, in the direction of the touch: radius 11 px, 0.5 touch of dirt (0.6 for the dial), and 0.3 touch of wear. The dial's halo is the panel ring from [How should the rotary dial wear?](0012-rotary-dial-wear.md).
  - The panel's position is the control's centre, pushed out to its edge plus 9 px (that is, 4 + 5 × spread, with spread = 1.0), plus a 3 px random jitter. Thumb touches go to their parent control's halo (slide toggle, slider). Travel along the slider and slide-toggle tracks doesn't add halos.
- **Whole-panel mode (the heel of the hand resting below controls) — no.** It read as too heavy and buried the captions.
- **Panel print wears.** The brand, model name and captions are drawn by the shader as the panel's print mask, so halo wear slowly erodes them. The dial scale is part of the panel print too (the tick-wear rule from the dial ticket applies).
- **Grime doesn't spread between neighbours** other than through overlapping halos.
- **The cloth cleans the panel** with the same settings as the controls.
- Storage: the panel map adds about 50K characters at heavy use — well within budget.
