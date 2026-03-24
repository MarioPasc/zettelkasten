Scaffold a source note for any reference type.

## Arguments

$ARGUMENTS — a description of the source (e.g. title, authors, URL, DOI, or free-text description).

## Instructions

1. Parse the provided information to extract: title, authors, year, type (paper | book | article | talk | video | podcast | webpage | thesis), venue, URL/DOI.
2. If critical fields are missing, search the web to fill them in. Ask me only if you cannot resolve ambiguity.
3. Generate a filename: `01-sources/<LastnameYYYY>-<slugified-short-title>.md` (e.g., `01-sources/Ho2020-denoising-diffusion.md`).
4. Check if a source note for this reference already exists in the vault. If so, tell me and stop.
5. Create the note using `06-templates/source.md`, filling in all frontmatter fields.
6. Add relevant topic tags beyond `#source`.
7. Scan `02-notes/` and `01-sources/` for related existing notes and add `[[wikilinks]]` under **Relevance**.
8. Show me the created note.
