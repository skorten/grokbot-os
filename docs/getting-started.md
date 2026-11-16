# Getting started with your fleet

In this tutorial you use a finished install for one recurring job, a weekly status digest. You start with the coordinator bot (chief of staff), then hand work to other bots, then save a repeated procedure as a skill, and last, put that skill on a schedule as a routine. Each part reuses what the part before it built.

The tutorial starts after the install. If you haven't installed yet, follow the [install prompt](../README.md#install-prompt) and the [install steps](../architecture.md#8-install-written-to-the-installing-bot) first, and finish the step 7 checklist.

## What you need

Before you start, check that you have these:

- The coordinator bot, the knowledge-base steward, the fleet steward, the bot designer, the research bot, and the admin bot, all created during the install.
- The docs steward. It is optional in the install. If you skipped it, ask the bot designer to create it.
- Your knowledge base, `{{KB}}`, with the Tasks database and its saved views.
- Your time zone, `{{TIMEZONE}}`, set on every routine.

## The running example

You run a sample project called "Website refresh." Every Friday you owe your team a short status digest for it. By the end of the tutorial, a routine drafts that digest for you each Friday, and you approve it before anything goes out.

## Part 1. Use the coordinator bot day to day

The coordinator bot is your front door. Send it any request that doesn't clearly belong to one bot. It routes the request, checks the result, and reports back in five lines or fewer. It reads and triages. It never builds.

### Read your brief

The install set up three routines on the coordinator bot: the what-needs-you brief, the daily task review, and the end-of-day update. Their schedules are in [routines.md](../routines.md).

1. Wait for the next brief. It arrives on weekdays at 8 AM, noon, and 4 PM in `{{TIMEZONE}}`, unless you changed the times.
2. Read it top down. Decisions and deadlines come first. If nothing needs you, the brief is one line that says so.

You can also ask for one at any time:

```text
What needs me today?
```

### Add a commitment

Tell the coordinator bot about the digest:

```text
I owe the team a status digest for the Website refresh project every Friday. Add it as a task.
```

The coordinator bot doesn't write to `{{KB}}` itself. It sends the task to the knowledge-base steward with notes and a todo type, and tells you "queued." When the knowledge-base steward confirms, the coordinator bot tells you the task exists.

Expected result: the task appears in the open-tasks view in `{{KB}}`.

### Answer the daily task review

The daily task review is the only place the stale sweep runs. It posts two lists: questions about stale tasks, then open tasks it isn't asking about.

1. Reply to each question in the same chat, for example "Next step: collect this week's updates."
2. Check the confirmation. The coordinator bot sends each answer to the knowledge-base steward and confirms when the change is in.

The review never changes a task on its own. Only your reply does.

### Route approvals through the coordinator bot

Every outgoing email or message starts as a draft card. When any bot needs your approval, the coordinator bot asks you, and you answer in its chat with one yes or no. The coordinator bot then relays your answer to the bot that acts. The relay quotes your exact words and the time you said them, and it covers only what those words name. A bot accepts a relay that meets these rules. If a bot refuses one, the coordinator bot sends the case to the fleet steward, and the fleet steward sends it to the bot designer. The bot designer re-pastes the shipped Approval routing block word for word, without waiting for you. Any other profile edit needs your yes.

Five actions are excluded from relay: a purchase, a send outside the fleet, publishing, a delete or trash, and creating a bot. For those, give your own yes in the chat of the bot that acts. A relayed yes doesn't count for them.

A relay to the knowledge-base steward looks like this:

```text
Relay from the coordinator bot. {{OWNER_NAME}} said at 2:14 PM {{TIMEZONE}} on Thursday: "Yes, set the digest task's follow-up date to Friday." Scope: that follow-up date only.
```

Parts 2 to 4 all depend on this rule.

## Part 2. Engage the other bots

You can reach a bot two ways: through the coordinator bot, or directly in that bot's own chat. Use the coordinator bot when you don't know which bot owns the work, or when you want one report back. Go direct when you know the owner and want to work back and forth with it.

### Route through the coordinator bot

Ask the coordinator bot a research question for the digest:

```text
Find out what a good weekly project status digest includes. Keep it short.
```

The coordinator bot hands the question to the research bot. The research bot answers with each finding marked confirmed, unconfirmed, or not found, with sources. It sends the full write-up to the knowledge-base steward for filing. The coordinator bot checks the answer against your question and reports back.

Expected result: a reply of five lines or fewer from the coordinator bot, and a filed research page in `{{KB}}`.

Bots message each other between turns. An answer arrives on the receiver's next turn, so a routed request can take a few minutes.

### Work directly with a bot

Open the docs steward's chat and ask for the first digest:

