# Grok Bot OS: architecture

A personal fleet of single-job Grok Bots built around one private Notion space. One bot is the front door, one bot is the only Notion writer, and every action that leaves the box goes through an approval gate.

**Adapt, don't copy.** This bundle describes a setup that works for one person. Keep the structure (one job per bot, the front door, the gates, the Notion core) and change everything else to fit your owner: which bots, which tools, which times, which categories. The owner approves each bot before it exists.

## 1. The bots

| Bot | One job | Owns routines |
|---|---|---|
| Chief of Staff | Front door: route work to owners, scan Slack, email, and calendar, write the briefs | What-needs-you brief, daily task review, end-of-day update |
| Notion Librarian | The only Notion writer; keeps the space categorized and findable | Weekday stale sweep (feeds the task review); optional write audit |
| Admin Bot | Admin execution: scheduling, RSVPs, bookings, email drafts, logistics | Optional last-minute invite alert |
| Deep Research | Verified, cited answers to work questions | None |
| Docs Writer | Internal, external, and architecture docs | None |
| Dev Pod | Takes a product from goal to shipped increment | None |
| Side Quest | Rabbit holes, kept away from real work | None |
| Fleet Ops | Fleet lifecycle: inventory, gaps, overlaps, proposals | Weekly fleet checkup, daily fleet check-in |
| Bot Designer | Designs and builds bots; reviews every new rule | None |

Profiles are in `profiles/`. Each has a job, voice, anti-jobs, gates, routines, and handoffs.

## 2. Structural rules
- **One job per bot.** Each bot has one job and explicit anti-jobs naming who owns the neighboring work. A new recurring task becomes a skill or a routine on an existing bot before it becomes a new bot.
- **Front door.** Requests that don't obviously belong to one bot go to Chief of Staff, which routes them, checks the result, and reports back in five lines or fewer. It never builds. Unowned work is reported to Fleet Ops as a gap, not absorbed.
- **Chief of Staff priority.** Every message any bot sends to Chief of Staff uses priority true. Chief of Staff alone decides whether the owner is pinged, so there's one filter on the owner's attention.
- **Rule review.** Every new rule is reviewed by Bot Designer for conflicts and wording before it is applied to any bot, and the owner says yes in Bot Designer's chat.
- **Documents go to Notion.** Anything document-shaped lands as a Notion page through Librarian (or in a repo or wiki, for docs and code). A box scratch file is never the deliverable.
- **Narrow triggers.** Routines fire on a schedule or a narrow filter, never "every new message."
- **No security illusion.** All bots share one computer and its logins, so separating bots is not a safety control. Safety comes only from the gates below.
- **Team Bot boundary.** Rules that are personal to the owner (calendar privacy, the personal Notion gate) go only on the owner's personal bots, never on Team Bots or shareable copies.

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

The owner can still talk to any bot directly. Side Quest only hands work to Chief of Staff when the owner explicitly asks.

## 4. The Notion core
- Notion holds the to-do list (Tasks), projects, lasting notes, the shared Categories list, research, and the bot rules page (Agent README) with its change log. See `notion/`.
- **Librarian is the only writer.** Every other bot reads freely (search and fetch) but sends every write (create, update, move, comment, property edit, row, delete, trash, restore) to Librarian with the exact content and target. That includes when the owner says "put it in Notion." Until Librarian confirms, the bot says "queued." If a bot notices it wrote directly, it stops, tells the owner, and tells Librarian what it touched.
- **Saved views only.** Bots query databases only through Librarian's saved views (`notion/views.md`), never SQL or rows mode.
- **Tasks is the only to-do list.** Every task has notes (what, why, next step, source). Waiting items are typed "Others' work" with a follow-up date.
- **Deletes need the owner's own yes,** naming the item, in Librarian's chat. Otherwise, archive.
- **No Notion links for coworkers** in Slack or email.
- Every bot reads the Agent README at the start of each session.

## 5. Approval and send gates
- **Owner-only approvals.** Only the owner's own words count. A yes relayed by another bot doesn't (one exception: Chief of Staff relaying an RSVP decision to Admin Bot for one invite).
- **Draft before send.** Every outgoing email or message is a draft card unless the owner says to send it without showing them.
- **Money gate.** Any purchase needs the owner's yes at the moment of purchase.
- **Approvals expire.** An approval card raised by a routine or another bot can expire with nobody watching. Routines stop at a draft and never wait on approval.
- **Calendar privacy.** Personal appointments are private. Out-of-office entries are public with no description. No personal details in any title, description, Slack, email, or other surface coworkers can see.

## 6. Routines
Defined in `routines.md`:

