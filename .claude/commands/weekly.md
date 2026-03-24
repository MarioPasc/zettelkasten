Scaffold a weekly journal entry for the current week.

## Instructions

1. Determine the current ISO week number and year (YYYY-Www).
2. Calculate the Monday and Sunday dates for that week.
3. Check if `04-journal/weekly/YYYY-Www.md` already exists.
   - If it does, open it and ask if I want to add to it.
   - If not, create it using the `06-templates/weekly.md` template.
4. Fill in the frontmatter: `week`, `date_start` (Monday), `date_end` (Sunday).
5. Under **Changed this week**, run `git log --since="<monday>" --until="<sunday>" --oneline` and list the vault changes.
6. Show me the scaffolded note so I can start filling it in.
