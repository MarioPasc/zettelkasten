# zettlekasten

Personal Obsidian + Git knowledge base for biomedical AI research.
Maintained jointly by **Mario Pascual González** and Claude agents
(Claude Code, Claude in browser).

> *Slow knowledge accrues here. Fast scratch goes in `00_Inbox/` first.*

## Quick orientation

- [[CLAUDE]] — operating contract for AI agents writing into the vault.
  Read first.
- [[99_Index]] — top-level Map of Content.
- [[06_Meta/conventions]] — filename / frontmatter / link conventions.
- [[06_Meta/tag-taxonomy]] — canonical tag namespace.
- [[06_Meta/templates/coding-session]] — template for session logs.

## Structure (PARA + Zettelkasten hybrid)

| Folder            | Purpose                                            | Lifetime           |
|-------------------|----------------------------------------------------|--------------------|
| `00_Inbox/`       | Quick captures, unprocessed                        | Days               |
| `01_Projects/`    | Active research / code projects                    | Weeks – months     |
| `02_Areas/`       | Ongoing responsibilities (PhD apps, reviewing, …)  | Years              |
| `03_Resources/`   | Papers, concepts, books, datasets, tools (Zettel)  | Permanent          |
| `04_Archive/`     | Completed / abandoned                              | Long-term storage  |
| `05_Attachments/` | Figures, PDFs, images                              | Tied to references |
| `06_Meta/`        | Templates, conventions, tag taxonomy               | Infrastructure     |

The numeric prefix is a navigation aid — file managers and Obsidian's
file pane sort numerically. Do not rename or reorder.

## Opening the vault

1. Clone: `git clone git@github.com:<you>/zettlekasten.git`
2. Open Obsidian → **Open folder as vault** → select the cloned directory.
3. Install community plugins (see § Setup below).

## Working with Claude

- **In a coding repo**, run `claude` from the repo root and ask it to
  write a session log into this vault. Claude reads `CLAUDE.md` from the
  vault on every relevant action.
- **In Claude.ai**, share the vault path or paste relevant notes; Claude
  will respect the conventions when generating new ones.

## Setup (Debian 12)

See `06_Meta/conventions.md` § "Setup checklist" for the full list. TL;DR:

```bash
sudo apt update
sudo apt install -y git curl ripgrep fd-find
# Obsidian: download .deb from https://obsidian.md and `sudo apt install ./obsidian_*.deb`
# Claude Code: see https://docs.claude.com/en/docs/claude-code
```

Recommended Obsidian community plugins:

- **Obsidian Git** — auto-commit, auto-pull, in-Obsidian git ops
- **Templater** — programmable templates triggered by hotkey
- **Dataview** — query notes by frontmatter (e.g., "all #type/paper from
  2026")
- **Tag Wrangler** — rename / refactor tags safely
- **Iconize** *(optional)* — visually distinguish folder roles

#type/moc
