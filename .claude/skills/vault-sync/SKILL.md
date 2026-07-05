---
name: vault-sync
description: Pull the latest from origin before writing into the Obsidian vault, and commit + push when the writing session is done. Use at the very start and very end of any session that creates, edits, or moves notes in this vault. Also use whenever the user says "save", "sync", or "push" the vault.
---

# vault-sync

Synchronises the vault with its GitHub remote. Run **once at the start**
of any writing session and **once at the end**. The vault's Git lifecycle
is documented in `CLAUDE.md` § 0.1; this skill is the executable form of
that rule.

## When to invoke

- At session start, before any `Write` / `Edit` into the vault.
- At session end, after the last note has been written and the relevant
  `_MOC.md` files have been updated.
- When the user explicitly says "save", "sync", "commit", or "push" the
  vault.

## Phase 1 — Pull (start of session)

```bash
cd "$VAULT_ROOT"          # detect from CWD or ask the user
git status --porcelain    # must be clean before pulling
git fetch origin
git pull --rebase origin main
```

Failure modes and responses:

- **Working tree dirty** → list the dirty paths to the user. Do not pull
  on top of uncommitted changes. Ask whether to stash or commit first.
- **Rebase conflict** → abort the rebase (`git rebase --abort`) and
  surface the conflicting paths. Do not auto-resolve. MOC conflicts in
  particular need human judgement because the order of children matters
  semantically.
- **No upstream / detached HEAD** → tell the user; do not guess.

## Phase 2 — Commit + push (end of session)

Before committing, confirm the per-note quality gate from `CLAUDE.md` § 9
on every file you wrote: frontmatter complete, H1 present, one-line
summary, ≥1 wikilink, inline tag line, MOC updated.

```bash
cd "$VAULT_ROOT"
git status
git add -A
git diff --cached --stat   # show the user what is about to be committed
```

Compose a Conventional Commit message scoped to the top-level folder
touched (see `CLAUDE.md` § 0.2):

```
<type>(<scope>): <subject>
```

If the session touched multiple top-level folders, prefer multiple
commits over one mega-commit. Group changes per scope:

```bash
git add 01_Projects/repa-maisi-3d-mri/
git commit -m "add(projects/repa-maisi): coding session 2026-05-08T1430"

git add 03_Resources/papers/
git commit -m "update(papers/diffusion): refine REPA notes"
```

Then:

```bash
git push origin main
```

If `git push` is rejected (non-fast-forward), **re-pull with rebase** and
retry; if that conflicts, hand control back to the user.

## What this skill does NOT do

- Does not auto-resolve merge conflicts.
- Does not force-push (`--force` / `--force-with-lease`). Ever.
- Does not bypass pre-commit hooks if the vault has any.
- Does not commit `.env`, `*.key`, or anything matching `.gitignore`
  patterns flagged as sensitive.
