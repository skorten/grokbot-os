# Saved views for bots

Bots query Notion databases **only** through these saved views. Never SQL mode or rows mode (those draw down a capped workspace allowance and bypass the agreed filters). Search and page fetch are fine anywhere. Need a view that doesn't exist? Ask Notion Librarian to add it. Librarian is the only Notion write path, views included.

After creating each view, record its reference in each bot profile where `{{VIEW:...}}` appears.

| View | Database | Filter | Sort | Columns | Used for |
|---|---|---|---|---|---|
| Open tasks (bots) | Tasks | Status is not Done | Due Date ascending | Name, Status, todo_type, Priority, Due Date, Follow up, Type, Notes | Main read for open work, the stale sweep, duplicate checks |
| Waiting on others (bots) | Tasks | Status is not Done AND todo_type = Others' work | Follow up ascending | Name, Status, Follow up, Due Date, Notes | Chief of Staff's follow-up list |
| Active projects (bots) | Projects | Status = Active | (any) | Name, Status, Type, Notes, Tasks | Project context for briefs and routing |
| *Optional:* <Product> board (bots) | each sandbox Backlog / Delivery | none | grouped by Status | all | Dev Pod board reads; add one per database before the pod uses it |

All are table views. Notes and Categories have no bot view; bots use search and fetch for those.
