# CLAUDE.md — Vault Operating Manual

This file is the contract between Mario and any Claude agent (Claude Code,
Claude in browser, sub-agents) writing into this vault. **Read it in full
at the start of every session.** Treat its rules as hard constraints.

The vault is an Obsidian + Git knowledge base for biomedical AI research:
generative models for medical imaging, foundation-model adaptation, and
related work. It is the persistent memory layer across coding sessions,
papers, and ideas.

---

## 0 · Hard rules (do these every session)

### 0.1 Git lifecycle (mandatory)

At the **start** of any writing session:

```bash
cd <vault-root>
git fetch origin
git pull --rebase origin main          # fail loudly on conflicts; never auto-resolve silently
```

At the **end** of any writing session that produced changes:

```bash
git status
git add -A
git commit -m "<conventional-commit-message>"   # see § 0.2
git push origin main
```

If a `git pull --rebase` reports conflicts, **stop and surface them to
Mario**. Do not attempt to merge silently. Conflicts in MOC files are
common and need human judgement.

### 0.2 Commit message convention

Use Conventional Commits, scoped to the area touched:

```
<type>(<scope>): <subject>

<body — optional, ≤72 chars per line>
```

Allowed `<type>`: `add`, `update`, `refactor`, `fix`, `archive`, `meta`.
`<scope>` is the top-level folder (`projects/<slug>`, `papers`, `concepts`,
`meta`, `inbox`, `areas`, …).

Examples:

```
add(projects/repa-maisi): coding session 2026-05-08T1430 on VAE feasibility
update(papers/diffusion): refine REPA notes after second read
meta(templates): tighten paper-note frontmatter
```

### 0.3 No silent overwrites

If you intend to modify an existing note, **read it first** and preserve
human-authored sections unless explicitly told to rewrite. When uncertain,
append a new dated section rather than mutating prose.

### 0.4 Atomicity

One idea = one note. If a note grows past ≈400 words on a second concept,
split it. Atomic notes are linkable; monoliths are not.

---

## 1 · Folder architecture

```
zettlekasten/
├── CLAUDE.md                 ← you are here
├── README.md                 ← human-facing entry point
├── 99_Index.md               ← top-level Map of Content (linked in graph hub)
├── 00_Inbox/                 ← unprocessed quick captures (TTL: days)
├── 01_Projects/              ← active research / code projects (TTL: weeks-months)
│   └── <project-slug>/
│       ├── _MOC.md           ← project Map of Content
│       ├── _README.md        ← project context, goals, status, stack
│       ├── data/             ← per-dataset notes (formats, splits, rationale)
│       ├── coding-sessions/  ← timestamped session logs (one .md per session)
│       ├── decisions/        ← architecture / design decisions (ADR-style)
│       ├── experiments/      ← run logs, hyperparams, results
│       └── notes/            ← misc working notes for this project
├── 02_Areas/                 ← ongoing responsibilities (TTL: years)
│   ├── phd-applications/
│   ├── teaching-and-mentoring/
│   ├── reviewer-duties/
│   └── conferences-and-talks/
├── 03_Resources/             ← reference / Zettelkasten zone (TTL: permanent)
│   ├── papers/<topic>/       ← literature notes, one per paper
│   ├── concepts/             ← atomic Zettel notes (single idea, densely linked)
│   ├── books/
│   ├── datasets/
│   └── tools-and-software/
├── 04_Archive/               ← finished or abandoned items (mirrors source structure)
├── 05_Attachments/           ← images, PDFs, figures (referenced from notes)
└── 06_Meta/
    ├── conventions.md        ← style guide (filenames, frontmatter, links)
    ├── tag-taxonomy.md       ← canonical list of valid tags
    └── templates/            ← templates inserted by skills and Templater
```

Numeric prefixes (`00_`, `01_`, …) are **immutable**. They enforce sort
order across all platforms and are referenced by skills.

### 1.1 Lifecycle and movement

