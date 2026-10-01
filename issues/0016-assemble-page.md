---
id: 16
title: Assemble the shipping page
labels: [wayfinder:task]
status: closed
parent: 1
blocked_by: [15]
assignee: damiang@ocula.tech
---

## Question

Build the single self-contained HTML page that brings the decisions together, starting from the [panel patina prototype](../prototypes/panel-patina.html):

- the seven skeuomorphic components ([Which style should ship — skeuomorphic or flat?](0011-style-comparison.md));
- rates ([What dirt and wear rates feel right?](0010-dirt-and-wear-rates.md));
- dial behaviours, including index wear and tick wear on the dial scale ([How should the rotary dial wear?](0012-rotary-dial-wear.md));
- panel halo and panel print wear ([Should the panel around the controls collect patina?](0014-panel-patina.md));
- cloth ([How should the cloth feel?](0013-cloth-feel.md)), and the page layout from [Where do reset and cloth live, and what else is on the page?](0015-page-chrome.md): a simulator bar at the top (+50 / +500 / +3000, Reset with no confirmation), a rag to the right of the panel that you pick up and put down, and a title plus one line;
- no style switcher, no tuning controls.

Follow the `artifact-design` contract (title, CDN rules, phone width), and handle storage failure and WebGL context loss. Done when the page works locally with no console errors.

## Resolution

Built: [index.html](../index.html) — one self-contained page, written for the Artifact skeleton (no doctype, html, head or body tags of its own; it carries its own `<title>` and `<style>`).

- **Design:** one dark look on purpose — the skeuomorphic device in a dim room. Fonts come from Google Fonts: Jost for the legends and title (a Futura-like face, so the shader's print masks look the same on every OS), VT323 for the LCD name field, and IBM Plex Mono for the simulator. Print masks are drawn after the fonts load.
- **Every decision is in:**
  - the rates;
  - the seven components;
  - the dial: a grab leaves grime in knob space, turning wears the index mark, and the tick where it's left wears;
  - the panel halo, with the brand, captions and dial scale drawn as shader print that wears;
  - the cloth: 8% lift per 10 px, 20 px brush, 0.4 smear, a rag that soils;
  - the simulator bar (+50 / +500 / +3000, a touch counter, Reset with no confirmation);
  - the rag to the right of the panel (click to pick it up; click again or press Esc to put it down);
  - a title plus one line.

  No style switcher and no tuning controls.
- **Robustness:**
  - Every storage read and write is in try/catch, and the page renders without storage.
  - WebGL context loss rebuilds from the maps held in JS.
  - With no WebGL2, the intro line says patina can't be drawn.
  - The kit name and control states persist too.
- **A detail added in the build:** the panel map keeps about 28K cells but follows the panel's shape (wide on desktop, tall when stacked on a phone). If the layout changes shape by more than about 25%, only the panel smudges are cleared, since the controls have moved and old halos would land in the wrong places. Each control keeps its own patina.
- **Checked locally** (Playwright/WebKit, wrapped in a doctype the way the publish skeleton does it):
  - no console errors;
  - simulated use and cloth scrubbing work;
  - patina and the touch count survive a reload;
  - at 400 px wide there's no horizontal scroll, and the cloth sits below the panel;
  - at 1280 px the cloth sits to the right.
