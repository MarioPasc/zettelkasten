Query the vault as a knowledge base.

## Arguments

$ARGUMENTS — the question to answer using vault contents.

## Instructions

1. Parse the question and identify relevant topics, tags, and concepts.
2. Search the vault systematically:
   - Check MOCs for topic overviews.
   - Search source notes for relevant references.
   - Search atomic notes for related concepts.
   - Check project notes for relevant context.
3. Synthesise an answer drawing **only** from vault contents. Clearly distinguish:
   - What the vault says (with `[[wikilinks]]` to specific notes).
   - What the vault does *not* cover (knowledge gaps).
4. If the question touches on something not in the vault, say so explicitly and suggest what sources or notes could fill the gap.
5. Cite specific notes for every claim: `[[note-title]]` or `[[source-title]]`.
6. Never fabricate connections that don't exist in the vault.
