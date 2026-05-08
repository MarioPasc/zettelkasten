---
name: coding-session-log
description: Create a timestamped coding-session log inside a project's coding-sessions/ folder, summarising what was worked on, decisions taken, code touched, outcomes, and next steps. Use after any meaningful coding interaction tied to a project in 01_Projects/, or whenever the user says "log this session", "write a session note", or "summarise what we did".
---

# coding-session-log

Captures a single coding session into a structured note under
`01_Projects/<project-slug>/coding-sessions/`. The note follows the
template at `06_Meta/templates/coding-session.md` and the conventions in
`CLAUDE.md`.

## When to invoke

- After a Claude Code session in a project repo, when the user asks to
  log it.
- At the end of a multi-turn chat where code was discussed for a project.
- When the user says any of: "log this session", "write a session note",
  "save what we did", "session log".

## Inputs to gather (in order)

1. **Project slug** — the folder name under `01_Projects/`. If
   unambiguous from context (only one active project, or explicitly
   named), proceed. Otherwise list available projects from
   `ls 01_Projects/` and ask.
2. **Session title** — short, kebab-cased. Derive from what was
   discussed; confirm with user if unclear.
3. **Code references** — file paths, branches, commit SHAs that were
   touched. Pull from chat context.
4. **Outcome** — what works, what doesn't, what's deferred.

## Procedure

```bash
PROJECT_SLUG="<slug>"
SESSION_SLUG="<kebab-title>"
TS=$(date +%Y-%m-%dT%H%M)
TARGET_DIR="01_Projects/${PROJECT_SLUG}/coding-sessions"
TARGET_FILE="${TARGET_DIR}/${TS}--${SESSION_SLUG}.md"

# Verify the project exists
test -d "${TARGET_DIR}" || { echo "Project not found: ${PROJECT_SLUG}"; exit 1; }
```

1. Read the template: `06_Meta/templates/coding-session.md`.
2. Substitute: `<project-slug>`, `<Session title>`, `<one-line summary>`,
   `created`, `updated`, body sections (Context, Decisions, What we did,
   Code references, Outcome, Next steps), and Related links.
3. Required wikilinks in `## Related`:
   - `[[../_MOC|Project MOC]]`
   - `[[../_README|Project README]]`
   - any concept / paper / decision touched
4. Required inline tag line at the bottom:
   `#type/session #project/<slug> #status/done`
5. Write the file at `${TARGET_FILE}`.
6. **Invoke the `moc-update` skill** to add a one-liner for this session
   to `01_Projects/${PROJECT_SLUG}/coding-sessions/_MOC.md`.

## Quality gate

Before returning, verify (per `CLAUDE.md` § 9):

- [ ] Frontmatter present and complete (`type: session`, `status: done`,
      `project: <slug>`, ≥3 tags).
- [ ] H1 matches `title`.
- [ ] One-line italic summary is present and informative (not "session
      log").
- [ ] At least one `[[wikilink]]`.
- [ ] Inline `#tag` line is present.
- [ ] Filename matches `YYYY-MM-DDTHHMM--<kebab-slug>.md`.
- [ ] Coding-sessions `_MOC.md` updated.

## What to keep out

- Do not paste raw stdout, raw `pip install` output, or raw stack traces
  longer than ~10 lines. Summarise.
- Do not include API keys, tokens, hospital IDs, patient identifiers.
- Do not invent decisions the user did not make. If unsure, write
  "Decision pending" and `#status/draft`.
