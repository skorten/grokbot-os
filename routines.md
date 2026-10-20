# Routines

Exactly five core routines. Each belongs to one bot. Optional add-ons are listed at the end and are not part of the core set. Schedules are standard 5-field cron (minute hour day-of-month month day-of-week), evaluated in `{{TIMEZONE}}` (for example `America/New_York`). Edit times to fit the owner's day.

Rules that apply to every routine:
- **Draft only.** A routine detects, summarizes, and drafts. It never sends, buys, or applies a change that needs approval, and never waits on an approval card (cards can expire with nobody around).
- **Notion writes go to Librarian.** A routine that changes a task sends the change to Notion Librarian; it never writes Notion itself.
- **Database reads go through saved views.** Never SQL or rows mode.
- **Messages to Chief of Staff use priority true.**
- **Quiet means quiet.** No "(no change.)" filler unless the routine says to send one line.

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

> Run the weekly fleet checkup. Scan every bot's profile, its routines, and the past week's transcript friction (repeated corrections, handoffs that bounced, work landing on the wrong bot). Score the fleet on the design tests in your profile: one job per bot, clone generalists, front-door bots doing the work, group chats with no board, open or broad listeners, routines that would wait on an approval, and any proposal leaning on bot separation as a safeguard. Report proposals as keep / update / create / prune, each with the bot, the problem, and the fix. Creates and redesigns become a brief for Bot Designer; new rules go to Bot Designer for review first. Deletes are proposals only. Change nothing without {{OWNER_NAME}}'s yes.

- **When to stay quiet:** if nothing is worth proposing, send nothing.

---

## 5. Daily fleet check-in

- **Owner:** Fleet Ops
- **Schedule:** `45 6 * * 1-5` (weekdays 6:45 AM, `{{TIMEZONE}}`, before the first brief)
- **Prompt:**

> Check every bot's routines for failed or missed runs, open blockers, and stale approvals, and diff any profile changed since yesterday. If anything is stuck or drifting, send Chief of Staff (priority true) one short report of no more than 5 lines, each naming the bot, the problem, and a suggested fix. Change nothing. Design and overlap review waits for the weekly checkup.

- **When to stay quiet:** if nothing is wrong, send nothing.

---

## Optional add-ons (not part of the core five)

Add these only if the owner wants them. Same rules: draft only, narrow triggers, priority true to Chief of Staff.

- **Invite watch** (optional). Owner: Admin Bot. Schedule: `*/15 8-19 * * 1-5` (`{{TIMEZONE}}`). Alert Chief of Staff only for new invites that start before the next brief: who, what, when, any visible conflict. One alert per invite, deduped across runs. Never accept, decline, or tentatively accept; apply only a decision Chief of Staff relays. Quiet when there's nothing new.
- **Write audit** (optional). Owner: Notion Librarian. Schedule: owner's choice (for example `0 18 * * 1-5`). Compare recent Notion edits with Librarian's sign-offs in the Agent change log and report any unsigned write (page, which bot if knowable, time) to Fleet Ops. Quiet when everything is signed.
