#!/usr/bin/env bash
# .claude/scripts/validate-notes.sh
#
# Walks the vault and verifies that every content .md file satisfies the
# quality gate from CLAUDE.md § 9.
#
# Skipped paths:
#   - 06_Meta/templates/*    (template literals; placeholders aren't real)
#   - CLAUDE.md, README.md, SETUP.md, 99_Index.md   (operational / meta)
#
# Required for content notes:
#   - YAML frontmatter present (--- delimited at top)
#   - frontmatter has at least: title, type, tags
#   - non-MOC notes additionally have: status
#   - body has an H1
#   - body has at least one [[wikilink]]
#   - body has an inline #tag line
#
# Run from the vault root:
#   bash .claude/scripts/validate-notes.sh
#
# Exits non-zero if any note fails. Prints a per-note report.

set -u
shopt -s globstar nullglob

declare -i fails=0

is_skipped() {
    local f=$1
    case "$f" in
        06_Meta/templates/*) return 0 ;;
        CLAUDE.md|README.md|SETUP.md|99_Index.md) return 0 ;;
    esac
    return 1
}

is_moc() {
    local f=$1
    [[ "$(basename "$f")" == "_MOC.md" ]]
}

check_note() {
    local f=$1
    local errs=()

    is_skipped "$f" && return 0

    local content
    content=$(cat "$f")

    # Frontmatter present
    if ! [[ $content =~ ^---[[:space:]]*$'\n' ]]; then
        errs+=("missing YAML frontmatter")
    else
        # Required for everything
        for key in title type tags; do
            if ! grep -qE "^${key}:" <<< "$content"; then
                errs+=("frontmatter missing key: ${key}")
            fi
        done
        # status is required for non-MOC notes
        if ! is_moc "$f"; then
            if ! grep -qE "^status:" <<< "$content"; then
                errs+=("frontmatter missing key: status")
            fi
        fi
    fi

    # H1
    if ! grep -qE "^# " <<< "$content"; then
        errs+=("missing H1")
    fi

    # ≥1 wikilink
    if ! grep -qE '\[\[[^]]+\]\]' <<< "$content"; then
        errs+=("no [[wikilink]] in body")
    fi

    # Inline tag line
    if ! grep -qE '^#[a-z][a-z0-9/_-]*' <<< "$content"; then
        errs+=("no inline #tag line")
    fi

    if (( ${#errs[@]} > 0 )); then
        printf 'FAIL %s\n' "$f"
        for e in "${errs[@]}"; do printf '     - %s\n' "$e"; done
        return 1
    fi
    return 0
}

for f in **/*.md; do
    check_note "$f" || ((fails++))
done

if (( fails > 0 )); then
    printf '\n%d note(s) failed the quality gate.\n' "$fails" >&2
    exit 1
fi
printf 'All notes passed the quality gate.\n'
