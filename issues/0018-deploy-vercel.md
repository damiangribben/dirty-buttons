---
id: 18
title: Deploy to Vercel
labels: [wayfinder:task]
status: open
parent: 1
blocked_by: [16]
assignee: damiang@ocula.tech
---

## Question

Host the shipping page on Vercel as a static site, alongside the Artifact.

## Setup (done)

- `scripts/build-site.sh` generates [site/index.html](../site/index.html) from [patina-7.html](../patina-7.html). It wraps the page in a full HTML document (doctype, `lang`, charset and viewport meta tags) and adds a meta description, Open Graph title and description, a theme colour and an inline SVG knob favicon. **patina-7.html stays the only source: edit it, then re-run the script.**
- [site/vercel.json](../site/vercel.json): clean URLs plus `nosniff` and referrer-policy headers. No framework and no build command — Vercel serves `site/` as-is.
- Checked locally from `site/`: standards mode, no console errors, patina survives a reload, no horizontal scroll at 400 px.

## To deploy

1. `npm i -g vercel` (if needed), then `cd site && vercel` — link a new project, framework "Other", root `./`.
2. `vercel --prod` for the production URL.
3. Check on the live URL that the labels render (WebGL2), that +500 then a reload keeps the patina, and that the cloth scrubs.

Notes: the URL is public unless Vercel deployment protection is on. Patina is per visitor and per origin, so it isn't shared with the Artifact.
