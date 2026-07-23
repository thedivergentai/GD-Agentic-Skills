# Phase 4 — Economy, Retention & Reward Cadence

**Goal:** Validate the player's economic life with the same rigor as session difficulty. A perfect difficulty matrix is still a broken game if the shop is unreachable, a farm exists, or reward cadence has a dead plateau.

## Model every currency end-to-end

From the Phase 0 economy map:

- **In-run currency**: earn formulas + sinks; styles spend via `spend_budget_fraction` / `cash_reserve`.
- **Meta currency**: first-clear, **new-best vs replay** (track separately — farm detection), mode payouts.
- **Conversion / unlock bookkeeping**: reproduce the game's exact progression math (prefer extracted from save/progression Resources).

## Career simulation (`career`)

Chain full progressions into a `CareerTimeline`:

1. Fresh save → frontier session with current loadout.
2. On win: rewards + unlocks; on loss: style fallback (retry / grind earlier / secondary mode).
3. Shopping policy against the price ladder before each attempt.
4. Record: wall-clock minutes, attempts/session, balances over time, purchase timestamps, mode episodes.

Hundreds of careers → distributions, not anecdotes. Report minutes-to-each-purchase, attempts-per-session, balance curve, time-to-complete.

### Career red flags

- **Unreachable shop tier** — median career never affords an item before content ends.
- **Zero-grind completion** — everything on first pass; meta-economy decorative.
- **Grind walls** — purchases need many repeats of mastered content (vs Phase 0 minute targets).
- **Dominant farm** — one session/mode >> currency/minute of everything else.

## Replay vs frontier

Healthy: new-best delta + modest flat replay. Check `replay_cpm` vs frontier income. Flat `grade × N` every clear is a farm. After nerfs, **always** re-run careers (over-nerf check).

## Modes as economic organs

Per mode: `currency_per_minute` by style; win/metric bands; career integration (`grinder` must actually route through better-paying modes). Cap unintended mode dominance (e.g. no mode > ~1.5× intended best unless designated grind mode).

## Interest curve

Across session index, per style: primary metric + grade; intensity proxies; new-content cadence (each session should introduce ≥1 new element unless intentional breather). Flag cliffs, inversions, and 3+ same-intensity plateaus.

## Reward-cadence checkpoints (measurable)

| Loop | Check | FAIL if |
|------|-------|---------|
| Micro (seconds) | In-run spend for spending styles | `spend_avg ≈ 0` while `cash_end` high |
| Meso (session) | Grade histogram has improvement room | Everyone max grade or stuck at floor |
| Macro (days) | Purchase timestamps from careers | Gap > 3× median inter-purchase interval |

## Deliverable

Economy report (text + JSON): currency/minute matrix, career timelines, replay-vs-frontier ratios, interest-curve table, PASS/WARN per red-flag and cadence rule.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- https://docs.godotengine.org/en/stable/classes/class_json.html
- https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource-first extract
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — Phase 7 headless calibration
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md
-->
