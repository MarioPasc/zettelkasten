Perform a monthly synthesis review.

## Instructions

1. Determine the current or most recent completed month (YYYY-MM).
2. Check if `04-journal/monthly/YYYY-MM.md` exists. If not, create it from `06-templates/monthly.md`.
3. Gather data for the review:
   - `git log --since="YYYY-MM-01" --until="<first of next month>" --oneline` for vault activity.
   - List all notes created this month (by `created` frontmatter field).
   - List all source notes processed this month.
   - Identify recurring tags across this month's notes.
4. Fill in the **New Notes Added** and **Sources Processed** sections automatically.
5. Under **Recurring Themes**, analyse tag co-occurrence and note clusters.
6. Under **Cross-Domain Connections Made**, highlight the most interesting links created this month.
7. Leave **Narrative**, **Open Questions**, **Stalled Threads**, and **Next Month** for me to fill in, but add prompting comments if patterns suggest something.
8. Read the weekly notes for this month and synthesise any patterns.
9. Show me the draft review.
