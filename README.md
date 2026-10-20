# Grok Bot OS

A starter kit for a personal Grok Bot fleet: single-job bots, a front-door Chief of Staff, a private Notion space with one writer, and approval gates on everything that leaves the box. Hand this folder to a blank Grok Bot and ask it to install it with you.

**Personal bots, one owner.** These are personal bots for a single owner. Never convert them to Team Bots or share them as templates. *Team Bot boundary:* personal rules (the private Notion gate, calendar privacy) belong only on the owner's personal bots; a Team Bot for coworkers is built fresh without them.

**Adapt, don't copy.** Keep the structure; change the bots, tools, times, and categories to fit you. You approve each bot before it's created.

## Contents
| Path | What it is |
|---|---|
| `README.md` | This file |
| `architecture.md` | How the system works, plus the step-by-step install written to the installing bot |
| `notion/schema.md` | Every database: properties, types, option sets, relations, design rules |
| `notion/views.md` | The saved views bots query through, and the views-only rule |
| `notion/page-tree.md` | The page outline and the bot rules page (Agent README) |
| `notion/categories-seed.csv` | Starter categories. Edit before seeding |
| `notion/todo-types-seed.csv` | The six Todo types with one-line definitions |
| `profiles/*.md` | One profile per bot: Chief of Staff, Notion Librarian, Admin Bot, Deep Research, Docs Writer, Dev Pod, Side Quest, Fleet Ops, Bot Designer |
| `routines.md` | Exactly five core routines with cron schedules and prompts, plus two optional add-ons |

## Order of use
1. Read `architecture.md` sections 1 to 7.
2. Fill in the placeholders (install step 0).
3. Create Bot Designer (step 1); it creates Notion Librarian (step 2).
4. Librarian builds Notion from `notion/`: pages, databases, seeds, views (step 3). The installing bot never writes Notion.
5. Bot Designer creates the other bots from `profiles/` (step 4).
6. Add the routines from `routines.md` (step 5), gate the installing bot (step 6), then run the verification checklist (step 7).

## Placeholders
`{{OWNER_NAME}}`, `{{TIMEZONE}}`, `{{COMPANY}}`, `{{WORK_CALENDAR}}`, `{{PERSONAL_CALENDAR}}`, `{{BOT_ID:Role}}`, `{{VIEW:Name}}` (including `{{VIEW:<product> Backlog}}` and `{{VIEW:<product> Delivery}}`), `{{INTERNAL_SOURCES}}`, `{{EXTRA_SOURCES}}`, `{{INTERNAL_WIKI}}`, `{{DOC_HOME_A|B|C}}`, `{{PROSE_AUDIT_SKILL}}`. Replace every one during install.
