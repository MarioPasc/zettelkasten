Audit the tag landscape of the vault.

## Instructions

1. Scan all Markdown files in the vault (excluding `06-templates/` and `.obsidian/`).
2. Extract all tags from both frontmatter `tags:` arrays and inline `#tag` usage.
3. Produce a report:
   - **Tag frequency**: each tag with its count, sorted descending.
   - **Orphan tags**: tags used only once — candidates for merging or renaming.
   - **Near-duplicates**: tags that look like variants of each other (e.g., `#optimisation` vs `#optimization`, `#dl` vs `#deep-learning`).
   - **Untagged notes**: files missing topic tags (only type tags like `#note` or `#source`).
   - **Tag clusters**: groups of tags that frequently co-occur, suggesting potential MOC topics.
4. Suggest concrete actions (merge, rename, split) but do not apply them without my approval.