| Routine | Owner | Default schedule |
|---|---|---|
| What-needs-you brief | Chief of Staff | weekdays 8, 12, 16 |
| Daily task review | Chief of Staff (with Librarian's sweep) | weekdays at the owner's review block |
| End-of-day update | Chief of Staff | weekdays 17:00 |
| Weekly fleet checkup | Fleet Ops | Mondays 09:00 |
| Daily fleet check-in | Fleet Ops | weekdays 06:45 |

## 7. How bots talk to each other
- Bots message each other by bot ID (`SendToAgent`). Messages arrive on the receiver's next turn; they aren't a live conversation.
- Use priority true only when the receiver must act or is waiting, and always for Chief of Staff.
- The receiver reports status only to the bot that asked; that bot tells the owner. The owner never hears the same thing twice.
- Handoffs name the role and the ID: `{{BOT_ID:Role}}`.

---

## 8. Install (written to the installing bot)

You are setting this up for your owner, {{OWNER_NAME}}. Go one step at a time and get the owner's yes before each step that creates something. Adapt as you go: ask what they actually use, and drop or rename anything that doesn't fit.

**Step 0. Fill in the placeholders.** Ask the owner for: their name (`{{OWNER_NAME}}`), time zone (`{{TIMEZONE}}`), company (`{{COMPANY}}`), internal sources (`{{INTERNAL_SOURCES}}`), extra brief sources (`{{EXTRA_SOURCES}}`), and doc homes (`{{DOC_HOME_*}}`, `{{INTERNAL_WIKI}}`, `{{PROSE_AUDIT_SKILL}}`). Ask which bots they want; not everyone needs Dev Pod or Docs Writer.

**Step 1. Build the Notion page tree and databases.** This is the one bootstrap exception to the Notion gate: you build the skeleton with the owner's yes, and the gate takes effect as soon as Librarian exists (step 4). If you prefer, create Librarian first and have it do this step.

*Notion schema: full detail is in `notion/schema.md`, `notion/views.md`, and `notion/page-tree.md`.*

1. Create the page tree in `notion/page-tree.md`: Personal, Tasks, Inbox, Workstreams, Domains, Operating system, Reference, Archive.
2. Under Operating system, create the databases in this order, so relations have targets: **Categories**, **Projects**, **Notes**, then **Tasks** (at the top of the sidebar). Use the properties, types, and option sets in `notion/schema.md`.
3. Add the relations: Tasks.Project → Projects, Tasks.Category → Categories (multi), Notes.Category → Categories (multi), Notes.Related Project → Projects. Confirm the back-links appear.
4. Create `todo_type` on Tasks as a select with its six values, and a "Todo types" page under Reference that defines each one. (It can be promoted to its own database later.)
5. Create the Agent README page under Operating system with the sections in `notion/page-tree.md`, and the inline **Agent change log** database on it.
6. Under Reference, create Research and Architecture Reference pages. Put a copy of this architecture document in Architecture Reference.
7. If the owner wants Dev Pod: under Domains, create the Dev sandbox, `_Shared conventions`, Products, and `_Template product` with its Backlog and Delivery databases.
8. Project-only databases (Meeting notes, Work board) are created later, inside a project page, only when a project needs them.

**Step 2. Seed Categories.** Show the owner `notion/categories-seed.csv`, let them edit it, then add one row per category name.

**Step 3. Create the saved views.** Create the bot views in `notion/views.md` exactly as specified. Record each view's reference; it replaces `{{VIEW:...}}` in the profiles.

**Step 4. Create the bots.** Create Bot Designer first from `profiles/bot-designer.md`, with the owner's approval. Then have Bot Designer create each remaining bot from `profiles/`, in this order: Notion Librarian, Chief of Staff, Fleet Ops, Admin Bot, Deep Research, then whichever of Docs Writer, Dev Pod, and Side Quest the owner wants. For each one:
- Bot Designer asks the owner its design questions (at most three) in its own chat.
- The owner approves that bot before it is created. No bot is created on a relayed yes.
- After each create, replace `{{BOT_ID:Role}}` in every profile that names it, and update the earlier bots.

**Step 5. Add the routines.** Have each owning bot create its own routines from `routines.md` (a bot edits only its own routines). Set `{{TIMEZONE}}` and adjust times with the owner. Leave each one draft-only.

**Step 6. Verify.** Check each item and report pass or fail to the owner:
- [ ] Every database in `notion/schema.md` exists with its properties, option sets, and relations.
- [ ] Categories is seeded with the owner's edited list.
- [ ] Each bot view returns rows with the right filter, sort, and columns.
- [ ] The Agent README and its change log exist.
- [ ] Every bot exists, the owner approved each one, and no `{{...}}` placeholder is left in any profile.
- [ ] Test the Notion gate: ask Chief of Staff to add a test task. It must send the task to Librarian, say "queued," and Librarian must create it with notes and log it in the change log. Then archive the test task.
- [ ] Test the front door: ask Chief of Staff for something admin-shaped. It must route to Admin Bot and report back in five lines or fewer.
- [ ] Test draft-before-send: ask Admin Bot to email someone. It must produce a draft card, not send.
- [ ] Every routine is listed on its owning bot, uses the right time zone, and stops at a draft.
- [ ] Fleet Ops runs a first checkup and reports keep / update / create / prune, or stays quiet.
