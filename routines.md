# Routines

Exactly five core routines. Each belongs to one bot. Optional add-ons are listed at the end and are not part of the core set. Schedules are standard 5-field cron (minute hour day-of-month month day-of-week), evaluated in `{{TIMEZONE}}` (for example `America/New_York`). Edit times to fit the owner's day.

Rules that apply to every routine:
- **Draft only.** A routine detects, summarizes, and drafts. It never sends, buys, or applies a change that needs approval, and never waits on an approval card (cards can expire with nobody around).
- **Knowledge-base writes go to the steward.** A routine that changes a task sends the change to Notion Librarian when {{KB}} is Notion; it never writes the knowledge base itself.
- **Database reads go through saved views.** Never SQL or rows mode. Use the views in `notion/views.md`.
- **A run does not message other bots.** It hands the result back to its owner bot. See [How bots talk to each other](architecture.md#7-how-bots-talk-to-each-other). When that bot messages the coordinator about the run, the message uses priority true.
- **Quiet hours.** A run between {{QUIET_START}} and {{QUIET_END}} ({{TIMEZONE}}) parks its draft and does not ping {{OWNER_NAME}} except a real security or safety issue, or when {{OWNER_NAME}} messages first. A simple question waits for the morning brief.
- **Quiet means quiet.** No "(no change.)" filler unless the routine says to send one line.

## Routine hygiene
- One owner bot per routine. That bot creates and edits only its own.
- Stay quiet when nothing changed. Send a note when state changes, not a steady "no change."
- Never run before the input it needs exists. If a tool or input is missing, say inconclusive. Don't report a clean result you could not check.
- Don't fire on a broad listener. Use a schedule or a narrow filter.
- The owner may add routines beyond the five core ones and the optional add-ons. The same hygiene rules apply, including export to the fleet steward.

## Routine export
The fleet steward (Fleet Ops, {{BOT_ID:Fleet Ops}}) keeps the fleet's routine records. The owner bot sends this record, and only this, on create, change, enable, disable, and delete:

- name
- id
- schedule or trigger
- timing
- enabled flag
- the prompt, verbatim, with secrets and personal details removed
- status: active, or deleted

A deletion stays in the record as deleted. One-off prompts are not exported. The optional snapshot writes the same fields into the private {{FLEET_REPO}}, with one markdown file per routine (grouped by bot) and one markdown file per profile.

---

## 1. What-needs-you brief

- **Owner:** Chief of Staff
- **Schedule:** `0 8,12,16 * * 1-5` (weekdays 8 AM, noon, 4 PM, `{{TIMEZONE}}`)
- **Prompt:**

> Deliver {{OWNER_NAME}} a tight "what needs you" readout. Scan: calendar (today and tomorrow, including conflicts), Slack mentions and DMs that need {{OWNER_NAME}}, priority unread email, recent meeting notes and their open action items, and {{EXTRA_SOURCES}} (for example a spend tool, read through its connector, never through its notification emails). Read open Tasks through Librarian's saved views ({{VIEW:Open tasks}}, {{VIEW:Waiting on others}}) and check each against Slack, email, or calendar before it appears. Raise a waiting item only when its follow-up date has arrived. Don't run the stale sweep; that belongs to the daily task review. Calendars: {{WORK_CALENDAR}} and {{PERSONAL_CALENDAR}}. Lead with decisions and deadlines. Skip noise: calendar accepts, marketing, bot chatter. If Admin Bot runs the optional invite watch, an invite it already alerted appears once, as one item. Keep it short: prose or tight bullets.

- **When to stay quiet:** never fully silent. If nothing needs {{OWNER_NAME}}, send one line saying so.

---

## 2. Daily task review

- **Owner:** Chief of Staff (the only place the stale sweep runs)
- **Schedule:** `0 11 * * 1-5` (weekdays, `{{TIMEZONE}}`). Set it to the start of the owner's daily review block on the calendar; a 10-minute solo block works well.
- **Prompt:**

> Run {{OWNER_NAME}}'s daily task review. Pull open Tasks through {{VIEW:Open tasks}} and {{VIEW:Waiting on others}}. Find stale items: overdue, unchanged for more than 3 days, past their follow-up date, or missing a next step. Verify each against calendar, email, Slack, and the code host so you don't ask about something already done. Post two lists in chat. (1) Questions, most important first: the task, what you found, and one question ("done?", "next step?", "drop or defer?"). Add new commitments seen in the last day that aren't Tasks yet. (2) Open but not asking: one line each, for awareness. Then stop. Don't change any task and don't wait for answers.

- **Applying answers:** when {{OWNER_NAME}} replies, in that live turn, send Librarian each answer as a change (status, next step, follow-up date, one-line note) and confirm once Librarian has applied them. The routine itself never decides or changes a task's status.
- **When to stay quiet:** if there are no stale items, no questions, and no new commitments, send one line ("Task list is current") or nothing, per the owner's preference.
---

## 3. End-of-day update

- **Owner:** Chief of Staff
- **Schedule:** `0 17 * * 1-5` (weekdays 5 PM, `{{TIMEZONE}}`)
- **Prompt:**

> For every Task that moved today but isn't done, send Notion Librarian a progress note: which task, what happened, where it stands, next step. Then message {{OWNER_NAME}}: list what made progress but didn't finish, and confirm Librarian has been updated, or say what is still queued if Librarian hasn't confirmed. Don't list finished tasks unless the owner asks.

- **When to stay quiet:** if no task moved today, send nothing.

---

## 4. Weekly fleet checkup

- **Owner:** Fleet Ops
- **Schedule:** `0 9 * * 1` (Mondays 9 AM, `{{TIMEZONE}}`)
- **Prompt:**

> Run the weekly fleet checkup. Scan every bot's profile, its routines, and the past week's transcript friction (repeated corrections, handoffs that bounced, work landing on the wrong bot). Score the fleet on the design tests in your profile: one job per bot, a new bot only when one bot holds two jobs and the job is three words or fewer, pods over six bots, a pod with no shared board, clone generalists, front-door bots doing the work, group chats with no board, open or broad listeners, routines that would wait on the owner's yes, and any proposal leaning on bot separation as a safeguard. Compare the routine list, and each routine's last update, with {{FLEET_REPO}} when that private repo exists. Flag a standing rule missing from a profile, and flag stale text left behind by a replaced rule. If {{FLEET_REPO}} or a transcript tool is missing, mark that part inconclusive, not clean. Tag each finding NEW, REPEAT, CHANGED, or RESOLVED, cite the evidence, and give one fix. Report proposals as keep / update / create / prune. Creates and redesigns become a brief for Bot Designer; new rules go to Bot Designer for review first. Deletes are proposals only. Change nothing without {{OWNER_NAME}}'s yes.

- **When to stay quiet:** if nothing is worth proposing, send nothing.

---

## 5. Daily fleet check-in

- **Owner:** Fleet Ops
- **Schedule:** `45 6 * * 1-5` (weekdays 6:45 AM, `{{TIMEZONE}}`, before the first brief)
- **Prompt:**

> Check every bot's routines for failed or missed runs, open blockers, and stale approvals. On the day the weekly checkup runs, skip the profile diff; the checkup covers it. On other weekdays, diff any profile changed since yesterday. If a tool or transcript you need is missing, say inconclusive, not clean. If anything is stuck or drifting, send Chief of Staff (priority true) one short report of no more than 5 lines, each naming the bot, the problem, and a suggested fix. Change nothing. Design and overlap review waits for the weekly checkup.

- **When to stay quiet:** if nothing is wrong, send nothing.

---

## Optional add-ons (not part of the core five)

Add these only if the owner wants them. Same rules: draft only, narrow triggers, hand the result back to the owning bot, and the hygiene rules above.

- **Invite watch** (optional). Try it before you rely on it: run it where you can see the alerts before you treat the dedupe as settled. Owner: Admin Bot. Schedule: `*/15 8-19 * * 1-5` (`{{TIMEZONE}}`). Alert Chief of Staff only for new invites that start before the next brief: who, what, when, any visible conflict. One alert per invite, deduped across runs. Never accept, decline, or tentatively accept; apply only a decision Chief of Staff relays. Quiet when there's nothing new.
- **Write audit** (optional). Owner: Notion Librarian. Schedule: owner's choice (for example `0 18 * * 1-5`, `{{TIMEZONE}}`). Compare Notion edits since the previous run's cutoff with Librarian's sign-offs in the Agent change log. Always save a summary: window start, window end, and unsigned count. The next run starts at that cutoff. Report an unsigned write (page, which bot if knowable, time) to Fleet Ops only when the unsigned count is not zero.
- **Fleet snapshot** (optional). Owner: Fleet Ops. Schedule: `0 2 * * *` (about 02:00, `{{TIMEZONE}}`). Export into the private {{FLEET_REPO}} only. Put each routine in its own markdown file, grouped by bot, with the export fields as front matter. Put each profile in its own markdown file. No one-off prompts. A deleted routine stays, marked deleted. Run `scripts/snapshot.sh`, which scans with `scripts/snapshot-leak-patterns.txt` (credentials only), then commit and push to that private repo. Stay quiet on success. Do not point this at the public starter kit.
- **Usage report** (optional, template only). Owner: Fleet Ops. Schedule: owner's choice (for example `0 7 * * 1-5`, `{{TIMEZONE}}`). Ask the platform's usage tool what ran since the previous report: which bots, which routines, and whether quota moved. Draft a short note for Chief of Staff. Do not copy raw charges into {{FLEET_REPO}}, {{KB}}, or this repo. This template has no sample figures. If the tool is missing, say inconclusive.
