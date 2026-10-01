# Local-markdown tracker

Issues are markdown files in this folder: `NNNN-slug.md`. The number is the id.

## Frontmatter

```yaml
id: 12
title: <name — always refer to an issue by this>
labels: [wayfinder:prototype]
status: open | closed
parent: 1            # the map this ticket belongs to
blocked_by: [9]      # native-blocking equivalent; ids of blocking issues
assignee:            # empty = unclaimed; set it to claim before any work
```

## Wayfinding operations

- **Map**: the issue labelled `wayfinder:map`.
- **Children of a map**: issues whose `parent` is the map id.
- **Claim**: set `assignee` before starting work.
- **Unblocked**: every id in `blocked_by` is `status: closed`.
- **Frontier**: `status: open`, unblocked, empty `assignee`, `parent` = map id.
- **Resolution comment**: append a `## Resolution` section, then set `status: closed`.
- **Assets** (prototypes, research notes) live elsewhere in the repo and are linked from the issue.
