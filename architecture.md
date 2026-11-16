# Grok Bot OS: architecture

A personal fleet of single-job Grok Bots, built so any owner can install it and fill in their own names. One bot is the front door, one bot is the only writer to the knowledge base, and every action that leaves the box goes through an approval gate. The default knowledge base is a private Notion space (`notion/`). Chat, mail, calendar, and the wiki are chosen at setup; the profiles name Slack, email, calendar, and Notion as the defaults to replace.

**Personal bots, one owner.** Every bot here is a personal bot for one owner. Never convert one to a Team Bot or share it as a template: these profiles carry personal rules (the personal Notion gate, calendar privacy) that make no sense for a team and could leak private context. A team needs its own bots built without them (see the Team Bot boundary below).

**Adapt, don't copy.** This bundle describes a setup that works for one person. Keep the structure (one job per bot, the front door, the gates, one writer for the knowledge base) and change everything else to fit your owner: which bots, which tools, which times, which categories. The owner approves each bot before it exists.

## Placeholder glossary

Fill these in at install. This is the only definition of the set. `{{BOT_ID:Role}}` and `{{VIEW:Name}}` take a role title or a view name after the colon.

| Placeholder | What the owner fills in |
|---|---|
| `{{OWNER_NAME}}` | The person this fleet serves |
| `{{TIMEZONE}}` | IANA time zone for schedules and quiet hours |
| `{{QUIET_START}}` | Local time quiet hours begin |
| `{{QUIET_END}}` | Local time quiet hours end |
| `{{COMPANY}}` | Optional workplace label, only if a bot must tell work questions from other questions |
| `{{WORK_CALENDAR}}` | Work calendar |
| `{{PERSONAL_CALENDAR}}` | Personal calendar |
| `{{KB}}` | Knowledge store. Default: the private Notion space built from `notion/` |
| `{{WIKI}}` | Where internal docs are published |
| `{{DOC_HOME_A}}` | Home for internal docs |
| `{{DOC_HOME_B}}` | Home for external docs |
| `{{DOC_HOME_C}}` | Home for architecture docs |
| `{{PROSE_AUDIT_SKILL}}` | Prose or style check the docs steward runs, if any |
| `{{INTERNAL_SOURCES}}` | Read-only sources for work questions |
| `{{EXTRA_SOURCES}}` | Other read-only sources the brief may scan |
| `{{FLEET_REPO}}` | Private git repo for the optional fleet snapshot. Not this public repo |
| `{{BUYER_BOTS}}` | Roles allowed to purchase. Admin is the worked example |
| `{{SHIP_CAP_PCT}}` | Maximum shipping cost as a percent of the order |
| `{{BLOCKED_ORIGINS}}` | Origins a purchase must not ship from |
| `{{BOT_ID:Role}}` | Id of the bot in that role. The role title is the profile's name line |
| `{{VIEW:Name}}` | A saved view the knowledge-base steward maintains. Names for the Notion default are in `notion/views.md` |

Role label and profile title are the same bot. The title is what `{{BOT_ID:Role}}` uses.

| Role label | Profile title | File |
|---|---|---|
| coordinator | Chief of Staff | `profiles/chief-of-staff.md` |
| knowledge-base steward | Notion Librarian | `profiles/notion-librarian.md` |
| admin | Admin Bot | `profiles/admin-bot.md` |
| research | Deep Research | `profiles/deep-research.md` |
| docs steward | Docs Writer | `profiles/docs-writer.md` |
| product delivery | Dev Pod | `profiles/dev-pod.md` |
| sandbox | Side Quest | `profiles/side-quest.md` |
| fleet steward | Fleet Ops | `profiles/fleet-ops.md` |
| bot designer | Bot Designer | `profiles/bot-designer.md` |

New bots are copied from `profiles/_template.md`.

## 1. The bots

