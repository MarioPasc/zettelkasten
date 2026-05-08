# SETUP — first-time vault setup on Debian 12

This is the bootstrap procedure for a fresh Debian 12 machine. After it,
the vault is functional in Obsidian, hooked up to GitHub, and ready for
Claude Code to write into it.

## 1 · System packages

```bash
sudo apt update
sudo apt install -y \
    git curl ca-certificates build-essential \
    ripgrep fd-find \
    python3 python3-venv python3-pip pipx
```

`ripgrep` and `fd-find` are not strictly required but make Claude's
search-the-vault operations an order of magnitude faster.

> Debian renames `fd` to `fdfind` to avoid a collision; symlink it if
> you prefer:
>
> ```bash
> mkdir -p ~/.local/bin
> ln -s "$(which fdfind)" ~/.local/bin/fd
> ```

## 2 · Node.js (LTS)

Required by Claude Code and several Obsidian plugins.

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
node --version    # should be ≥20
```

## 3 · Python tooling (`uv`)

`uv` is the fast Python package manager that Claude Code skills with
Python dependencies use by default.

```bash
pipx ensurepath
pipx install uv
uv --version
```

## 4 · Obsidian

Download the `.deb` from <https://obsidian.md> (or AppImage if you
prefer no-install). Install:

```bash
sudo apt install ./obsidian_<version>_amd64.deb
```

> Avoid the Flatpak / Snap builds if you want Claude Code to run inside
> Obsidian — they sandbox filesystem access and break the path the
> Claude CLI expects.

## 5 · GitHub authentication (SSH)

```bash
ssh-keygen -t ed25519 -C "<your-email>"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
# Paste into GitHub → Settings → SSH and GPG keys → New SSH key
ssh -T git@github.com   # should greet you
```

Optional but useful: GitHub CLI for Claude Code workflows.

```bash
sudo apt install -y gh
gh auth login
```

## 6 · Clone the vault

```bash
cd ~
git clone git@github.com:<your-username>/zettlekasten.git
cd zettlekasten
```

## 7 · Open in Obsidian

Launch Obsidian → **Open folder as vault** → select
`~/zettlekasten`. Trust the vault when prompted.

## 8 · Install Obsidian community plugins

Settings → Community plugins → **Turn on community plugins** → Browse,
then install and enable:

| Plugin            | Notes                                                        |
|-------------------|--------------------------------------------------------------|
| Obsidian Git      | Settings: auto-pull on startup ✓, commit interval 5–10 min, push on commit ✓, auth blank (uses system SSH agent) |
| Templater         | Point templates folder to `06_Meta/templates`                |
| Dataview          | Enable JS queries if you want ad-hoc dashboards              |
| Tag Wrangler      | For renaming tags safely as the taxonomy evolves             |
| Iconize *(opt.)*  | Folder icons; visually separates `01_Projects` from `03_Resources` |

## 9 · Install Claude Code

Follow <https://docs.claude.com/en/docs/claude-code>. After install:

```bash
cd ~/zettlekasten
claude
```

The vault's `CLAUDE.md` is loaded automatically. The skills under
`.claude/skills/` become discoverable. Verify by asking:

```
List the skills available in this vault.
```

You should see `vault-sync`, `coding-session-log`, `paper-note`,
`project-init`, and `moc-update`.

## 10 · (Optional) third-party skills

Two external skill collections are worth considering. Install only
those you'll actively use; more skills = more context churn.

### Matt Pocock's engineering skills

<https://github.com/mattpocock/skills> — useful complements when you
work on the *code* side of a project (TDD, refactor planning, git
guardrails). Add to `~/.claude/skills/` (user-global), **not** to this
vault's `.claude/skills/`:

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/mattpocock/skills.git /tmp/mp-skills
cp -r /tmp/mp-skills/skills/git-guardrails-claude-code ~/.claude/skills/
cp -r /tmp/mp-skills/skills/grill-me                  ~/.claude/skills/
cp -r /tmp/mp-skills/skills/write-a-prd                ~/.claude/skills/
cp -r /tmp/mp-skills/skills/prd-to-plan                ~/.claude/skills/
# Skip mattpocock/skills/personal/obsidian-vault — its assumptions (flat
# vault, no folders, Title Case filenames) directly contradict ours.
```

### Reference vault patterns (read, don't install)

For ideas, not for installation:

- <https://github.com/heyitsnoah/claudesidian> — same PARA-numbered
  layout, more aggressive automation. Has interesting Firecrawl-based
  ingestion scripts.
- <https://github.com/ballred/obsidian-claude-pkm> — opinionated PKM
  starter with output-style "accountability coach" patterns.
- <https://github.com/lucasrosati/claude-code-memory-setup> — pairs an
  Obsidian Zettelkasten with a code-graph tool; useful if you want
  per-repo CLAUDE.md ↔ vault links later.

## 11 · First commit

The vault ships scaffolded; nothing to do unless you customised. To
verify Claude can drive the lifecycle:

```bash
cd ~/zettlekasten
claude
# Then say to Claude:
#   "Run the vault-sync skill."
# It should pull (no-op), report clean, and exit cleanly.
```

## 12 · (Optional) Obsidian-side `.gitignore` audit

The shipped `.gitignore` ignores per-machine Obsidian state
(`workspace.json`, cache, etc.) but tracks plugin lists and themes. If
you want fully fresh `.obsidian/` per machine, replace the relevant
block with:

```
.obsidian/*
!.obsidian/snippets/
!.obsidian/themes/
```

That's it. The vault is live.
