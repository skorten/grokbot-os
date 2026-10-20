# Grok Bot OS

A starter kit for a personal Grok Bot fleet: single-job bots, a front-door Chief of Staff, a private Notion space with one writer, and approval gates on everything that leaves the box. Hand this folder to a blank Grok Bot and ask it to install it with you.

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
| `profiles/*.md` | One profile per bot: Chief of Staff, Notion Librarian, Admin Bot, Deep Research, Docs Writer, Dev Pod, Side Quest, Fleet Ops, Bot Designer |
| `routines.md` | Five routines with cron schedules and prompts |

## Order of use
1. Read `architecture.md` sections 1 to 7.
2. Fill in the placeholders (install step 0).
3. Build Notion from `notion/` (install steps 1 to 3).
4. Create Bot Designer, then have it create the other bots from `profiles/` (install step 4).
5. Add the routines from `routines.md` (install step 5).
6. Run the verification checklist (install step 6).

## Placeholders
`{{OWNER_NAME}}`, `{{TIMEZONE}}`, `{{COMPANY}}`, `{{BOT_ID:Role}}`, `{{VIEW:Name}}`, `{{INTERNAL_SOURCES}}`, `{{EXTRA_SOURCES}}`, `{{INTERNAL_WIKI}}`, `{{DOC_HOME_A|B|C}}`, `{{PROSE_AUDIT_SKILL}}`. Replace every one during install.