```
00_Inbox  →  01_Projects  →  04_Archive
              ↑      ↓
            02_Areas
              ↑
            03_Resources  (linked from Projects/Areas; rarely moved)
```

When a project is finished or paused, **move** its folder into
`04_Archive/<YYYY-MM>__<slug>/` and update its `_MOC.md` status to
`#status/archived`. Do not delete; archive preserves backlinks.

---

## 2 · Note layout (every file)

Every note **must** start with this YAML frontmatter:

```yaml
---
title: "<Human-readable title>"
created: 2026-05-08
updated: 2026-05-08
type: <one of: project | session | paper | concept | dataset | decision | experiment | moc | area | inbox | tool | book>
status: <one of: draft | active | review | done | archived | blocked>
tags: [type/<type>, status/<status>, domain/<domain>, project/<slug-if-applicable>]
aliases: []                # optional, for [[wikilink|alias]] resolution
sources: []                # optional: DOIs, URLs, arXiv IDs
---
```

After the frontmatter:

1. `# <title>` (H1, identical to `title` field).
2. A **one-line summary** (italic), the same one MOC files use.
3. Body content.
4. `## Related` section at the bottom with `[[wikilinks]]` to backlinks
   (other notes, MOCs, parent project).
5. Inline tags (`#type/paper #domain/diffusion`) on a single line above
   `## Related` so they show as a tag cluster in graph view.

A note without a frontmatter block, an H1, a one-line summary, an inline
tag line, and at least one `[[wikilink]]` is **incomplete**. Fix it before
committing.

---

## 3 · Map of Content (MOC) files

Every folder gets a `_MOC.md`. Underscore prefix forces it to sort to the
top of the folder. The MOC's job is to give a one-line summary of every
file in its folder, plus links to child MOCs.

`_MOC.md` skeleton (use the template at `06_Meta/templates/moc.md`):

```markdown
---
title: "MOC — <Folder Human Name>"
type: moc
updated: 2026-05-08
tags: [type/moc]
---

# MOC — <Folder Human Name>

*One-paragraph purpose of this folder.*

## Children

- [[_MOC|<subfolder MOC>]] — <one-line>
- [[<file-slug>|<File Title>]] — <one-line summary>

## Parent

- [[../_MOC|<Parent folder>]]

#type/moc
```

**Rule (mandatory):** when a skill or human creates a new note in a
folder, the same operation **must** add a one-line entry for that note in
the folder's `_MOC.md`. The `moc-update` skill exists for this; invoke it
instead of editing MOCs by hand.

---

## 4 · Filename conventions

| Kind                   | Pattern                                        | Example                                          |
|------------------------|------------------------------------------------|--------------------------------------------------|
| MOC                    | `_MOC.md`                                      | `01_Projects/repa-maisi-3d-mri/_MOC.md`          |
| Project README         | `_README.md`                                   | `01_Projects/repa-maisi-3d-mri/_README.md`       |
| Coding session         | `YYYY-MM-DDTHHMM--<kebab-slug>.md`             | `2026-05-08T1430--vae-lesion-recon-feasibility.md` |
| Decision (ADR-style)   | `NNNN--<kebab-slug>.md`                        | `0007--switch-to-flow-matching.md`               |
| Experiment             | `YYYY-MM-DD--<kebab-slug>.md`                  | `2026-05-08--ablation-repa-weight.md`            |
| Paper note             | `<first-author><year>--<kebab-title-slug>.md`  | `ho2020--ddpm.md`                                |
| Concept (Zettel)       | `<kebab-slug>.md`                              | `flow-matching-objective.md`                     |
| Dataset                | `<kebab-slug>.md`                              | `brats-gli-2024.md`                              |
| Inbox capture          | `YYYY-MM-DDTHHMM--<kebab-slug>.md`             | `2026-05-08T0930--idea-rare-finding-prior.md`    |

- All slugs are **lowercase kebab-case**. No spaces, no underscores in
  filenames except for the `_MOC` / `_README` sentinel prefix.
