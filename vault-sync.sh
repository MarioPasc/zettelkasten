#!/usr/bin/env bash
# vault-sync.sh — Auto-commit and push the Obsidian vault
#
# Usage:
#   ./vault-sync.sh                      # run manually
#   */30 * * * * cd /path/to/vault && ./vault-sync.sh >> .vault-sync.log 2>&1
#
# Ensures that notes written directly in Obsidian (without Claude Code)
# are version-controlled automatically.

set -euo pipefail

VAULT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$VAULT_DIR"

if git diff --quiet && git diff --cached --quiet; then
    echo "[$(date -Iseconds)] No changes to commit."
    exit 0
fi

git add -A

CHANGED=$(git diff --cached --name-only | head -5)
N_CHANGED=$(git diff --cached --name-only | wc -l)

if [ "$N_CHANGED" -le 5 ]; then
    MSG="docs(vault): auto-sync $(echo "$CHANGED" | tr '\n' ', ' | sed 's/,$//')"
else
    MSG="docs(vault): auto-sync ${N_CHANGED} files"
fi

git commit -m "$MSG"

if git remote get-url origin &>/dev/null; then
    git push --quiet
    echo "[$(date -Iseconds)] Pushed ${N_CHANGED} changed file(s)."
else
    echo "[$(date -Iseconds)] Committed ${N_CHANGED} file(s) (no remote)."
fi
