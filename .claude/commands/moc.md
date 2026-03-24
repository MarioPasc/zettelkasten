Create or update a Map of Content.

## Arguments

$ARGUMENTS — the topic for the MOC (e.g. "generative models", "group theory").

## Instructions

1. Search the vault for all notes tagged with the topic or closely related tags.
2. If `05-moc/moc-<slugified-topic>.md` already exists:
   - Read the existing MOC.
   - Identify notes that should be listed but are missing.
   - Suggest additions and reorganisation. Apply changes only with my approval.
3. If the MOC does not exist:
   - Check that there are at least 5 related notes (sources + atomic notes). If fewer, warn me but proceed if I confirm.
   - Create the MOC from `06-templates/moc.md`.
   - Fill in **Overview** with a brief synthesis of the topic based on existing notes.
   - Populate **Core Concepts** with `[[wikilinks]]` to atomic notes, ordered for a newcomer.
   - Populate **Key Sources** with `[[wikilinks]]` to source notes.
   - Add **Bridges** to other MOCs or topic clusters that intersect.
4. Update the `updated` field in frontmatter.
5. Show me the result.