- Use ISO 8601 timestamps with `T` separator. `T1430` is 14:30 local;
  always use 24-h. The timezone is implicit (Europe/Madrid).

---

## 5 · Linking strategy

- **Wikilinks `[[Note Title]]`** are the primary connection. Every note
  must link to ≥1 other note (its MOC or a related concept). Orphans
  weaken the graph.
- Resolve link targets with full file titles. If a target lacks a unique
  title, use `[[path/to/file|Display Name]]`.
- A new project must link from `01_Projects/_MOC.md` and from any related
  `03_Resources/concepts/*.md` and `03_Resources/papers/*.md` it builds
  on.
- A new paper note must link from `03_Resources/papers/<topic>/_MOC.md`
  and from any project that cites it.
- A new concept Zettel must link from `03_Resources/concepts/_MOC.md` and
  from at least one other concept (to seed the graph).

---

## 6 · Tagging contract

Tags live in **two** places, both required:

1. **YAML frontmatter** `tags:` field — canonical, parsed by Dataview /
   plugins / search.
2. **Inline `#tag` line** above `## Related` — visible to humans, picked
   up by Obsidian graph view.

Use the **canonical taxonomy** at `06_Meta/tag-taxonomy.md`. Hierarchical
(nested) tags only — `#type/paper`, `#domain/diffusion-models`,
`#project/repa-maisi`. Never invent a top-level namespace without adding
it to the taxonomy file in the same commit.

Mandatory tags per note type:

| Note type   | Required tags                                               |
|-------------|-------------------------------------------------------------|
| project     | `type/project`, `status/<x>`, `domain/<x>`                  |
| session     | `type/session`, `project/<slug>`, `status/done`             |
| paper       | `type/paper`, `domain/<x>`, `venue/<x>` (if applicable)     |
| concept     | `type/concept`, `domain/<x>`                                |
| dataset     | `type/dataset`, `domain/<x>`                                |
| decision    | `type/decision`, `project/<slug>`                           |
| experiment  | `type/experiment`, `project/<slug>`, `status/<x>`           |
| moc         | `type/moc`                                                  |

---

## 7 · Skills you (Claude) should use here

The vault ships these skills under `.claude/skills/`. Prefer them over
ad-hoc edits — they encode the rules above so you don't have to.

| Skill                | When to invoke                                                                 |
|----------------------|--------------------------------------------------------------------------------|
| `vault-sync`         | At the start (pull) and end (commit + push) of every session.                  |
| `coding-session-log` | After any meaningful coding interaction in a project.                          |
| `paper-note`         | When the user shares a paper / DOI / arXiv link to capture.                    |
| `project-init`       | When the user starts a new project. Scaffolds all subfolders and MOCs.         |
| `moc-update`         | After creating any note. Adds the one-line entry to its folder's `_MOC.md`.    |

If the user describes a task that maps to a skill, invoke that skill
rather than rolling your own steps.

---

## 8 · What NOT to write into the vault

- **Secrets**: API keys, tokens, hospital identifiers, patient data, raw
  DICOM headers with PHI. Never. Use placeholders and store secrets
  outside the vault.
- **Large binaries**: model weights, training data, datasets. Reference
  them by path / URL / DOI. The `05_Attachments/` folder is for figures
  and PDFs only.
- **Auto-generated logs**: SLURM stdout, raw TensorBoard exports.
  Summarise into an `experiments/` note and link out.
- **Speculation as fact**: clearly mark hypotheses with
  `> [!hypothesis]` callouts (Obsidian admonitions) and tag
  `#status/draft`.

---

## 9 · Quality gate (before pushing)

A note is ready to commit when **all** of:

- [ ] Frontmatter complete (all required fields).
- [ ] H1 matches `title`.
- [ ] One-line italic summary present.
- [ ] At least one `[[wikilink]]` to another note.
- [ ] Inline `#tag` line present.
- [ ] Folder `_MOC.md` updated with this note's one-liner.
- [ ] Filename matches its type's naming pattern (§ 4).

If any item fails, fix it before `git push`.
