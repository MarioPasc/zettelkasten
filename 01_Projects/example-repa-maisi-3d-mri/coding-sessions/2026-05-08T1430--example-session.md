---
title: "Example session — vault scaffolding walkthrough"
created: 2026-05-08
updated: 2026-05-08
type: session
status: done
project: example-repa-maisi
tags: [type/session, status/done, project/example-repa-maisi, meta/template]
sources: []
---

# Example session — vault scaffolding walkthrough

*Stand-in coding session showing the file layout, frontmatter, body sections, and tags expected of a real session log.*

## Context

Vault was being initialised. Mario asked for a worked example so the
session-note template would be obvious to future Claude agents writing
into the project.

## Decisions

- Use ISO 8601 with `T` separator for session filenames — sortable,
  unambiguous, readable.
- Reverse-chronological order in `coding-sessions/_MOC.md` because
  recent work is reviewed most often.

## What we did

1. Drafted `CLAUDE.md` covering git lifecycle, frontmatter, MOC rules.
2. Wrote templates for sessions, papers, projects, concepts, decisions,
   experiments, datasets, MOCs.
3. Wrote five Claude Code skills: `vault-sync`, `coding-session-log`,
   `paper-note`, `project-init`, `moc-update`.

## Code references

| File / module                                         | What changed                |
|-------------------------------------------------------|-----------------------------|
| `CLAUDE.md`                                           | created                     |
| `06_Meta/templates/*.md`                              | created                     |
| `.claude/skills/*/SKILL.md`                           | created                     |

## Outcome

- ✅ Vault scaffolded.
- ✅ Templates and skills in place.
- ⚠️ No real project yet — replace this example before first real use.

## Next steps

- [ ] Delete this example project once a real one is scaffolded.
- [ ] Set up the Obsidian Git plugin with auto-pull on startup.

## Related

- [[../_MOC|Project MOC]]
- [[../_README|Project README]]

#type/session #project/example-repa-maisi #status/done