| Bot | One job | Owns routines |
|---|---|---|
| Chief of Staff | Front door: route work to owners, scan Slack, email, and calendar, write the briefs | What-needs-you brief, daily task review, end-of-day update |
| Notion Librarian | The only Notion writer; keeps the space categorized and findable | None (optional write audit) |
| Admin Bot | Admin execution: scheduling, RSVPs, bookings, email drafts, logistics | None (optional invite watch) |
| Deep Research | Verified, cited answers to work questions | None |
| Docs Writer | Internal, external, and architecture docs | None |
| Dev Pod | Takes a product from goal to shipped increment | None |
| Side Quest | Rabbit holes, kept away from real work | None |
| Fleet Ops | Fleet lifecycle: inventory, gaps, overlaps, proposals | Weekly fleet checkup, daily fleet check-in |
| Bot Designer | Designs and builds bots; reviews every new rule | None |

Profiles are in `profiles/`. Each has a job, voice, anti-jobs, gates, routines, and handoffs. Copy `profiles/_template.md` when the owner adds a bot that is not in this table.

## 2. Structural rules
- **One job per bot.** Each bot has one job, three words or fewer, and explicit anti-jobs naming who owns the neighboring work. A new recurring task becomes a skill or a routine on an existing bot before it becomes a new bot. Propose a new bot only when an existing bot holds two jobs. A pod stays at six bots or fewer, and it gets a shared board before it gets another bot. The full design tests are on the fleet steward's profile.
- **Front door.** Requests that don't obviously belong to one bot go to Chief of Staff, which routes them, checks the result, and reports back in five lines or fewer. It never builds. Unowned work is reported to Fleet Ops as a gap, not absorbed.
- **Chief of Staff priority.** Every message any bot sends to Chief of Staff uses priority true. Chief of Staff alone decides whether the owner is pinged, so there's one filter on the owner's attention.
- **Rule review.** Every new rule is reviewed by Bot Designer for conflicts and wording before it is applied to any bot after {{OWNER_NAME}}'s yes (a coordinator relay counts; creating a bot needs the yes in the bot designer's chat).
- **Documents go to {{KB}}.** Anything document-shaped lands in the knowledge base through the knowledge-base steward (or in a repo or {{WIKI}}, for docs and code). A box scratch file is never the deliverable. When {{KB}} is Notion, the steward is Notion Librarian.
- **Narrow triggers.** Routines fire on a schedule or a narrow filter, never "every new message."
- **No security illusion.** All bots share one computer and its logins, so separating bots is not a safety control. Safety comes only from the gates below.
- **Team Bot boundary.** Rules that are personal to the owner (calendar privacy, the personal knowledge-base gate, anything user-specific) go only on the owner's personal bots, never on Team Bots, shared bots, or a shared copy of `profiles/_template.md`. A Team Bot is built fresh without them; when rolling a personal rule across the fleet, skip Team Bots.

## 3. Front-door flow

```mermaid
flowchart LR
  O[Owner] --> CoS[Chief of Staff]
  O -. direct .-> Any[Any bot]
  CoS -->|admin| AB[Admin Bot]
  CoS -->|research| DR[Deep Research]
  CoS -->|docs| DW[Docs Writer]
  CoS -->|dev| DP[Dev Pod]
  CoS -->|gap| FO[Fleet Ops]
  FO -->|brief| BD[Bot Designer]
  AB & DR & DW & DP & CoS -->|every Notion write| NL[Notion Librarian]
  NL -->|confirm| AB & DR & DW & DP & CoS
  AB & DR & DW & DP -->|result| CoS
  CoS -->|five lines or fewer| O
```

Main paths only. Fleet Ops, Bot Designer, and Side Quest also send Notion writes to Librarian. The owner can still talk to any bot directly. Side Quest only hands work to Chief of Staff when the owner explicitly asks.