```text
Draft this week's status digest for the Website refresh project. Use the research the research bot just filed. Sections: done, next, blocked. Under 200 words.
```

The docs steward names its mode, drafts in markdown, and runs its prose audit. It publishes to `{{WIKI}}` only when you say yes for that doc, in its own chat. Publishing is one of the five actions excluded from relay.

When you work directly, the bot reports only to you, and the coordinator bot hears nothing. Tell the coordinator bot about any new commitment that comes out of the chat, so the task list stays complete.

### Report a gap

If no bot owns a request, the coordinator bot says so and tells the fleet steward. It doesn't absorb the work. The fleet steward proposes a fix, and the bot designer builds it after your yes in the bot designer's chat.

## Part 3. Set up a skill

By the third Friday you'll notice you type the same instructions each time: the sections, the sources, the word limit. That repetition is the signal for a skill.

### Decide whether it is a skill

The repo's design bar sorts recurring work four ways:

- A procedure that a bot repeats, or that several bots repeat, becomes a skill.
- A procedure that runs on a schedule becomes a routine. You'll build one in part 4.
- A fact a bot must remember becomes memory.
- A new bot is the last choice. The fleet steward proposes one only when one bot holds two jobs.

The digest is a procedure with fixed steps. That makes it a skill saved by the docs steward.

### Save the procedure as a skill

1. In the docs steward's chat, ask it to save the procedure:

	```text
	Save how you write the Website refresh digest as a skill: the sources you read, the three sections, the 200-word limit, and the prose audit. Then use that skill for the digest from now on.
	```

2. Ask for next week's digest with one line: "Write the Website refresh digest."

Expected result: the draft follows the same sections and limit without the long instructions.

A bot saves a skill when you ask it to. Skills are shared across all of your bots, so any of them can use it. If the skill adds a rule, the bot designer reviews it first (see [profiles/bot-designer.md](../profiles/bot-designer.md)).

### Add a rule only through the bot designer

If the skill needs a new rule, such as "never name a customer in the digest," send the rule to the bot designer first. The bot designer checks it for conflicts and wording, recommends which bots get it, and applies nothing until you say yes. Answer through the coordinator bot, which relays your words and the time.

## Part 4. Set up a routine

A routine runs a task on a schedule or on a narrow trigger. Set one up after the procedure works by hand and lives in a skill, so the routine prompt can stay one line long.

### Check the routine rules

Every routine in the repo follows the same rules from [routines.md](../routines.md):

- It drafts only. It never sends, buys, or applies a change that needs approval, and it never waits on an approval card.
- It sends every knowledge-base write to the knowledge-base steward.
- It reads databases only through saved views.
- It hands its result back to the bot that owns the routine. That bot messages the coordinator bot with priority true.
- It stays quiet when there's nothing to report, unless its prompt says to send one line.

### Create the digest routine

1. Pick the schedule. Routines use standard five-field cron in `{{TIMEZONE}}`. For Fridays at 3 PM, use `0 15 * * 5`.
2. In the docs steward's chat, ask it to create the routine:

	```text
	Create a routine on yourself. Schedule: 0 15 * * 5 in {{TIMEZONE}}. Prompt: Use the Website refresh digest skill to draft this week's digest. Hand the draft back to the docs steward. Don't publish or send it. If nothing moved this week, send nothing.
	```

	The docs steward then sends the draft to the coordinator bot with priority true.

3. Ask the bot designer to add the routine to the docs steward's profile under "Routines owned." Each bot creates and edits only its own routines. The bot designer applies those profile edits after your yes. The coordinator bot can relay that yes.
4. Run the routine once by hand and read the draft.

Each routine has one owner bot, runs on its schedule, and is exported to the fleet steward. You can add routines of your own beyond the core set. Follow the hygiene rules in [routines.md](../routines.md).

### Approve the Friday draft

On Friday the coordinator bot shows you the draft. Read it, then tell the docs steward in its own chat to publish it to `{{WIKI}}` or to send it. Publishing and outside sends are excluded from relay, so this yes goes in the docs steward's chat.

Expected result: a draft arrives each Friday, and the digest goes out only after your yes.

### Let the fleet steward watch it

The fleet steward's weekly checkup reads every bot's routines. It flags a routine that waits on approval, a trigger that matches too broadly, or a bot that took on a second job. Its daily check-in reports failed or missed runs to the coordinator bot. You don't need to do anything to turn this on.

## What you built

- A task that the coordinator bot tracks and reviews.
- A research answer routed through the coordinator bot, and a draft made in direct work with the docs steward.
- A skill that holds the digest procedure.
- A routine that runs the skill each Friday and stops at a draft for your yes.

To build the next one, start again at part 1 with a new commitment.
