# Notion schema

Generic starting schema. Adapt it to the owner's needs; don't copy it blindly. Notion Librarian is the only bot that writes any of this once it exists.

## Design rules
- One tracker per job. Search before creating a database; reuse one that already fits.
- Keep databases few.
- Every database has a `Created` (created time) property and closed-set `Status` and `Type` options.
- To retire a page, move it under Archive. To retire a row in Tasks, Projects, Backlog, or Delivery, set Status to Archived. Bot views exclude Status Archived. Never delete.
- Categories and Todo types are databases, not selects, so the lists are shared, defined in one place, and changed only through Librarian.

## Relations
| From | Property | To | Cardinality |
|---|---|---|---|
| Tasks | Project | Projects | optional, single |
| Tasks | Category | Categories | multi |
| Tasks | Todo type | Todo types | two-way, single |
| Notes | Category | Categories | multi |
| Notes | Related Project | Projects | optional, single |

Back-links appear on the target: Projects gets `Tasks` and `Related Notes`; Categories gets `Tasks` and `Notes`; Todo types gets `Tasks`.

---

## Tasks
The owner's only to-do list. Lives at the top of the private sidebar.

| Property | Type | Values / notes |
|---|---|---|
| Name | title | |
| Status | select | Not Started, In Progress, Done, Archived |
| Priority | select | High, Medium, Low, None |
| Todo type | relation → Todo types | two-way, one per task |
| Type | select | Work, Personal |
| Due Date | date | Real deadlines only |
| Follow up | date | When Chief of Staff next checks an item that isn't Do / own. Effectively required when Todo type is Others' work |
| Created | created time | |
| Notes | text | What, why, next step, source, or a link to a page that has them. No bare titles |
| Category | relation → Categories | multi |
| Project | relation → Projects | optional |

**Todo type:** only `Do / own` is owned work; the other five are tracked, not owned. Don't add, replace, or collapse values without the owner's yes.

Human views (for the owner, not bots): Default; Oldest First (Status is not Done and not Archived, Created ascending); Personal Open.

## Projects
Multi-week efforts only. Lives under Operating system.

| Property | Type | Values / notes |
|---|---|---|
| Name | title | |
| Status | select | Active, On Hold, Done, Archived |
| Type | select | Work, Personal |
| Notes | text | Brief |
| Created | created time | |
| Tasks | relation (back-link from Tasks.Project) | |
| Related Notes | relation (back-link from Notes.Related Project) | |

A project page holds its brief, a decision log, and optionally project-only databases (below).

## Notes
Lasting reference: decisions, protocols, numbers, build notes. Lives under Operating system.

| Property | Type | Values / notes |
|---|---|---|
| Name | title | |
| Type | select | Work, Personal |
| Category | relation → Categories | multi |
| Related Project | relation → Projects | optional |
| Created | created time | |

## Todo types
The six kinds of task. Lives under Operating system, next to Categories. Seed it from `todo-types-seed.csv`.

| Property | Type | Values / notes |
|---|---|---|
| Name | title | Do / own, Raise/influence, Standing posture, Team norms, Watch/risk, Others' work |
| Definition | text | One line |
| Owned | checkbox | True only for Do / own |
| Created | created time | |
| Tasks | relation (back-link from Tasks.Todo type) | |

## Categories
Shared tag list for Tasks and Notes. Lives under Operating system. Seed it from `categories-seed.csv` (import the Name column; Group and Notes are guidance for the owner, not properties). The file is an example. The owner edits it before seeding. Check for near-matches before adding a new one.

| Property | Type | Values / notes |
|---|---|---|
| Name | title | |
| Created | created time | |
| Tasks | relation (back-link) | |
| Notes | relation (back-link) | |

---

## Project-only databases (inside a project page, no relations)

**Meeting notes**
| Property | Type |
|---|---|
| Title | title |
| Date | date |
| Attendees | text |
| Summary | text |
| Decisions | text |
| Action items | text |
| Meeting notes link | URL |

**Work board**
| Property | Type | Values |
|---|---|---|
| Name | title | |
| Status | select | Backlog, Next, In Progress, Waiting, Done |
| Owner | text | |
| Due | date | |
| Notes | text | |

## Dev sandbox boards (per product, no relations)
Each product under the Dev Pod sandbox gets its own pair, copied from a template product.

**Backlog**
| Property | Type | Values |
|---|---|---|
| Name | title | |
| Type | select | Story, Bug, Spike, Chore |
| Status | select | Todo, Working, Blocked, Ready for Review, Done, Archived |
| Priority | select | P0, P1, P2, P3 |
| Acceptance criteria | text | |
| Estimate | number | |
| Owner | person | |
| Product | text or select | |
| Sprint | text or select | |

**Delivery**
| Property | Type | Values |
|---|---|---|
| Name | title | |
| Status | select | Planned, Active, At Risk, Done, Archived. At Risk is the blocked signal |
| Milestone | text | |
| Target date | date | |
| Dependencies | text | |
| Notes | text | |

## Agent change log
An inline database on the bot rules page (Agent README). Librarian adds one row per write it signs off; the owner reviews.

| Property | Type | Values / notes |
|---|---|---|
| Agent | title | Which bot asked for the write |
| Page | URL | The page written |
| Action | select | create, append, update, move, archive, restore, delete, refused |
| Time | date (with time) | |
| Summary | text | One line |
| Reviewed | checkbox | The owner checks it |

Attribution here is an honor-system record for tracing, not proof: if every bot signs in to Notion as the owner, Notion itself can't tell them apart. On lower Notion plans page history is short, so this log may be the only lasting record of who changed what.
