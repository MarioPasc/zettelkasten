---
name: paper-note
description: Create a literature note for a single paper inside 03_Resources/papers/<topic>/, following the paper-note template. Use whenever the user shares a DOI, arXiv link, paper title, or PDF and asks to capture, summarise, take notes on, or "add this paper" to the vault.
---

# paper-note

Captures one paper into the Zettelkasten side of the vault. One paper =
one note. The note follows the template at
`06_Meta/templates/paper-note.md`.

## When to invoke

- The user shares a DOI, arXiv ID, paper title, or PDF path and asks to
  add it.
- The user says "take notes on this paper", "add this paper", "write a
  literature note", "capture this".
- After a `/research` or `/paper-discover`-style discovery, for each
  paper accepted into the reading list.

## Inputs to gather

1. **Paper identification** — DOI, arXiv ID, or canonical title +
   authors + year. Prefer DOI; arXiv ID otherwise.
2. **Topic folder** — one of `03_Resources/papers/<topic>/`. If the
   topic doesn't exist:
   - List existing topic folders: `ls 03_Resources/papers/`.
   - Ask whether to use one of them or create a new topic. If new,
     create the folder and its `_MOC.md` (use the MOC template).
3. **Filename slug** — `<firstauthor><year>--<short-kebab-title>.md`,
   e.g. `ho2020--ddpm.md`.
4. **PDF / source text** — if the user provided a PDF path or a URL,
   extract the abstract, contributions, method summary, and key
   results. Do not paraphrase more than is needed.

## Procedure

```bash
TOPIC="<topic-slug>"           # e.g. diffusion-models
SLUG="<firstauthor><year>--<short-title>"
TARGET="03_Resources/papers/${TOPIC}/${SLUG}.md"

mkdir -p "03_Resources/papers/${TOPIC}"
# If the topic _MOC.md doesn't exist, create it from 06_Meta/templates/moc.md
test -f "03_Resources/papers/${TOPIC}/_MOC.md" || cp 06_Meta/templates/moc.md "03_Resources/papers/${TOPIC}/_MOC.md"
```

1. Read the template: `06_Meta/templates/paper-note.md`.
2. Substitute: `title`, `authors`, `year`, `venue`, `sources` (DOI +
   arXiv URL), `tags` (mandatory: `type/paper`, `domain/<x>`,
   `venue/<x>` if applicable), `aliases` (full paper title for wikilink
   resolution).
3. Fill body sections:
   - **TL;DR** — 3 to 5 sentences.
   - **Problem** — the gap addressed.
   - **Method** — the technical core. Equations in `$$ ... $$`.
   - **Results** — headline numbers + the comparisons that matter.
   - **Strengths**, **Weaknesses / open questions** — bulleted.
   - **Relevance to my work** — concrete bullets linking to projects /
     concepts.
4. **Quotes**: keep direct quotes ≤15 words, one per source maximum.
   Default to paraphrase. Cite with section/page.
5. Required wikilinks in `## Related`:
   - The topic MOC: `[[03_Resources/papers/<topic>/_MOC|<Topic>]]`
   - Any project that builds on this paper.
   - At least one related concept; if none exists, propose creating one
     and ask the user.
6. Inline tag line: `#type/paper #domain/<x> #venue/<x> #status/draft`
   (status flips to `review` once the user reviews, `done` once
   integrated).
7. Write the file.
8. **Invoke the `moc-update` skill** to add a one-liner to the topic's
   `_MOC.md`.

## Quality gate

- [ ] Frontmatter complete (incl. `authors`, `year`, `venue`, `sources`).
- [ ] H1 matches `title`.
- [ ] One-line italic summary is the paper's takeaway (not "Notes on
      Ho et al.").
- [ ] No quote >15 words; ≤1 quote per source.
- [ ] At least one `[[wikilink]]` to a project or concept (not just the
      MOC).
- [ ] Inline `#tag` line present.
- [ ] Topic `_MOC.md` updated.

## What to keep out

- No reproduction of figures or tables verbatim from copyrighted PDFs.
  Describe in your own words; reference figure number for lookup.
- No paragraph-length quotes. Summarise.
- No invented citations. If a number is not in the paper, do not write it.
