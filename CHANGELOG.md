# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-11-16

First public release of the starter kit. It is a generic platform: fill the placeholders and run your own fleet.

### Added

- Fleet shape: one job per bot, a front-door coordinator, one writer for the knowledge base, approval gates, and a boundary between personal bots and team bots.
- Role profiles for the coordinator, knowledge-base steward, admin, research, docs steward, product delivery, sandbox, fleet steward, and bot designer, plus a copyable scaffold at `profiles/_template.md`.
- Default knowledge-base schema, saved views, and page tree under `notion/` for the Notion setup. Chat, mail, calendar, and wiki stay setup choices.
- Five core routines, with optional add-ons: invite watch, write audit, a private fleet snapshot, and a usage-report template with no sample figures.
- Design and operating patterns: approvals through the coordinator, a quoted relay with the time for exactly the named work (never a purchase, an outside send, publishing, a delete or trash, or creating a bot), quiet hours, one writer per shared store, saved-view reads, routine export, shopping-rule checks, and routine hygiene.
- Install steps for a blank bot (`architecture.md`, section 8) and a post-install tutorial (`docs/getting-started.md`).
- Leak scan and install consistency checks (`scripts/check.sh`). Extra patterns, when configured, come from the environment or a gitignored local file. `scripts/leak-patterns.txt` is an example and is not loaded.
- Version file (`VERSION`) and release steps (`RELEASING.md`).

### Changed

- Approvals route through the coordinator, and the owner answers there with one yes or no. Other bots accept the coordinator's relay when it quotes the owner's exact words and the time, and only for what those words name. If a bot will not follow that, the coordinator sends the case to the fleet steward, which sends the case to the bot designer, which re-pastes the shipped Approval routing block word for word, without waiting for the owner. Any other profile edit needs the owner's yes. Purchases, outside sends, publishing, a delete or trash, and creating a bot still need the owner's own yes in the chat of the bot that acts.
- The issue form names the repo owner, rather than a person, as the one who applies the agent-ready label.

### Fixed

- `scripts/check.sh` fails when it runs outside a git checkout or finds no files to scan. Before, it scanned zero files and printed "All checks passed." (#5)
