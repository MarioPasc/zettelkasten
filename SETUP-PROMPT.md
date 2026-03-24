# Claude Code Setup Prompt — Knowledge Vault Bootstrap

**Paste this into Claude Code to initialise your vault.**

---

Set up my Obsidian vault as a general-purpose Zettelkasten. The vault is
already a git repository. Perform these steps in order:

## 1. Create the folder structure

```
00-inbox/
00-inbox/archive/
01-sources/
02-notes/
03-projects/
04-journal/weekly/
04-journal/monthly/
05-moc/
06-templates/
assets/
.claude/commands/
```

Create each directory. Add a `.gitkeep` to empty directories so git tracks
them.

## 2. Install CLAUDE.md

Place the provided `CLAUDE.md` at the vault root. Read it — it is your
permanent instruction set for this vault.

## 3. Install templates into `06-templates/`

- `source.md` — for any external reference (paper, book, article, video)
- `note.md` — atomic Zettelkasten note
- `project.md` — living project document
- `weekly.md` — weekly journal entry
- `monthly.md` — monthly review
- `moc.md` — Map of Content

## 4. Install slash commands into `.claude/commands/`

- `weekly.md` — scaffold a weekly journal entry
- `source.md` — scaffold a source note for any reference type
- `connect.md` — find and suggest links across the vault
- `review.md` — monthly synthesis review
- `moc.md` — create or update a Map of Content
- `idea.md` — quick capture to inbox
- `tags.md` — audit the tag landscape
- `ask.md` — query the vault as a knowledge base

## 5. Set up `.gitignore`

```
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.DS_Store
.vault-sync.log
```

Do NOT ignore `.obsidian/` entirely — track plugins and settings.

## 6. Install `vault-sync.sh`

Place at vault root. Make executable: `chmod +x vault-sync.sh`.

## 7. Create seed content

### Projects
- `03-projects/thesis-meningioma-growth.md`: Bachelor's thesis on generative
  deep learning for longitudinal meningioma growth modelling (brain MRI,
  BraTS dataset). Advisor: Prof. Ezequiel López-Rubio, UMA. Status: active.
  Tags: `#project`, `#generative-models`, `#neuroimaging`, `#meningioma`,
  `#mri`, `#deep-learning`.

- `03-projects/thesis-symbolic-regression.md`: Reducing the search space of
  symbolic regression. Status: active. Tags: `#project`,
  `#symbolic-regression`, `#optimisation`.

### Seed MOCs (placeholders, to be expanded)
- `05-moc/moc-generative-models.md`: diffusion, flow matching, VAEs, GANs.
  Tags: `#moc`, `#generative-models`.
- `05-moc/moc-neuroimaging.md`: MRI, brain segmentation, BraTS, meningioma.
  Tags: `#moc`, `#neuroimaging`.
- `05-moc/moc-representation-learning.md`: latent spaces, equivariance,
  disentanglement. Tags: `#moc`, `#representation-learning`.

### First weekly note
Scaffold the current week's journal entry using the `/weekly` workflow.

## 8. Commit

`feat(vault): initial knowledge vault setup`

## 9. Verify

Run `find . -name "*.md" -not -path "./.obsidian/*" | sort` and show me
the full tree so I can confirm.

---

**Constraints:**
- Obsidian-flavoured Markdown only. No HTML.
- All frontmatter must be valid YAML.
- Folders encode note type. Tags encode topic. Never the reverse.
- Do not create content beyond what is specified here.
