Quick capture an idea to the inbox.

## Arguments

$ARGUMENTS — the idea, thought, or fleeting note to capture.

## Instructions

1. Create a new file in `00-inbox/` with a timestamped filename: `00-inbox/YYYY-MM-DD-<slug>.md`.
2. Add minimal frontmatter:
   ```yaml
   ---
   title: "<one-line summary>"
   tags: [inbox]
   created: YYYY-MM-DD
   ---
   ```
3. Write the idea in the body. Keep it raw — this is a fleeting note, not a polished atomic note.
4. If the idea clearly relates to existing notes, add `[[wikilinks]]` and suggest which tags might apply when it gets promoted to `02-notes/`.
5. Confirm the capture with the filename.
