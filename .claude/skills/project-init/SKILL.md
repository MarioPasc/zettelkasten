---
name: project-init
description: Scaffold a new project folder under 01_Projects/ with all required subfolders (data, coding-sessions, decisions, experiments, notes), a _README.md from the project template, a project _MOC.md, and the corresponding entry in 01_Projects/_MOC.md. Use when the user says "start a new project", "create project <name>", or "scaffold project <name>".
---

# project-init

Creates the standard project skeleton under `01_Projects/<slug>/` so
every project has the same shape and downstream skills can rely on
folder names being consistent.

## When to invoke

- User says: "start a new project", "create project <name>", "scaffold
  project <name>", "new research project".
- User describes a research direction and wants it tracked separately
  from existing work.

## Inputs to gather

1. **Project slug** — kebab-case, lowercase, ASCII. Mirrors the tag in
   `#project/<slug>`. Example: `repa-maisi-3d-mri`.
2. **Project name** — human-readable. Used as `title` in the README.
3. **One-line description** — the elevator pitch.
4. **Primary domain(s)** — at least one `domain/<x>` tag from
   `06_Meta/tag-taxonomy.md`. If a domain doesn't exist, propose adding
   it to the taxonomy in the same commit.
5. **Initial status** — usually `active`; `draft` if still scoping.
6. **Priority** — `p0`–`p3` (see taxonomy).

## Procedure

```bash
SLUG="<slug>"
PROJ_DIR="01_Projects/${SLUG}"

# 1. Create the standard subfolder set
mkdir -p "${PROJ_DIR}"/{data,coding-sessions,decisions,experiments,notes}

# 2. Create per-subfolder MOCs from the MOC template
for sub in data coding-sessions decisions experiments notes; do
  cp 06_Meta/templates/moc.md "${PROJ_DIR}/${sub}/_MOC.md"
  # Substitute "<Folder Human Name>" placeholder appropriately
done

# 3. Create the project-level _MOC.md (links to subfolder MOCs + README)
cp 06_Meta/templates/moc.md "${PROJ_DIR}/_MOC.md"

# 4. Create the _README.md from the project template
cp 06_Meta/templates/project-readme.md "${PROJ_DIR}/_README.md"
```

After copying, **edit each file** to substitute placeholders:

- `_README.md`: `<Project Name>`, `<slug>`, `<x>` (domain), `<one-line
  description>`, `created` / `updated`, status, priority.
- `_MOC.md` (project-level): list of children should include each
  subfolder MOC and the README:
  ```
  - [[_README|<Project Name> — README]]
  - [[data/_MOC|Data MOC]]
  - [[coding-sessions/_MOC|Coding Sessions MOC]]
  - [[decisions/_MOC|Decisions MOC]]
  - [[experiments/_MOC|Experiments MOC]]
  - [[notes/_MOC|Notes MOC]]
  ```
- Each subfolder `_MOC.md`: title `MOC — <Project> · <Subfolder>`,
  parent link to the project `_MOC`, children list empty initially.

## Linking up

After scaffolding, update `01_Projects/_MOC.md` to add a one-liner for
the new project. **Invoke the `moc-update` skill** for this — do not
edit the parent MOC by hand.

If the user mentioned papers or concepts the project is built on, add
backlinks from those notes' `## Related` sections to the new
`_README.md`.

## Tag taxonomy update

Add `#project/<slug>` under `## #project/* — active project slugs` in
`06_Meta/tag-taxonomy.md` in the same commit. If any new `domain/<x>`
was introduced, add it under the appropriate domain section.

## Quality gate

- [ ] All five subfolders exist with their `_MOC.md`.
- [ ] Project `_README.md` has complete frontmatter and links to project
      `_MOC`.
- [ ] Project `_MOC.md` lists all children correctly.
- [ ] `01_Projects/_MOC.md` has a new one-liner for this project.
- [ ] `06_Meta/tag-taxonomy.md` contains `#project/<slug>`.
- [ ] All new files have inline `#tag` lines.
- [ ] Commit message: `add(projects/<slug>): scaffold new project`.
