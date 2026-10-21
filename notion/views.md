# Saved views for bots

Bots query Notion databases **only** through these saved views. Never SQL mode or rows mode (those draw down a capped workspace allowance and bypass the agreed filters). Search and page fetch are fine anywhere. While Notion Librarian is building or repairing a database or view, Librarian may read that database directly. Need a view that doesn't exist? Ask Notion Librarian to add it. Librarian is the only Notion write path, views included.

After creating each view, record its reference in each bot profile where `{{VIEW:...}}` appears.

Every bot view excludes Status `Archived`.

| View | Placeholder | Database | Filter | Sort | Columns | Used for |
|---|---|---|---|---|---|---|
| Open tasks (bots) | `{{VIEW:Open tasks}}` | Tasks | Status is not Done AND Status is not Archived | Due Date ascending | Name, Status, Todo type, Priority, Due Date, Follow up, Type, Notes | Main read for open work, the stale sweep, duplicate checks |
| Waiting on others (bots) | `{{VIEW:Waiting on others}}` | Tasks | Status is not Done AND Status is not Archived AND Todo type contains Others' work | Follow up ascending | Name, Status, Follow up, Due Date, Notes | Chief of Staff's follow-up list |
| All tasks (bots) | `{{VIEW:All tasks}}` | Tasks | Status is not Archived | Created descending | Name, Status, Todo type, Priority, Due Date, Follow up, Type, Notes | Duplicate checks and history, including Done tasks |
| Active projects (bots) | `{{VIEW:Active projects}}` | Projects | Status = Active | (any) | Name, Status, Type, Notes, Tasks | Project context for briefs and routing. Active excludes Archived |
| <Product> Backlog (bots) | `{{VIEW:<product> Backlog}}` | that product's Backlog | Status is not Archived | grouped by Status | all | Required when Dev Pod is installed. One view per product, before the pod uses it |
| <Product> Delivery (bots) | `{{VIEW:<product> Delivery}}` | that product's Delivery | Status is not Archived | grouped by Status | all | Required when Dev Pod is installed. One view per product, before the pod uses it. At Risk is the blocked signal |

All are table views. Notes, Categories, and Todo types have no bot view; bots use search and fetch for those.