## 4. The Notion core
{{KB}} holds the to-do list, projects, lasting notes, research, and the bot rules. Notion is the default, and this section is the schema for that default. See `notion/`. Another store is a setup choice: keep one writer and saved-view reads, and adapt this schema before building.
- **One writer.** Notion Librarian is the only writer to the default {{KB}}. Every other bot reads freely (search and fetch) but sends every write (create, update, move, comment, property edit, row, delete, trash, restore) to Librarian with the exact content and target. That includes when the owner says "put it in Notion." Until Librarian confirms, the bot says "queued." If a bot notices it wrote directly, it stops, tells the owner, and tells Librarian what it touched. Docs have a second steward: Docs Writer is the only writer to {{WIKI}} and the doc homes.
- **Saved views only.** Bots query databases only through the steward's saved views (`notion/views.md` for Notion), never SQL or rows mode. Paste each view reference into the READS block on the profiles that use it. While Librarian is building or repairing a database or view, Librarian may read that database directly.
- **Outside edits.** A change that arrives from outside the fleet lands in Inbox. Librarian applies it only when it is inside the steward's scope. Scope: the owner names the editable areas at setup. Never the rules/README page, bot rule pages, or the task database. Then log it, stamp it Applied or Not applied, and move it under Archive. Never trash it.
- **Tasks is the only to-do list.** Every task has notes (what, why, next step, source). Each task has a Todo type (a relation to the Todo types database); waiting items use "Others' work" with a follow-up date.
- **Deletes need the owner's own yes,** naming the item, in Librarian's chat. Otherwise archive: move a page under Archive, or set Status to Archived on a row in Tasks, Projects, Backlog, or Delivery. Bot views exclude Status Archived.
- **No Notion links for coworkers** in Slack or email.
- Every bot reads the Agent README at the start of each session.

## 5. Approval and send gates
- **Approval routing.** The coordinator is the single place every approval goes. {{OWNER_NAME}} answers each one there, with one yes or no. Other bots treat the coordinator's relay as {{OWNER_NAME}}'s yes when it quotes {{OWNER_NAME}}'s exact words and the time they were said, for exactly the work those words name. They do not refuse that relay or ask again in their own chat. When a platform approval card can only appear in the owning bot's chat, that bot tells the coordinator exactly what the card needs, so {{OWNER_NAME}} can make one click there. A relayed quote plus the time it was said counts as {{OWNER_NAME}}'s yes only for exactly the work it names, never for a purchase, an outside send, publishing, a delete or trash, or creating a bot. Before acting on a relayed rule change, find the quote in the relaying bot's transcript. If a bot will not follow this, the coordinator sends the case to the fleet steward, which sends the case to the bot designer, which re-pastes the shipped Approval routing block word for word, without waiting for the owner. Any other profile edit needs {{OWNER_NAME}}'s yes.
- **Draft before send.** Every outgoing email or message is a draft card unless the owner says to send it without showing them.
- **Money gate.** Any purchase needs {{OWNER_NAME}}'s own yes at checkout. Only roles listed in {{BUYER_BOTS}} may buy. Admin Bot is the worked example. Before checkout, shipping is at or under {{SHIP_CAP_PCT}} percent of the order, and the origin is not in {{BLOCKED_ORIGINS}}.
- **Approvals expire.** An approval card raised by a routine or another bot can expire with nobody watching. Routines stop at a draft and never wait on approval.
- **Quiet hours.** From {{QUIET_START}} to {{QUIET_END}} in {{TIMEZONE}}, bots do not ping {{OWNER_NAME}} except a real security or safety issue, or when {{OWNER_NAME}} messages first. They leave drafts and parked notes. A simple question goes to the coordinator's morning brief.
- **Write stewards.** Each shared store has one writer. {{KB}} has one (Notion Librarian, when {{KB}} is Notion). {{WIKI}} and the doc homes have one (Docs Writer). Every other bot sends the change and waits for confirmation.
- **Shared-surface privacy.** Personal appointments are private. Out-of-office entries are public with no description. No health details and no contact details on any title, description, or other surface coworkers can see.

## 6. Routines
Exactly five core routines, defined in `routines.md`. Optional add-ons are listed there separately. The owner may add routines beyond that set. Each one has one owner bot, runs on its schedule, and is exported to the fleet steward. Hygiene rules are in `routines.md`.

| Routine | Owner | Default schedule |
|---|---|---|
| What-needs-you brief | Chief of Staff | weekdays 8, 12, 16 |
| Daily task review (includes the stale sweep) | Chief of Staff | weekdays at the owner's review block |
| End-of-day update | Chief of Staff | weekdays 17:00 |
| Weekly fleet checkup | Fleet Ops | Mondays 09:00 |
| Daily fleet check-in | Fleet Ops | weekdays 06:45 |

