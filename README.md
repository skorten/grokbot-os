# Grok Bot OS

A starter kit for a personal Grok Bot fleet: single-job bots, a front-door Chief of Staff, a private Notion space with one writer, and approval gates on everything that leaves the box. Hand this folder to a blank Grok Bot and ask it to install it with you.

**Personal bots, one owner.** These are personal bots for a single owner. Never convert them to Team Bots or share them as templates. *Team Bot boundary:* personal rules (the private Notion gate, calendar privacy) belong only on the owner's personal bots; a Team Bot for coworkers is built fresh without them.

**Adapt, don't copy.** Keep the structure; change the bots, tools, times, and categories to fit you. You approve each bot before it's created.

## Contents
| Path | What it is |
|---|---|
| `README.md` | This file |
| `LICENSE` | Apache License 2.0 |
| `NOTICE` | Copyright and attribution notice (Apache-2.0) |
| `architecture.md` | How the system works, plus the step-by-step install written to the installing bot |
| `notion/schema.md` | Every database: properties, types, option sets, relations, design rules |
| `notion/views.md` | The saved views bots query through, and the views-only rule |
| `notion/page-tree.md` | The page outline and the bot rules page (Agent README) |
| `notion/categories-seed.csv` | Example categories. Edit before seeding |
| `notion/todo-types-seed.csv` | The six Todo types with one-line definitions |
| `profiles/*.md` | One profile per bot: Chief of Staff, Notion Librarian, Admin Bot, Deep Research, Docs Writer, Dev Pod, Side Quest, Fleet Ops, Bot Designer |
| `scripts/check.sh` | Leak scan and install consistency checks (also run by GitHub Actions) |
| `routines.md` | Exactly five core routines with cron schedules and prompts, plus two optional add-ons |

## Prerequisite
The bot running the install must have Notion connected with **write access**. This is a requirement, not an option: the install stops at step 0 until it's connected. Having write access doesn't mean the installing bot uses it: during the install it only reads Notion, and Notion Librarian does every Notion write, from step 3 on.

## Order of use
Follow the install prompt below. Its steps match `architecture.md` section 8, steps 0 to 7. When step 7 says to verify, use the checklist in that section and report pass or fail for each item.

## Placeholders
`{{OWNER_NAME}}`, `{{TIMEZONE}}`, `{{COMPANY}}`, `{{WORK_CALENDAR}}`, `{{PERSONAL_CALENDAR}}`, `{{BOT_ID:Role}}`, `{{VIEW:Name}}` (including `{{VIEW:<product> Backlog}}` and `{{VIEW:<product> Delivery}}`), `{{INTERNAL_SOURCES}}`, `{{EXTRA_SOURCES}}`, `{{INTERNAL_WIKI}}`, `{{DOC_HOME_A}}`, `{{DOC_HOME_B}}`, `{{DOC_HOME_C}}`, `{{PROSE_AUDIT_SKILL}}`. Replace every one during install.

## Install prompt
Paste this into a blank Grok Bot. Its step numbers match the install in `architecture.md` section 8.

```text
Install Grok Bot OS for me from https://github.com/skorten/grokbot-os. Read architecture.md first, then follow its section 8 install one step at a time, and get my yes before each step that creates something. Adapt as you go: ask what I actually use, and drop or rename anything that doesn't fit. These are personal bots for me only; never make any of them a Team Bot or share them as templates.

Prerequisite: you must have Notion connected with write access. The install can't run without it.
Having write access doesn't mean you use it: during the install you only read Notion. Notion Librarian does every Notion write, from step 3 on.

Step 0. Check that Notion is connected for you with write access: a Notion search works and your Notion tools include creating and updating pages. If not, stop and tell me: "Notion isn't connected with write access, so I can't install Grok Bot OS yet. Connect Notion with write access for me, then tell me to continue." Don't go on to step 1 until it passes. Once it does, ask me for every placeholder: OWNER_NAME, TIMEZONE, COMPANY, WORK_CALENDAR, PERSONAL_CALENDAR, INTERNAL_SOURCES, EXTRA_SOURCES, INTERNAL_WIKI, DOC_HOME_A/B/C, PROSE_AUDIT_SKILL, which bots I want, and (if I want Dev Pod) the first product name. BOT_ID and VIEW placeholders are filled later, as bots and views are created.
Step 1. With my approval, create Bot Designer from profiles/bot-designer.md.
Step 2. Bot Designer creates Notion Librarian from profiles/notion-librarian.md, after asking me its design questions and getting my yes in its own chat. Bot Designer grants Librarian Notion write access. From here on, every Notion write in this install is Librarian's; you only read Notion.
Step 3. Send Librarian the notion/ folder. Librarian builds, confirming each part with me: the top-level pages; the databases in order (Categories, Todo types, Projects, Notes, Tasks) and their relations; seeds Categories from notion/categories-seed.csv after I edit it and Todo types from notion/todo-types-seed.csv; the Agent README page and its change log; Reference pages; the Dev Pod pages if I want Dev Pod; then the saved views in notion/views.md, reporting each view reference (while it builds or repairs a database or view, Librarian may read that database directly); then the Home page under Operating system, a summary page with the saved views embedded.
Step 4. Bot Designer creates the remaining bots from profiles/ in this order: Chief of Staff, Fleet Ops, Admin Bot, Deep Research, then whichever of Docs Writer, Dev Pod, and Side Quest I want. At most three design questions each, my own yes in Bot Designer's chat before each create, read each saved profile back, and fill BOT_ID and VIEW placeholders. Bot Designer grants only the tools on that profile's Tools line. None of these bots gets Notion write; that stays with Notion Librarian.
Step 5. Each owning bot adds its own routines from routines.md: only the five core routines, plus an optional add-on only if I ask for it. Set my time zone, adjust times with me, and keep every routine draft-only.
Step 6. Either become Bot Designer (if you were created to be it), or add the canonical Notion gate block from any profile in profiles/ to your own profile. You keep the prerequisite Notion write access, and the gate puts the rule in writing: you read Notion, and every Notion write is a message to Librarian.
Step 7. Run the step 7 verification checklist and report pass or fail for each item, including the Notion gate test (a test task goes through Librarian), the delete test (Chief of Staff asks Librarian to trash the test page and Librarian refuses without my own yes in Librarian's chat), the tools check (each bot has only the tools on its Tools line; Notion Librarian and you are the only bots with Notion write access, and you've only read Notion, with every write going through Librarian), and clean-up (Librarian sets the test task's Status to Archived while you make no write; the row stays in Tasks and doesn't move under the Archive page).
```

## Checks
`scripts/check.sh` scans for leaks (secrets, Notion links and IDs, UUIDs, emails, phone numbers, street addresses, and the owner's handle anywhere but the repo link) and checks that the install prompt and `architecture.md` section 8 agree (steps 0 to 7 in order, the Notion write prerequisite, referenced files, internal links, placeholders). Run it with `bash scripts/check.sh` before you push; GitHub Actions runs it, plus gitleaks over the full history, on every push and pull request.

## Credits
Bot Designer (profiles/bot-designer.md) is adapted from the dr eggbot Grok Bot template by Lauren Tan (@poteto), https://x.ai/bot/marketplace/bots/dr-eggbot-v2. The fleet rules (Notion gate, rule review, Team Bot boundary) are original to Grok Bot OS.

## License
Apache License 2.0. See [LICENSE](LICENSE).
