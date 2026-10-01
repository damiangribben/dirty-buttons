---
id: 15
title: Where do reset and cloth live, and what else is on the page?
labels: [wayfinder:grilling]
status: closed
parent: 1
blocked_by: []
assignee: damiang@ocula.tech
---

## Question

On the shipping page: where do the **Reset** and **Cloth** controls sit — built into the device panel as hardware (a recessed reset pinhole, a cloth lying beside the device), or as page UI outside it? How does Reset confirm, if at all? What else does the page show around the panel — a title, a line of explanation, nothing? Do any dev tools (simulated use) ship, hidden or visible?

## Resolution

The page has two control areas, plus the panel.

- **Patina simulator — a bar across the top of the page.** It ships visible, for visitors.
  - **Use-count buttons: +50, +500, +3000.** Each simulates weighted real use across every control: pads 01–03 and PLAY are favoured, the slider mostly travels around the middle, the simulated hand turns the dial, the halos land on the panel, and the dial ticks wear where it's left. This is the "Use +N" behaviour from the prototypes.
  - **Reset** wipes all dirt and wear (and cleans the rag) in one click, **with no confirmation**.
- **Cloth — a rag lying to the right of the panel** (the same blue-grey rag as the cursor). Click it to pick it up: cursor mode turns on, with the settings from [How should the cloth feel?](0013-cloth-feel.md). Click the rag again or press Esc to put it down. While it's held, the spot where it lay is empty, and the rag stays soiled until Reset. On narrow screens, the rag sits below the panel.
- **Around the panel:** a small title and one line — touch it and it wears; your patina is saved in this browser.
- No other dev tools ship: no tuning sliders, no style switcher.