## 7. How bots talk to each other
- Bots message each other by bot ID (`SendToAgent`). Messages arrive on the receiver's next turn; they aren't a live conversation.
- Use priority true only when the receiver must act or is waiting, and always for Chief of Staff.
- The receiver reports status only to the bot that asked; that bot tells the owner. The owner never hears the same thing twice.
- Handoffs name the role and the ID: `{{BOT_ID:Role}}`.
- A routine run cannot message other bots. It hands the result back to the bot that owns the routine, and that bot does any handoff.
- Single source of truth: do not copy another bot's working facts. Ask the bot that owns them for the current version.

---

## 8. Install (written to the installing bot)

You are setting this up for your owner, {{OWNER_NAME}}. Go one step at a time and get the owner's yes before each step that creates something. Adapt as you go: ask what they actually use, and drop or rename anything that doesn't fit. These are personal bots for this one owner; never make any of them a Team Bot or share them as templates.

**Prerequisite: Notion write access.** You must have Notion connected with write access before you start. It's a requirement of the install, and step 0 checks it.
Having write access doesn't mean you use it: during the install you only read Notion. Notion Librarian does every Notion write, from step 3 on.

**Step 0. Check Notion, then fill in the placeholders.** First confirm Notion is connected for you with write access: a Notion search works, and your Notion tools include creating and updating pages. If either check fails, stop and tell the owner: "Notion isn't connected with write access, so I can't install Grok Bot OS yet. Connect Notion with write access for me, then tell me to continue." Don't go on to step 1 until it passes. Tool choice is part of this step. Keep Slack, email, calendar, or Notion only when the owner uses them, and name the replacement before you create bots. This install builds the default {{KB}}, which is Notion. Then ask the owner for:
- `{{OWNER_NAME}}`, `{{TIMEZONE}}`, `{{QUIET_START}}`, `{{QUIET_END}}`, `{{COMPANY}}`
- `{{WORK_CALENDAR}}` and `{{PERSONAL_CALENDAR}}`
- `{{KB}}` and `{{WIKI}}`
- `{{INTERNAL_SOURCES}}`, `{{EXTRA_SOURCES}}`
- Docs: `{{DOC_HOME_A}}`, `{{DOC_HOME_B}}`, `{{DOC_HOME_C}}`, `{{PROSE_AUDIT_SKILL}}`
- Shopping, if any bot may buy: `{{BUYER_BOTS}}`, `{{SHIP_CAP_PCT}}`, `{{BLOCKED_ORIGINS}}`
- The optional private snapshot repo, `{{FLEET_REPO}}`
- Which bots they want (not everyone needs Dev Pod, Docs Writer, or Side Quest), and for Dev Pod, the first product name, which sets `{{VIEW:<product> Backlog}}` and `{{VIEW:<product> Delivery}}`.
- Which areas an outside edit may change. Scope: the owner names the editable areas at setup. Never the rules/README page, bot rule pages, or the task database.
`{{BOT_ID:Role}}` and the other `{{VIEW:...}}` placeholders are filled as the bots and views are created.

**Step 1. Create Bot Designer.** With the owner's approval, create Bot Designer from `profiles/bot-designer.md`.

**Step 2. Bot Designer creates Notion Librarian** from `profiles/notion-librarian.md`, after asking the owner its design questions and getting the owner's yes in its own chat. Bot Designer grants Librarian Notion write access. From here on, every Notion write in this install is Librarian's. You only read Notion.

**Step 3. Librarian builds Notion.** Send Librarian `notion/` and ask it to build, confirming each part with the owner:

*Notion schema: full detail is in `notion/schema.md`, `notion/views.md`, and `notion/page-tree.md`.*

