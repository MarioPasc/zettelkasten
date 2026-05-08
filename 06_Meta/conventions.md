---
title: "Conventions"
type: moc
status: active
created: 2026-05-08
updated: 2026-05-08
tags: [type/moc, meta/conventions]
---

# Conventions

*Single source of truth for filename, frontmatter, link, and commit
conventions. `CLAUDE.md` enforces these on agents; this file is the
reference both humans and agents consult.*

## 1 · Filenames

| Kind                 | Pattern                                         |
|----------------------|-------------------------------------------------|
| MOC                  | `_MOC.md`                                       |
| Project README       | `_README.md`                                    |
| Coding session       | `YYYY-MM-DDTHHMM--<kebab-slug>.md`              |
| Decision (ADR-style) | `NNNN--<kebab-slug>.md` *(zero-padded counter)* |
| Experiment           | `YYYY-MM-DD--<kebab-slug>.md`                   |
| Paper note           | `<author><year>--<kebab-title-slug>.md`         |
| Concept              | `<kebab-slug>.md`                               |
| Dataset              | `<kebab-slug>.md`                               |
| Inbox capture        | `YYYY-MM-DDTHHMM--<kebab-slug>.md`              |

Rules: lowercase kebab-case, ASCII only, no spaces, no underscores
(except sentinel prefixes `_MOC` / `_README`). ISO 8601 timestamps with
`T` separator, 24-hour. Timezone implicit (Europe/Madrid).

## 2 · Frontmatter

Every note begins with this block. Required fields are marked **R**.

```yaml
---
title: "<Human-readable title>"          # R
created: YYYY-MM-DD                       # R, set on creation only
updated: YYYY-MM-DD                       # R, bump on every edit
type: <see § 3>                           # R
status: <see § 3>                         # R
tags: [type/<x>, status/<x>, ...]         # R, ≥3 tags
project: <slug-or-empty>                  # if relevant
aliases: []                               # for [[wikilink|alias]]
sources: []                               # DOIs, arXiv IDs, URLs
---
```

## 3 · Type and status enumerations

`type ∈ { project, session, paper, concept, dataset, decision, experiment,
moc, area, inbox, tool, book }`

`status ∈ { draft, active, review, done, archived, blocked }`

## 4 · Body layout

```markdown
# <Title>

*One-line italic summary used by MOCs.*

<body>

## Related
- [[<wikilink>]] — short reason
- [[<wikilink>]] — short reason

#type/<x> #status/<x> #domain/<x>
```

The inline tag line must be the **last** non-empty line in the file. The
graph view uses tags as nodes only when they appear in the body; YAML
tags are also indexed but the body line guarantees graph density.

## 5 · Links

- Prefer wikilinks `[[Note Title]]` over markdown links.
- Use relative paths `[[03_Resources/concepts/repa-loss]]` when the title
  isn't unique.
- Pipe-aliases for display: `[[long-canonical-slug|short label]]`.
- For DOIs, write `[doi:10.xxx/yyy](https://doi.org/10.xxx/yyy)` and add
  the DOI to `sources:` in frontmatter.

## 6 · Map of Content (MOC) discipline

Every folder owns one `_MOC.md`. New notes in that folder must be added
to its MOC in the same commit. Use the `moc-update` skill — never edit
MOCs by hand if you can avoid it.

## 7 · Commit messages

Conventional Commits, scoped to top-level folder:

```
<type>(<scope>): <subject>
```

`<type> ∈ { add, update, refactor, fix, archive, meta }`.

Examples:

- `add(projects/repa-maisi): coding session 2026-05-08T1430`
- `update(papers/diffusion): refine REPA notes after second read`
- `archive(projects/old-thing): move to 04_Archive after wrap-up`

## 8 · Setup checklist (Debian 12)

```bash
# Core
sudo apt update
sudo apt install -y git curl build-essential ripgrep fd-find

# Node (for Claude Code, Obsidian plugins from source if needed)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Python + uv (for Claude Code skills with Python deps)
sudo apt install -y python3 python3-venv python3-pip pipx
pipx install uv

# GitHub CLI (optional but useful for Claude Code)
sudo apt install -y gh
gh auth login

# Obsidian
# Download from https://obsidian.md (DEB build); then:
# sudo apt install ./obsidian_<version>_amd64.deb

# Claude Code
# Follow https://docs.claude.com/en/docs/claude-code/setup

# SSH key for GitHub (recommended over HTTPS for Obsidian Git plugin)
ssh-keygen -t ed25519 -C "<your-email>"
cat ~/.ssh/id_ed25519.pub   # add to GitHub → Settings → SSH keys
```

Obsidian community plugins (install via Settings → Community Plugins):

| Plugin            | Why                                                          |
|-------------------|--------------------------------------------------------------|
| Obsidian Git      | Auto-pull on startup, auto-commit on interval, push on save  |
| Templater         | Hotkey-driven templates with date/title interpolation        |
| Dataview          | SQL-like queries over frontmatter                            |
| Tag Wrangler      | Bulk rename / refactor tags                                  |
| Iconize *(opt.)*  | Folder icons; visually separates `01_Projects` from `03_…`   |
| Excalidraw *(opt.)* | Hand-drawn diagrams embedded in notes                      |

### Obsidian Git settings (recommended)

- Auto pull on startup: **on**
- Commit interval (auto-backup): **5–10 min** *(disable if you prefer
  manual commits via Claude Code)*
- Push on commit: **on**
- Auth: SSH (leave plugin user/password blank; uses system SSH agent)
- Conflict strategy: notify (Obsidian Git creates a conflict note)

#type/moc #meta/conventions
