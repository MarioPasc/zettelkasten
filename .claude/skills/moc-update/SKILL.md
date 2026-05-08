---
name: moc-update
description: Keep a folder's _MOC.md in sync with its files by adding, removing, or updating one-line entries under the ## Children section. Use after creating, renaming, or deleting any note. Other skills (coding-session-log, paper-note, project-init) call this skill — do not edit MOCs by hand.
---

# moc-update

Maintains the `_MOC.md` of a single folder. The MOC is the local hub
that gives the graph view its cluster structure (see `CLAUDE.md` § 3).
Every note must appear as a one-liner under the MOC's `## Children`
section.

## When to invoke

- Immediately after another skill creates a new note (skills
  `coding-session-log`, `paper-note`, `project-init` all call this).
- When a note is renamed or moved (remove old entry, add new).
- When a note is deleted (remove its entry).
- When the user says "update the MOC", "rebuild the MOC", "sync the
  index of <folder>".

## Inputs

1. **Folder path** — the folder whose `_MOC.md` is being updated.
   Example: `01_Projects/repa-maisi-3d-mri/coding-sessions`.
2. **Operation** — one of `add`, `remove`, `rename`, `rebuild`.
3. **Target file** — the note being added / removed / renamed.

## Operations

### `add`

Read the target note's frontmatter `title` and the body's one-line
italic summary (the line immediately after the H1). Append (or insert
in chronological / alphabetical order, see § "Ordering") under the
`## Children` section:

```markdown
- [[<file-stem>|<Title>]] — <one-line summary>
```

For session notes the order is **reverse-chronological** (newest first)
because Mario reviews recent work most often.

For papers, concepts, datasets, decisions: **alphabetical by title**.

For project READMEs and subfolder MOCs at the project level: **fixed
order** — README first, then `data`, `coding-sessions`, `decisions`,
`experiments`, `notes`.

### `remove`

Locate the line matching `[[<file-stem>` and delete it.

### `rename`

Equivalent to `remove` old + `add` new. Preserve the one-line summary
unless the title also changed.

### `rebuild`

Drop the existing `## Children` block and regenerate it by walking the
folder:

```bash
FOLDER="<path>"
for f in "$FOLDER"/*.md; do
  case "$(basename "$f")" in
    _MOC.md|_README.md) continue ;;
  esac
  # Extract title from frontmatter
  TITLE=$(awk '/^title:/ {sub(/^title: */, ""); gsub(/^"|"$/, ""); print; exit}' "$f")
  # Extract one-line summary (first italic line after H1)
  SUMMARY=$(awk '/^# / {found=1; next} found && /^\*.*\*$/ {gsub(/^\*|\*$/, ""); print; exit}' "$f")
  STEM=$(basename "$f" .md)
  printf -- "- [[%s|%s]] — %s\n" "$STEM" "$TITLE" "$SUMMARY"
done
```

Use `rebuild` sparingly. It loses any hand-edited annotations in the MOC
beyond the `- [[...]] — ...` lines. Surface a diff to the user before
overwriting.

## Ordering rules

| Folder pattern                          | Order               |
|-----------------------------------------|---------------------|
| `*/coding-sessions`                     | reverse-chronological (filename) |
| `*/experiments`                         | reverse-chronological (filename) |
| `*/decisions`                           | by NNNN counter, ascending |
| `03_Resources/papers/*`                 | alphabetical by title |
| `03_Resources/concepts`                 | alphabetical by title |
| `03_Resources/datasets`                 | alphabetical by title |
| `01_Projects/<slug>` (project _MOC)     | fixed: README, data, coding-sessions, decisions, experiments, notes |
| `01_Projects/_MOC` (top-level)          | active first (status), then alphabetical |

## Bump `updated:` field

Every MOC mutation also updates the MOC's frontmatter `updated:` field
to today's date.

## Quality gate

- [ ] Entry format exact: `- [[<stem>|<Title>]] — <one-line summary>`.
- [ ] No duplicates.
- [ ] Order respects the rule above.
- [ ] MOC `updated:` field bumped.
- [ ] No edits outside the `## Children` section unless explicitly
      requested.