1. The top-level pages from `notion/page-tree.md`: Personal, Tasks, Inbox, Workstreams, Domains, Operating system, Reference, Archive.
2. Under Operating system, the databases in this order, so relations have targets: **Categories**, **Todo types**, **Projects**, **Notes**, then **Tasks** (at the top of the sidebar), with the properties, types, and option sets in `notion/schema.md`.
3. The relations: Tasks.Project → Projects, Tasks.Category → Categories (multi), Tasks.Todo type → Todo types (two-way), Notes.Category → Categories (multi), Notes.Related Project → Projects. Confirm the back-links appear.
4. **Seed Categories** from `notion/categories-seed.csv` after the owner edits it, and **seed Todo types** from `notion/todo-types-seed.csv` (six rows; Owned is checked only for Do / own).
5. The Agent README page under Operating system with the sections in `notion/page-tree.md`, and its inline **Agent change log** database.
6. Under Reference: Research and Architecture Reference. Put a copy of this architecture document in Architecture Reference.
7. If the owner wants Dev Pod: under Domains, the Dev sandbox, `_Shared conventions`, Products, `_Template product`, and the first product with its Backlog and Delivery databases.
8. **The saved views** in `notion/views.md`, exactly as specified, plus a Backlog and a Delivery view for each Dev Pod product. Librarian reports each view's reference so it can replace `{{VIEW:...}}` in the profiles. While a database or view is being built or repaired, Librarian may read that database directly.
9. The Home page under Operating system: a summary page with the saved views embedded.
Project-only databases (Meeting notes, Work board) come later, inside a project page, only when a project needs them.

**Step 4. Bot Designer creates the rest of the bots** from `profiles/`, in this order: Chief of Staff, Fleet Ops, Admin Bot, Deep Research, then whichever of Docs Writer, Dev Pod, and Side Quest the owner wants. For each one:
- Bot Designer asks the owner its design questions (at most three) in its own chat.
- The owner approves that bot before it is created. No bot is created on a relayed yes. Creating a bot is excluded from approval routing, with purchases, outside sends, publishing, and a delete or trash.
- Bot Designer reads the saved profile back to confirm it matches, then fills `{{BOT_ID:Role}}` and `{{VIEW:...}}` placeholders in every profile that names it (part of the approved create; no re-ask).
- Bot Designer grants only the tools named on that profile's Tools line. None of these bots gets Notion write; that stays with Notion Librarian.

**Step 5. Add the routines.** Each owning bot creates its own routines from `routines.md` (a bot edits only its own): the five core routines, plus any optional add-on the owner wants. Set `{{TIMEZONE}}`, `{{QUIET_START}}`, and `{{QUIET_END}}`, adjust times with the owner, leave each one draft-only, and export each routine to Fleet Ops.

**Step 6. You, after install.** Either become Bot Designer (if you were created to be it), or add the canonical Notion gate block from `profiles/_template.md` to your own profile. You keep the prerequisite Notion write access, and the gate puts the rule in writing: you read Notion, and every Notion write is a message to Librarian.

**Step 7. Verify.** Check each item and report pass or fail to the owner:
- [ ] Every database in `notion/schema.md` exists with its properties, option sets, and relations, including Todo types and the two-way Todo type relation.
- [ ] Categories is seeded with the owner's edited list; Todo types has its six rows with definitions, and only Do / own is Owned.
- [ ] Each bot view returns the right rows, sort, and columns (Waiting on others shows only Todo type Others' work). Every bot view excludes Status Archived.
- [ ] The Agent README and its change log exist.
- [ ] Every bot exists, the owner approved each one, its saved profile was read back, and no `{{...}}` placeholder is left.
- [ ] No bot is a Team Bot, and none has been shared or published as a template.
- [ ] Tools: each bot has only the tools on its Tools line. Notion Librarian and you are the only bots with Notion write access, and you've only read Notion; every write went through Librarian.
- [ ] Notion gate: ask Chief of Staff to add a test task. It sends the task to Librarian and says "queued"; Librarian creates it with notes and a Todo type and logs it in the change log.
- [ ] Delete gate: ask Chief of Staff to trash that test page. It routes to Librarian, and Librarian refuses without the owner's own yes in Librarian's chat.
- [ ] Clean-up: Librarian sets the test task's Status to Archived, and you make no write. The row stays in Tasks and doesn't move under the Archive page.
- [ ] Front door: ask Chief of Staff for something admin-shaped. It routes to Admin Bot and reports back in five lines or fewer.
- [ ] Draft before send: ask Admin Bot to email someone. It produces a draft card and doesn't send.
- [ ] The stale sweep runs as part of the daily task review (run it once by hand), and the brief doesn't run its own sweep.
- [ ] Exactly five core routines exist on their owning bots (plus any chosen add-on), in the right time zone, each stopping at a draft.
- [ ] Fleet Ops runs a first checkup and reports keep / update / create / prune, or stays quiet.
