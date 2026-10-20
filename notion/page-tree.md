# Page tree

Generic outline of the private Notion space. Names are suggestions. Top-level pages (the same list the Librarian profile and the install use): Personal, Tasks, Inbox, Workstreams, Domains, Operating system, Reference, Archive.

```
(private root)
├── Personal                     placeholder for personal pages
├── Tasks                        database, top of the sidebar
├── Inbox                        unsorted captures; Librarian files them
├── Workstreams                  time-bounded efforts, one page each
├── Domains                      long-lived named sandboxes (never flatten)
│   ├── Dev sandbox
│   │   ├── _Shared conventions
│   │   └── Products
│   │       ├── _Template product   (Backlog + Delivery databases)
│   │       └── Product N           (copied from the template)
│   └── <Hobby domain>           dated child pages
├── Operating system
│   ├── Home                     summary page with embedded views
│   ├── Projects                 database; each project page holds a brief,
│   │                            a decision log, optional project-only databases
│   ├── Notes                    database
│   ├── Categories               database
│   ├── Todo types               database, next to Categories
│   └── Agent README             the bot rules page (see below)
│       └── Agent change log     inline database
├── Reference
│   ├── Architecture Reference   design record for this system
│   ├── Research                 one page per finished research, filed by Librarian
│   └── <Other guides>
└── Archive                      pages move here; rows use Status Archived
```

## Agent README (the bot rules page)
Every bot reads this at the start of each session. Sections:
1. Where things live (this tree, in short).
2. What bots may do: read and search anywhere; query databases only through saved views; every write goes to Notion Librarian.
3. Task rules: Tasks is the only to-do list; notes on every task; Todo type and Follow up usage.
4. Privacy: no Notion links in chat or email for coworkers; no secrets or private details on shared pages.
5. Sign every write: Librarian logs each write in the Agent change log.
6. Do-not-touch list: pages no bot edits.
7. Checklist for a new bot.
8. Agent change log (inline database).

## Research page format
Title, date, question, requester, answer, then findings, each marked confirmed, unconfirmed, or not found, with sources.
